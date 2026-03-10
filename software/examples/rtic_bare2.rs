//! rtic_bare2.rs
//!
//! Measuring execution time
//!
//! What it covers
//! - Generating documentation
//! - Using core peripherals
//! - Measuring time using the DWT
//! - Inspecting binaries

#![no_main]
#![no_std]

use nrf52840_hal as _;
use panic_rtt_target as _;

#[rtic::app(device = nrf52840_hal::pac)]
mod app {
    use super::wait;
    use cortex_m::peripheral::DWT;
    use rtt_target::{rprintln, rtt_init_print};

    #[shared]
    struct Shared {}

    #[local]
    struct Local {}

    #[init]
    fn init(mut cx: init::Context) -> (Shared, Local, init::Monotonics) {
        rtt_init_print!();
        rprintln!("\n--- init ---\n");

        cx.core.DCB.enable_trace();
        cx.core.DWT.enable_cycle_counter();

        // Reading the cycle counter can be done without `owning` access
        // to the DWT (since reading it has no side effect).
        //
        // Look in the docs:
        // pub fn enable_cycle_counter(&mut self)
        // pub fn cycle_count() -> u32
        //
        // Notice the difference in the function signature!

        let start_count = DWT::cycle_count();
        wait(1_000_000);
        let end_count = DWT::cycle_count();

        // notice all printing outside of the section to measure!
        rprintln!("Start Count {:?}", start_count);
        rprintln!("End Count   {:?}", end_count);
        rprintln!("Diff Count  {:?}", end_count.wrapping_sub(start_count));

        (Shared {}, Local {}, init::Monotonics())
    }
}

// burns CPU cycles by just looping `i` times
#[inline(never)] // forbids inlining at call site
#[no_mangle] // identifier in human readable form
pub fn wait(i: u32) {
    for _ in 0..i {
        // no operation (ensured not optimized out)
        cortex_m::asm::nop();
    }
}
