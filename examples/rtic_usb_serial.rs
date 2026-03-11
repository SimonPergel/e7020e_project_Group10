//! examples/rtc_usb_serial
//!
//! CDC-ACM serial port example using polling in a busy loop.S
#![no_std]
#![no_main]

use panic_rtt_target as _;

#[rtic::app(device = nrf52840_hal::pac)]
mod app {

    use {
        hal::clocks::Clocks,
        hal::usbd::{UsbPeripheral, Usbd},
        nrf52840_hal as hal,
        rtt_target::{rprintln, rtt_init_print},
        usb_device::{
            class_prelude::UsbBusAllocator,
            device::{StringDescriptors, UsbDeviceBuilder, UsbVidPid},
        },
        usbd_serial::{SerialPort, USB_CLASS_CDC},
    };

    #[shared]
    struct Shared {}

    #[local]
    struct Local {}

    #[init]
    fn init(cx: init::Context) -> (Shared, Local, init::Monotonics) {
        rtt_init_print!();
        rprintln!("\n--- init ---");

        let periph = cx.device;
        let clocks = Clocks::new(periph.CLOCK);
        let clocks = clocks.enable_ext_hfosc();

        let usb_bus = UsbBusAllocator::new(Usbd::new(UsbPeripheral::new(periph.USBD, &clocks)));
        let mut serial = SerialPort::new(&usb_bus);

        let mut usb_dev = UsbDeviceBuilder::new(&usb_bus, UsbVidPid(0x16c0, 0x27dd))
            .strings(&[StringDescriptors::default()
                .manufacturer("Fake company")
                .product("Serial port")
                .serial_number("TEST")])
            .unwrap()
            .device_class(USB_CLASS_CDC)
            .max_packet_size_0(64) // (makes control transfers 8x faster)
            .unwrap()
            .build();

        let mut buf = [0u8; 64];
        loop {
            if !usb_dev.poll(&mut [&mut serial]) {}

            match serial.read(&mut buf) {
                Ok(count) if count > 0 => {
                    // Echo back in upper case
                    for c in buf[0..count].iter_mut() {
                        if 0x61 <= *c && *c <= 0x7a {
                            *c &= !0x20;
                        }
                    }

                    let mut write_offset = 0;
                    while write_offset < count {
                        match serial.write(&buf[write_offset..count]) {
                            Ok(len) if len > 0 => {
                                write_offset += len;
                            }
                            _ => {}
                        }
                    }
                }
                _ => {}
            }
        }

        #[allow(unreachable_code)]
        (Shared {}, Local {}, init::Monotonics())
    }
}
