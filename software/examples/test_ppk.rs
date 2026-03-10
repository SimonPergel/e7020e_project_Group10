//! examples/rtic_bare4.rs
//!
//! Access to Peripherals
//!
//! What it covers:
//! - Raw pointers
//! - Volatile read/write
//! - GPIO (a primitive abstraction)
//! - Bitwise operations
//! blinking LED1 and PO1.13 at the same time so I can check whether i can use the PPK as logic
//! analyzer

#![no_std]
#![no_main]
#![allow(unused)]

use nrf52840_hal as _;
use panic_rtt_target as _;

// Peripheral addresses as constants
//
// See [nRF52840_PS_v1.7](https://infocenter.nordicsemi.com/pdf/nRF52840_PS_v1.7.pdf)
// - 6.9.2 GPIO registers

#[rustfmt::skip]
mod address {
    pub const GPIO_BASE: u32        = 0x5000_0000;
    pub const GPIO_P0: u32          = GPIO_BASE + 0x00;
    pub const P0_SET: u32           = GPIO_P0 + 0x508;
    pub const P0_CLR: u32           = GPIO_P0 + 0x50C;
    pub const P0_DIR: u32           = GPIO_P0 + 0x514;
    pub const P0_CNF: u32           = GPIO_P0 + 0x700;

    pub const GPIO_P1: u32          = GPIO_BASE + 0x300;
    pub const P1_SET: u32           = GPIO_P1 + 0x508;
    pub const P1_CLR: u32           = GPIO_P1 + 0x50C;
    pub const P1_DIR: u32           = GPIO_P1 + 0x514;
    pub const P1_CNF: u32           = GPIO_P1 + 0x700;
}

use address::*;

unsafe fn read_u32(addr: u32) -> u32 {
    core::ptr::read_volatile(addr as *const _)
}

unsafe fn write_u32(addr: u32, val: u32) {
    core::ptr::write_volatile(addr as *mut _, val);
}

fn wait(i: u32) {
    for _ in 0..i {
        cortex_m::asm::nop(); // no operation (cannot be optimized out)
    }
}

#[rtic::app(device = nrf52840_hal::pac)]
mod app {
    use super::*;
    use rtt_target::{rprintln, rtt_init_print};

    #[shared]
    struct Shared {}

    #[local]
    struct Local {}

    #[init]
    fn init(_: init::Context) -> (Shared, Local, init::Monotonics) {
        rtt_init_print!();
        rprintln!("\n--- init ---\n");
        (Shared {}, Local {}, init::Monotonics())
    }

    #[idle]
    fn idle(_: idle::Context) -> ! {
        rprintln!("\n--- idle ---\n");

        // for simplicity we mark the whole block unsafe
        unsafe {
             rprintln!("\nP0_DIR {}", read_u32(P0_DIR)); // D

            // Configure Pin 13 P0.13 as Output Pin
            write_u32(P0_CNF + 13 * 4, 1 << 0 ); // A
            // Configure Pin 13 P1.13 as Output Pin
            write_u32(P1_CNF + 13 * 4, 1 << 0 ); // A

            rprintln!("\nP0_DIR {}", read_u32(P0_DIR)); // D

            loop {

                // Sets the Pin driver to high, turning the LED off
                write_u32(P0_SET, 1 << 13); // B
                write_u32(P1_SET, 1 << 13); // B
                wait(1_000_000);
                // Sets the Pin driver to low, turning the LED on
                write_u32(P0_CLR, 1 << 13); // C
                write_u32(P1_CLR, 1 << 13); // C
                wait(1_000_000);
            }
        }
    }
}
