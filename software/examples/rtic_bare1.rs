//! rtic_bare1.rs
//!
//! What it covers
//! - Compilation and Debugging
//! - Arithmetics and `panic`s.

#![no_main]
#![no_std]

use nrf52840_hal as _;
use panic_rtt_target as _;

#[rtic::app(device = nrf52840_hal::pac)]
mod app {

    use rtt_target::{rprintln, rtt_init_print};

    #[shared]
    struct Shared {}

    #[local]
    struct Local {}

    #[init]
    fn init(_: init::Context) -> (Shared, Local, init::Monotonics) {
        rtt_init_print!();
        rprintln!("\n--- init ---");

        (Shared {}, Local {}, init::Monotonics())
    }

    #[idle]
    fn idle(_: idle::Context) -> ! {
        rprintln!("--- idle ---");
        let mut x = core::u32::MAX - 1;

        increment(&mut x);
    }

    #[inline(never)]
    fn increment(i: &mut u32) -> ! {
        loop {
            *i += 1; // (A) <- put breakpoint at this line
        }
    }
}
