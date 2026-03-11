//! rtic_bare8b.rs
//!
//! What it covers:
//! - serial communication
//! - good design
//!

#![no_main]
#![no_std]

use panic_rtt_target as _;

#[rtic::app(device = nrf52840_hal::pac, dispatchers = [TIMER0])]
mod app {

    use {
        command_parser::{parse, parse_result},
        cortex_m::asm,
        embedded_hal::serial::*,
        hal::{
            gpio::Level,
            pac::UARTE0,
            uarte::{self, UarteRx, UarteTx},
        },
        nb::block,
        nrf52840_hal as hal,
        rtt_target::{rprintln, rtt_init_print},
    };

    #[shared]
    struct Shared {}

    #[local]
    struct Local {
        tx: UarteTx<UARTE0>,
        rx: UarteRx<UARTE0>,
    }

    #[init(local = [
        SERIAL0_TX_BUF: [u8; 1] = [0; 1],
        SERIAL0_RX_BUF: [u8; 1] = [0; 1],
    ])]
    fn init(cx: init::Context) -> (Shared, Local, init::Monotonics) {
        rtt_init_print!();
        rprintln!("init");

        let device = cx.device;
        let p0 = hal::gpio::p0::Parts::new(device.P0);

        // enable UARTE0 endrx interrupt
        device.UARTE0.intenset.modify(|_, w| w.endrx().set_bit());

        let (tx, mut rx) = uarte::Uarte::new(
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

        // on NRF* serial interrupts are only called after the first read
        let _ = rx.read();

        (Shared {}, Local { tx, rx }, init::Monotonics())
    }

    #[idle()]
    fn idle(_cx: idle::Context) -> ! {
        rprintln!("idle");

        loop {
            rprintln!("sleep");
            asm::wfi();
            rprintln!("wake");
        }
    }

    #[task(capacity = 10, local = [tx, len: usize = 0, data_arr :[u8; 10] = [0; 10]])]

    fn data_in(cx: data_in::Context, data: u8) {
        let tx = cx.local.tx;
        let len = cx.local.len;
        let data_arr = cx.local.data_arr;

        rprintln!("data_in {}", data);
        block!(tx.write(data)).unwrap();
        match data {
            13 => {
                let slice = &data_arr[0..*len];
                rprintln!("return {:?}, str {:?}", slice, core::str::from_utf8(slice));
                rprintln!(
                    "parse {:?}, parse_result {:?}",
                    parse(slice),
                    parse_result(slice)
                );
                *len = 0;
            }
            _ => {
                data_arr[*len] = data;
                 //*len += 1;
                 *len = usize::min(*len + 1, data_arr.len() - 1);
            }
        }
    }

    #[task(binds = UARTE0_UART0, priority = 2, local = [rx])]
    fn uarte0_interrupt(cx: uarte0_interrupt::Context) {
        rprintln!("uarte0 interrupt");

        while match cx.local.rx.read() {
            Ok(b) => {
                rprintln!("Byte on serial0: {}", b);
                data_in::spawn(b).unwrap(); // panic if queue full
                true
            }
            Err(err) => {
                rprintln!("error {:?}", err);
                false
            }
        } {
            // just continue with next read
        }
    }
}
