//! examples/bare1.rs
//!
//! Inspecting the generated assembly in Vscode.
//!
//! What it covers
//! - Modular arithmetics by the Wrapping abstraction

#![no_main]
#![no_std]

use nrf52840_hal as _;
use panic_rtt_target as _;

#[rtic::app(device = nrf52840_hal::pac)]
mod app {
    use core::num::Wrapping;
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

    // idle never returns, function has the "never type" !
    #[idle]
    fn idle(_: idle::Context) -> ! {
        rprintln!("--- idle ---");
        let mut x = Wrapping(core::u32::MAX - 1);

        increment(&mut x);
    }

    #[inline(never)]
    pub fn increment(i: &mut Wrapping<u32>) -> ! {
        loop {
            *i += 1;
        }
    }
}
