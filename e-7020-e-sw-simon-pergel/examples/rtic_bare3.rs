//! rtic_bare3.rs
//!
//! What it covers
//! - Reading Rust documentation
//! - Timing abstractions and semantics
//! - Understanding Rust abstractions

#![no_main]
#![no_std]

use nrf52840_hal as _;
use panic_rtt_target as _;

#[rtic::app(device = nrf52840_hal::pac)]
mod app {
    use super::wait;
    use fugit::MillisDuration;
    use rtt_target::{rprintln, rtt_init_print};
    use systick_monotonic::*;

    // Default core clock at 64MHz
    const FREQ_CORE: u32 = 64_000_000;

    #[monotonic(binds = SysTick, default = true)]
    type MyMono = Systick<100>; // 100 Hz, 10 ms granularity

    #[shared]
    struct Shared {}

    #[local]
    struct Local {}

    #[init]
    fn init(cx: init::Context) -> (Shared, Local, init::Monotonics) {
        rtt_init_print!();
        rprintln!("\n--- init ---");

        let systick = cx.core.SYST;

        // Initialize the monotonic (SysTick driven by core clock)
        let mono = Systick::new(systick, FREQ_CORE);

        (Shared {}, Local {}, init::Monotonics(mono))
    }

    #[idle]
    fn idle(_cx: idle::Context) -> ! {
        let start = monotonics::now();
        wait(1_000_000);
        let end = monotonics::now();

        // notice all printing outside of the section to measure!
        rprintln!("Start {:?}", start);
        rprintln!("End {:?}", end);
        let duration = end - start;
        let millis: MillisDuration<u64> = duration.convert();

        // Formatting using the Debug trait
        rprintln!("Diff {:?}", millis);
        // Formatting using the Display trait
        rprintln!("Diff {}", millis);
        loop {}
    }
}

// burns CPU cycles by just looping `i` times
#[inline(never)]
#[no_mangle]
fn wait(i: u32) {
    for _ in 0..i {
        // no operation (ensured not optimized out)
        cortex_m::asm::nop();
    }
}
