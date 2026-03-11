// imports
// constraints (SECRET, PERIOD, DIGITS)
// TOTP module
// display module
// usb keybord module
// RTIC app
        // init
        // button task
        // usb task
        // rtc task
// helper function

#![no_std]
#![no_main]

use panic_rtt_target as _;

use {
        command_parser::{parse_result, Command},
        systick_monotonic::fugit::{TimerInstantU64,ExtU32}, // For time handling with the monotonic timer
        hal::{
            clocks::Clocks, 
            usbd::{UsbPeripheral, Usbd},
            // For GPIO and serial peripherals
            gpio::{p0::Parts as P0Parts, p1::Parts as P1Parts, Level} //Output, Pin, PushPull}
        }, 
        //nrf52840_hal::{self as hal}, 
        nrf52833_hal::{self as hal},
        rtt_target::{rprintln, rtt_init_print}, // For RTT logging (terminal output)
        usb_device::{
            class_prelude::UsbBusAllocator,
            device::{StringDescriptors, UsbDeviceBuilder, UsbVidPid},
        }, 
        usbd_serial::{SerialPort, USB_CLASS_CDC},
       // nb::block,                                      // For blocking on serial reads/writes
        systick_monotonic::Systick,                   // For the monotonic timer based on SysTick
    };

// Global constants
//const SECRET: &[u8] = b"supersecret";           // need to be changed, should not be saved in a varible, should be send to the pcb via cutecom
static mut SECRET: [u8; 32] = [0; 32];          // allocated in memory instead
static mut SECRET_LEN: usize = 0;               // This allows us to receive a secret from cutecom, write it into a global buffre and then use it to compute the OPT code
// Its maby better to store the secret in an struct instace, the the serial handler will update the struct but the secret will only live as long as the struct live

const TIME_STEP: u64 = 30;                      
const DIGITS: u32 = 6;
const TIMER_HZ: u32 = 1000;

mod totp {
        // TOTP module
}

mod display {
        // if the bords is not connected to the pc, a button press should display the OPT code
}

mod usb_keybord {
        // maby convert code to string 
        // send digit as HID keybord events
}

#[rtic::app(device = nrf52833_hal::pac, dispatchers = [SWI0_EGU0])]
mod app {
        use super::*;

        use usbd_serial::embedded_io::Write as _;
    #[monotonic(binds = SysTick, default = true)]
    type MyMono = Systick<TIMER_HZ>;

   
    #[shared]
    struct Shared {
        unix_time: u64,
    }

    #[local]
    struct Local {
        button: hal::gpio::Pin<hal::gpio::Input<hal::gpio::PullUp>>,
        usb_dev: usb_device::device::UsbDevice<'static, Usbd<UsbPeripheral<'static>>>,   // This controlls transfers and all USB protocol handling
        serial: SerialPort<'static, Usbd<UsbPeripheral<'static>>>,                        // The CDC-ACM serial interface ( the virtual COM port), read from and write to
        buf: [u8;64],                                                                     // 64  byte buffer used for reading and incoming USB data
    }
    #[init(local = [
        usb_bus: Option<UsbBusAllocator<Usbd<UsbPeripheral<'static>>>> = None,
        clocks: Option<Clocks<hal::clocks::ExternalOscillator,hal::clocks::Internal, hal::clocks::LfOscStopped>> = None,
    ])]
    fn init(cx: init::Context) -> (Shared, Local, init::Monotonics) {
        rtt_init_print!();
        rprintln!("\n--- init ---");

        // Initialize the monotonic (core clock at 64 MHz)
        let mut mono = Systick::new(cx.core.SYST, 64_000_000); 
        let device = cx.device;                             // Gives access  to all the harware periphials on the nRF52840( like USB, CLOCK, GPIO and more)
        //Enable USBD interrupt
        device.USBD.intenset.write(|w| w.sof().set());
        

        // This sets up the clock to work with precise timing required by the USB
        let clocks = Clocks::new(device.CLOCK).enable_ext_hfosc();
        // make static lifetime for clocks, stores the value inside the RTICs local memory, ensures the value lives for the entire program (static liftime)
        cx.local.clocks.replace(clocks.enable_ext_hfosc());    // static lifetime = value nerver dropped or become invalid
        
        let usb_bus = UsbBusAllocator::new(Usbd::new(UsbPeripheral::new(
            device.USBD,
            cx.local.clocks.as_ref().unwrap(),// refer to static lifetime
        )));
        cx.local.usb_bus.replace(usb_bus);
        

        // Init button
        let port0 = P0Parts::new(device.P0);
        let button = port0.p0_11.into_pullup_input().degrade();

        //let usb_bus = cx.local.usb_bus.as_ref().unwrap();
        let serial = SerialPort::new(&cx.local.usb_bus.as_ref().unwrap());

        let usb_dev = UsbDeviceBuilder::new(&cx.local.usb_bus.as_ref().unwrap(), UsbVidPid(0x16c0, 0x27dd))
            .strings(&[StringDescriptors::default()
                .manufacturer("Fake company")
                .product("Serial port")
                .serial_number("TEST")])
            .unwrap()
            .device_class(USB_CLASS_CDC)
            .max_packet_size_0(64) // (makes control transfers 8x faster)
            .unwrap()
            .build();

        #[allow(unreachable_code)]
        (Shared { unix_time: 0,}, Local { button, usb_dev, serial, buf:[0u8; 64]}, init::Monotonics(mono))
    }

    // When the button is pressed and generate the OPT code and display it
    #[task(binds = GPIOTE, shared = [unix_time])]
    fn button (mut cx: button::Context){

        // Calculate the current time
        let time = cx.shared.unix_time.lock(|t| *t);
        // caculate the right OPT code based on the time
        let opt = totp::generate(SECRET, time);

        display::show(opt)
    }
    // When USB is connected -> send OPT
    #[task(binds = USBD, shared = [unix_time])]
    fn usb_interrupt(mut cx: usb_interupt::Contex){
        // Calculate the current time
        let time = cx.shared.unix_time.lock(|t| *t);
        // caculate the right OPT code based on the time
        let opt = totp::generate(SECRET, time);

        usb_keyboard::send:code(opt);
    }



}