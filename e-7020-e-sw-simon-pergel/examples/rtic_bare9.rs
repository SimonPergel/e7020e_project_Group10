//! rtic_bare9.rs
//!
//! What it covers:
//! - good design
//! - precise rtt tracing

#![no_main]
#![no_std]

use panic_rtt_target as _;

#[rtic::app(device = nrf52840_hal::pac, dispatchers = [TIMER0])]
mod app {

    use {
        command_parser::{parse, parse_result},
        core::fmt::Write,
        cortex_m::asm,
        embedded_hal::serial::{Read, Write as _},
        hal::{
            gpio::Level,
            pac::UARTE0,
            uarte::{self, UarteRx, UarteTx},
        },
        nb::block,
        nrf52840_hal as hal,
        rtt_target::{rtt_init, UpChannel},
    };
    use rtt_target::ChannelMode::NoBlockTrim;

    #[shared]
    struct Shared {}

    #[local]
    struct Local {
        rtt_idle: UpChannel,
        rtt_log: UpChannel,
        rtt_trace: UpChannel,
        tx: UarteTx<UARTE0>,
        rx: UarteRx<UARTE0>,
    }

    #[init(local = [
        SERIAL0_TX_BUF: [u8; 1] = [0; 1],
        SERIAL0_RX_BUF: [u8; 1] = [0; 1],
    ])]
    fn init(cx: init::Context) -> (Shared, Local, init::Monotonics) {
        let mut channels = rtt_init!(
            up: {
                0: {
                    size: 128,
                    name:"Idle"
                }
                1: {
                    size: 128,
                    mode: rtt_target::ChannelMode::BlockIfFull,
                    name:"Log",
                }
                2: {
                    size: 128,
                    name:"Trace"
                }
            }
        );
        writeln!(channels.up.0, "init").ok();

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

        (
            Shared {},
            Local {
                rtt_idle: channels.up.0,
                rtt_log: channels.up.1,
                rtt_trace: channels.up.2,
                tx,
                rx,
            },
            init::Monotonics(),
        )
    }

    #[idle(local = [rtt_idle])]
    fn idle(cx: idle::Context) -> ! {
        writeln!(cx.local.rtt_idle, "idle").ok();

        loop {
            writeln!(cx.local.rtt_idle, "sleep").ok();
            asm::wfi();
            writeln!(cx.local.rtt_idle, "wake").ok();
        }
    }

    #[task(capacity = 10, local = [rtt_log, tx, len: usize = 0, data_arr :[u8; 10] = [0; 10]])]

    fn data_in(cx: data_in::Context, data: u8) {
        let tx = cx.local.tx;
        let len = cx.local.len;
        let data_arr = cx.local.data_arr;

        writeln!(cx.local.rtt_log, "data_in {}", data).ok();
        block!(tx.write(data)).unwrap();
        match data {
            13 => {
                let slice = &data_arr[0..*len];
                writeln!(
                    cx.local.rtt_log,
                    "return {:?}, str {:?}",
                    slice,
                    core::str::from_utf8(slice)
                )
                .ok();
                writeln!(
                    cx.local.rtt_log,
                    "parse {:?}, parse_result {:?}",
                    parse(slice),
                    parse_result(slice)
                )
                .ok();
                *len = 0;
            }
            _ => {
                data_arr[*len] = data;
                *len += 1;
            }
        }
    }

    #[task(binds = UARTE0_UART0, priority = 2, local = [rtt_trace, rx])]
    fn uarte0_interrupt(cx: uarte0_interrupt::Context) {
        writeln!(cx.local.rtt_trace, "uarte0 interrupt").ok();

        while match cx.local.rx.read() {
            Ok(b) => {
                writeln!(cx.local.rtt_trace, "Byte on serial0: {}", b).ok();
                data_in::spawn(b).unwrap(); // panic if queue full
                true
            }
            Err(err) => {
                writeln!(cx.local.rtt_trace, "error {:?}", err).ok();
                false
            }
        } {
            // just continue with next read
        }
    }
}
