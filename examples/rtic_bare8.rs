//! rtic_bare8.rs
//!
//! What it covers:
//! - serial communication
//! - bad design
//!

#![no_main]
#![no_std]

use panic_rtt_target as _;

#[rtic::app(device = nrf52840_hal::pac, dispatchers = [])]
mod app {

    use {
        embedded_hal::serial::*,
        hal::{
            gpio::Level,
            uarte::{self},
        },
        nb::block,
        nrf52840_hal as hal,
        rtt_target::{rprintln, rtt_init_print},
    };

    #[shared]
    struct Shared {}

    #[local]
    struct Local {}

    #[init(local = [
        SERIAL0_TX_BUF: [u8; 1] = [0; 1],
        SERIAL0_RX_BUF: [u8; 1] = [0; 1],
    ])]
    fn init(cx: init::Context) -> (Shared, Local, init::Monotonics) {
        rtt_init_print!();
        rprintln!("init");

        let device = cx.device;
        let p0 = hal::gpio::p0::Parts::new(device.P0);

        let (mut tx, mut rx) = uarte::Uarte::new(
            device.UARTE0,
            uarte::Pins {
                txd: p0.p0_06.into_push_pull_output(Level::High).degrade(),
                rxd: p0.p0_08.into_floating_input().degrade(),
                cts: None,
                rts: None,
            },
            uarte::Parity::EXCLUDED,
            uarte::Baudrate::BAUD115200,
        )
        .split(cx.local.SERIAL0_TX_BUF, cx.local.SERIAL0_RX_BUF)
        .expect("Could not split serial0");

        loop {
            match block!(rx.read()) {
                Ok(b) => {
                    rprintln!("Byte on serial0: {}", b);
                    block!(tx.write(b)).unwrap();
                }
                Err(err) => {
                    panic!("Read error {:?}", err);
                }
            }
        }

        #[allow(unreachable_code)]
        (Shared {}, Local {}, init::Monotonics())
    }
}
