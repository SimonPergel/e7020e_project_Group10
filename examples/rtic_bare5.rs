//! rtic_bare5.rs
//!
//! What it covers:
//! - abstractions in Rust
//! - `struct` and `impl`
//! - bitwise operations

#![no_std]
#![no_main]
#![allow(unused)]

use nrf52840_hal as _;
use panic_rtt_target as _;
use rtt_target::{rprintln, rtt_init_print};

mod raw_access {
    use super::*;

    use core::{cell, ptr};

    pub struct VolatileCell<T> {
        pub value: cell::UnsafeCell<T>,
    }

    impl<T> VolatileCell<T> {
        #[inline(always)]
        pub fn read(&self) -> T
        where
            T: Copy,
        {
            unsafe { ptr::read_volatile(self.value.get()) }
        }

        #[inline(always)]
        pub fn write(&mut self, value: T)
        where
            T: Copy,
        {
            unsafe { ptr::write_volatile(self.value.get(), value) }
        }
    }

    // modify (reads, modifies a field, and writes the volatile cell)
    //
    // parameters:
    // offset (field offset)
    // width  (field width)
    // value  (new value that the field should take)
    impl VolatileCell<u32> {
        #[inline(always)]
        pub fn modify(&mut self, offset: u8, width: u8, value: u32) {
            let r = self.read();                // read the current register value
            rprintln!("r = {:b}", r);

            rprintln!("value = {:b}", value);

            let field_mask = (1u32 << width) - 1;           // create a mask for the fild width
            let or_mask = (value & field_mask) << offset;   // extract the bits we are intrested in
            rprintln!("or_mask {:b}", or_mask);


            let and_mask = !(field_mask << offset);         // shift the mask and invert
            rprintln!("and_mask {:b}", and_mask);

            let new_value = (r & and_mask) | or_mask;
            rprintln!("new value {:b}", new_value);

            self.write(new_value);
        }
    }

    // simple test of Your `modify`
    pub fn test_modify() {
        let mut t: VolatileCell<u32> = VolatileCell {
            value: core::cell::UnsafeCell::new(0),
        };
        t.write(0);
        assert!(t.read() == 0);
        t.modify(3, 5, 0b1110101);
        //    old  .00_00000_000
        //    or   .00_10101_000
        //    ------------
        //    new  .00_10101_000
        #[allow(clippy::unusual_byte_groupings)]
        assert!(t.read() == 0b10101_000);

        t.modify(4, 3, 0b10001);
        //    old  .001_010_1000
        //    and  .111_000_1111
        //    or   .000_001_0000
        //    ------------
        //    new  .001_001_1000
        #[allow(clippy::unusual_byte_groupings)]
        assert!(t.read() == 0b1_001_1000);
        //
        // add more tests here if you like
    }
}

// C like API...
mod nrf52840 {
    use super::raw_access::*;

    #[repr(C)]
    #[allow(non_snake_case)]
    #[rustfmt::skip]
    pub struct GPIO {
        pub OUT:        VolatileCell<u32>,      // 0x504 Write GPIO port
        pub OUT_SET:    VolatileCell<u32>,      // 0x508 Set individual bits in GPIO port
        pub OUT_CLR:    VolatileCell<u32>,      // 0x50c Clear individual bits in GPIO port
        pub IN:         VolatileCell<u32>,      // 0x510 Direction of GPIO pins
        pub DIR:        VolatileCell<u32>,      // 0x514 Direction of GPIO pins
        pub DIR_SET:    VolatileCell<u32>,      // 0x518 DIR set register
        pub DIR_CLR:    VolatileCell<u32>,      // 0x51c DIR clear register
        pub LATCH:      VolatileCell<u32>,      // 0x520 Latch register indicating what GPIO pins that have met the criteria set in the PIN_CNF[n].SENSE registers
        pub DETECTMODE: VolatileCell<u32>,      // 0x524 Select between default DETECT signal behavior and LDETECT mode
        _PAD1:          [u8; 0x700-0x528],      // Padding in bytes  
        pub PIN_CNF:   [VolatileCell<u32>; 32], // 0x700 Configuration of GPIO pins           
    }

    #[allow(non_camel_case_types)]
    pub struct GPIO_P0;

    impl GPIO_P0 {
        pub fn get() -> *mut GPIO {
            (0x5000_0000 + 0x504) as *mut GPIO
        }
    }

    #[allow(non_camel_case_types)]
    #[allow(unused)]
    pub struct GPIO_P1;

    impl GPIO_P1 {
        pub fn get() -> *mut GPIO {
            (0x5000_0000 + 0x300 + 0x504) as *mut GPIO
        }
    }
}
use nrf52840::*;

fn wait(i: u32) {
    for _ in 0..i {
        cortex_m::asm::nop(); // no operation (cannot be optimized out)
    }
}

#[rtic::app(device = nrf52840_hal::pac)]
mod app {
    use super::*;

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
        raw_access::test_modify(); // D

        let gpio_p0 = unsafe { &mut *GPIO_P0::get() }; // get the reference to GPIOA in memory

        rprintln!("address PIN_CNF[13] {:p}", &gpio_p0.PIN_CNF[13]);

        gpio_p0.PIN_CNF[13].write(1 << 0); // A

        loop {
            gpio_p0.OUT_SET.write(1 << 13); // B
            wait(100_000);

            gpio_p0.OUT_CLR.write(1 << 13); // C
            wait(100_000);
        }
    }
}
