#![no_std]
#![no_main]

use panic_rtt_target as _;

mod raw_access {
    use core::{cell, ptr};

    pub struct VolatileCell<T> {
        pub value: cell::UnsafeCell<T>,
    }

    impl<T> VolatileCell<T> {
        #[inline(always)]
        pub fn read(&self) -> T
        where
            T: Copy,
        {
            unsafe { ptr::read_volatile(self.value.get()) }
        }

        #[inline(always)]
        pub fn write(&mut self, value: T)
        where
            T: Copy,
        {
            unsafe { ptr::write_volatile(self.value.get(), value) }
        }
    }
}

// C like API...
mod nrf52840 {
    use super::raw_access::*;

    #[repr(C)]
    #[allow(non_snake_case)]
    #[rustfmt::skip]
    pub struct GPIO {
        pub OUT:        VolatileCell<u32>,      // 0x504 Write GPIO port
        pub OUT_SET:    VolatileCell<u32>,      // 0x508 Set individual bits in GPIO port
        pub OUT_CLR:    VolatileCell<u32>,      // 0x50c Clear individual bits in GPIO port
        pub IN:         VolatileCell<u32>,      // 0x510 Direction of GPIO pins
        pub DIR:        VolatileCell<u32>,      // 0x514 Direction of GPIO pins
        pub DIR_SET:    VolatileCell<u32>,      // 0x518 DIR set register
        pub DIR_CLR:    VolatileCell<u32>,      // 0x51c DIR clear register
        pub LATCH:      VolatileCell<u32>,      // 0x520 Latch register indicating what GPIO pins that have met the criteria set in the PIN_CNF[n].SENSE registers
        pub DETECTMODE: VolatileCell<u32>,      // 0x524 Select between default DETECT signal behavior and LDETECT mode
        _PAD1:          [u8; 0x700-0x528],      // Padding in bytes  
        pub PIN_CNF:   [VolatileCell<u32>; 32], // 0x700 Configuration of GPIO pins           
    }

    #[allow(non_camel_case_types)]
    pub struct GPIO_P0;

    impl GPIO_P0 {
        pub fn get() -> *mut GPIO {
            (0x5000_0000 + 0x504) as *mut GPIO
        }
    }
}

use nrf52840::*;

#[rtic::app(device = nrf52840_hal::pac, dispatchers = [TIMER0])]
mod app {
    use super::*;
    use {
        frunk::{HCons, HNil}, hal::{
            clocks::{Clocks, ExternalOscillator, Internal, LfOscStopped}, 
            usbd::{UsbPeripheral, Usbd}
        }, nrf52833_hal::{self as hal}, rtt_target::{rprintln, rtt_init_print}, systick_monotonic::{fugit::ExtU64, *}, usb_device::{
            class_prelude::UsbBusAllocator,
            device::{StringDescriptors, UsbDevice, UsbDeviceBuilder, UsbVidPid},
        }, usbd_human_interface_device::{device::keyboard::{NKROBootKeyboard, NKROBootKeyboardConfig}, page::Keyboard, prelude::{UsbHidClass, *}}, usbd_serial::{SerialPort}
    };

    const TIMER_HZ: u32 = 1000;

    #[monotonic(binds = SysTick, default = true)]
    type MyMono = Systick<TIMER_HZ>;

    #[shared]
    struct Shared {
        serial: SerialPort<'static, Usbd<UsbPeripheral<'static>>>,
        vir_keyboard: UsbHidClass<'static, Usbd<UsbPeripheral<'static>>, HCons<NKROBootKeyboard<'static, Usbd<UsbPeripheral<'static>>>, HNil>>,
        code: [Keyboard; 6],
        gpio_p0: &'static mut GPIO,
    }

    #[local]
    struct Local {
        usb_dev: UsbDevice<'static, Usbd<UsbPeripheral<'static>>>,
    }

    #[init(local = [
        usb_bus: Option<UsbBusAllocator<Usbd<UsbPeripheral<'static>>>> = None,
        clocks: Option<Clocks<ExternalOscillator, Internal, LfOscStopped>> = None
    ])]
    fn init(cx: init::Context) -> (Shared, Local, init::Monotonics) {
        rtt_init_print!();
        rprintln!("\n--- init ---");

        let periph = cx.device;
        periph.USBD.intenset.write(|w| w.sof().set());
        cx.local.clocks.replace(Clocks::new(periph.CLOCK).enable_ext_hfosc());

        let usb_bus: UsbBusAllocator<Usbd<UsbPeripheral<'_>>> = UsbBusAllocator::new(Usbd::new(UsbPeripheral::new(
            periph.USBD,
            cx.local.clocks.as_ref().unwrap(),
        )));
        cx.local.usb_bus.replace(usb_bus);
        let serial = SerialPort::new(&cx.local.usb_bus.as_ref().unwrap());

        // Create a 'virtual keyboard', i.e. a type which acts as a keyboard when connecting the nRF to a computer.
        let mut vir_keyboard = UsbHidClassBuilder::new()
            .add_device(NKROBootKeyboardConfig::default())
            .build(cx.local.usb_bus.as_ref().unwrap());

        // Had to change device class in order for windows to recognize it as a keyboard + serial connection.
        let mut usb_dev = UsbDeviceBuilder::new(cx.local.usb_bus.as_ref().unwrap(), UsbVidPid(0x16c0, 0x27dd))
            .strings(&[StringDescriptors::default()
                .manufacturer("Fake company")
                .product("Serial port + Keyboard")
                .serial_number("TEST")])
            .unwrap()
            .device_class(0xEF)
            .device_sub_class(0x02)
            .device_protocol(0x01)
            .max_packet_size_0(64) // (makes control transfers 8x faster)
            .unwrap()
            .build();

        let mono = Systick::new(cx.core.SYST, 64_000_000);
        // Keyboard is the type that a KeyboardReport is written as, here I assign 6 character code + Enter.
        let code: [Keyboard; 6] = [Keyboard::A, Keyboard::A, Keyboard::C, 
            Keyboard::D, Keyboard::F, Keyboard::F];

        let gpio_p0 = unsafe { &mut *GPIO_P0::get() }; // get the reference to GPIOA in memory
        gpio_p0.PIN_CNF[29].write(0b1100); // Enable button 1

        // Unlocks the button etc.
        unsafe {
            core::ptr::write_volatile(0x4000_6510 as *mut u32, 1 | (29 << 8) | (2 << 16));
            core::ptr::write_volatile(0x4000_6304 as *mut u32, 1);
        }

        hid_tick::spawn().ok();

        #[allow(unreachable_code)]
        (Shared {serial, vir_keyboard, code, gpio_p0}, Local {usb_dev}, init::Monotonics(mono))
    }

    #[task(binds = USBD, local = [usb_dev], shared = [serial, vir_keyboard])]
    fn usbd(cx: usbd::Context) {
        let usb_dev = cx.local.usb_dev;

        // Checks if something happens on the usb connection.
        (cx.shared.serial, cx.shared.vir_keyboard).lock(|serial, vir_keyboard| {
            if usb_dev.poll(&mut [serial, vir_keyboard]) {

            }
        });
    }

    // Checks if a button press happens, if it happens, spawn the send_data function.
    #[task(binds = GPIOTE, local = [last_press: u64 = 0])]
    fn button_interrupt(cx: button_interrupt::Context) {
        unsafe { core::ptr::write_volatile(0x4000_6100 as *mut u32, 0); }
        let now = monotonics::now().ticks();
        if now - *cx.local.last_press > 200 {
            *cx.local.last_press = now;
            send_data::spawn().ok();
        }
    }

    // Keeps the usb connection fresh so windows doesn't drop the connection.
    #[task(shared = [vir_keyboard, gpio_p0])]
    fn hid_tick(mut cx: hid_tick::Context) {
        cx.shared.vir_keyboard.lock(|vir_keyboard| {
            match vir_keyboard.tick() {
                Ok(_) => {}
                Err(_) => {}
            }
        });

        hid_tick::spawn_after(1u64.millis()).ok();
    }

    // Function to send data over to the computer.
    #[task(shared = [vir_keyboard, code], local = [index: usize = 0])]
    fn send_data(mut cx: send_data::Context) {
        rprintln!("\n--- send_data ---");
        let i = *cx.local.index;
        // Code variable is always 6 index long, loops through each digit, this is done so the same character
        // after each other can be sent.
        if i < 6 {
            let key = cx.shared.code.lock(|code| code[i]);

            cx.shared.vir_keyboard.lock(|vir_keyboard| {
                vir_keyboard.device().write_report([key]).ok();
            });

            *cx.local.index += 1;
            release_keys::spawn_after(20u64.millis()).ok();
            send_data::spawn_after(40u64.millis()).ok();
        }
        // When all digits are sent, reset index to 0 and send a Enter Keyboard command.
        else {
            *cx.local.index = 0;

            cx.shared.vir_keyboard.lock(|vir_keyboard| {
                vir_keyboard.device().write_report([Keyboard::ReturnEnter]).ok();
            });
            release_keys::spawn_after(20u64.millis()).ok();
        }
    }

    // Function to release the key, has to be done as otherwise windows will not regard it as a received character.
    #[task(shared = [vir_keyboard])]
    fn release_keys(mut cx: release_keys::Context) {
        let no_keys: [Keyboard; 0] = [];

        cx.shared.vir_keyboard.lock(|vir_keyboard| {
            vir_keyboard.device().write_report(no_keys).ok();
        });
    }
}