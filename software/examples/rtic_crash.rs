// examples/rtic_crash.rs

#![no_main]
#![no_std]
#![deny(warnings)]

use cortex_m_rt::exception;
use nrf52840_hal as _;
use panic_rtt_target as _;
use rtt_target::{rprintln, rtt_init_print};

#[rtic::app(device = nrf52840_hal::pac)]
mod app {
    use super::*;
    use core::ptr;

    #[shared]
    struct Shared {}

    #[local]
    struct Local {}

    #[init]
    fn init(_: init::Context) -> (Shared, Local, init::Monotonics) {
        rtt_init_print!();
        rprintln!("\n--- init ---\n");
        unsafe {
            // read an address outside of the RAM region; this causes a HardFault exception
            ptr::read_volatile(0x2FFF_FFFF as *const u32);
        }
        (Shared {}, Local {}, init::Monotonics())
    }
}

#[exception]
unsafe fn HardFault(ef: &cortex_m_rt::ExceptionFrame) -> ! {
    rprintln!("{:#?}", ef);
    panic!();
}
// This example causes a HardFault. HardFaults are out of reach for
// for Rust to generate an appropriate error message.
//
// After dumping the exception frame it will do an explicit panic as defined by 
// by the active panic handler.

