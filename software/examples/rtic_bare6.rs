//! examples/rtic_bare5.rs
//!
//! What it covers:
//! - writing your own low-level driver
//! - using a logic analyzer

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
            let r = self.read();
            rprintln!("r = {:b}", r);

            rprintln!("value = {:b}", value);
            let or_mask = 0; // replace with your own code
            rprintln!("or_mask {:b}", or_mask);
            let and_mask = 0; // replace with your own code
            rprintln!("and_mask {:b}", and_mask);

            let new_value = (r & and_mask) | or_mask;

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
        assert!(t.read() == 0b10101_000);

        t.modify(4, 3, 0b10001);
        //    old  .001_010_1000
        //    and  .111_000_1111
        //    or   .000_001_0000
        //    ------------
        //    new  .001_001_1000
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

    #[repr(C)]
    #[allow(non_snake_case)]
    #[rustfmt::skip]
    pub struct PWM {
        _PAD0:                      u32,                    // Padding in word  
        pub TASKS_STOP:             VolatileCell<u32>,      // 0x004
        pub TASKS_SEQSTART:         [VolatileCell<u32>; 2], // 0x008
        pub TASKS_NEXTSTEP:         VolatileCell<u32>,      // 0x010
        _PAD1:                      [u8; 0x104-0x014],      // Padding in bytes
        pub EVENTS_STOPPED:         VolatileCell<u32>,      // 0x104
        pub EVENTS_SEQSTARTED:      [VolatileCell<u32>; 2], // 0x108
        pub EVENTS_SEQEND:          [VolatileCell<u32>; 2], // 0x110
        pub EVENTS_PWMPERIODEND:    VolatileCell<u32>,      // 0x118
        pub EVENTS_LOOPSDONE:       VolatileCell<u32>,      // 0x11C
        _PAD2:                      [u8; 0x200 - 0x120],    // Padding in bytes
        pub SHORTS:                 VolatileCell<u32>,      // 0x200
        _PAD3:                      [u8; 0x300 - 0x204],    // Padding in bytes
        pub INTEN:                  VolatileCell<u32>,      // 0x300
        pub INTENSET:               VolatileCell<u32>,      // 0x304
        pub INTENCLR:               VolatileCell<u32>,      // 0x308
        _PAD5:                      [u8; 0x500 - 0x30c],    // Padding in bytes
        pub ENABLE:                 VolatileCell<u32>,      // 0x500
        pub MODE:                   VolatileCell<u32>,      // 0x504
        pub COUNTERTOP:             VolatileCell<u32>,      // 0x508
        pub PRESCALER:              VolatileCell<u32>,      // 0x50c
        pub DECODER:                VolatileCell<u32>,      // 0x510
        pub LOOP:                   VolatileCell<u32>,      // 0x514
        _PAD6:                      [u8; 0x520 - 0x518],    // Padding in bytes
        pub SEQ_0_PTR:              VolatileCell<u32>,      // 0x520
        pub SEQ_0_CNT:              VolatileCell<u32>,      // 0x524
        pub SEQ_0_REFRESH:          VolatileCell<u32>,      // 0x528
        pub SEQ_0_ENDDELAY:         VolatileCell<u32>,      // 0x52c
        _PAD7:                      [u8; 0x540 - 0x530],    // Padding in bytes
        pub SEQ_1_PTR:              VolatileCell<u32>,      // 0x540
        pub SEQ_1_CNT:              VolatileCell<u32>,      // 0x544
        pub SEQ_1_REFRESH:          VolatileCell<u32>,      // 0x548
        pub SEQ_1_ENDDELAY:         VolatileCell<u32>,      // 0x54c  
        _PAD8:                      [u8; 0x560 - 0x550],    // Padding in bytes
        pub PSEL_OUT:               [VolatileCell<u32>; 4], // 0x560
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

    #[allow(non_camel_case_types)]
    pub struct PWM0;

    impl PWM0 {
        pub fn get() -> *mut PWM {
            0x4001_C000 as *mut PWM
        }
    }
}
use nrf52840::*;

fn wait(i: u32) {
    for _ in 0..i {
        cortex_m::asm::nop(); // no operation (cannot be optimized out)
    }
}

#[repr(align(16))]
struct AlignedArray([u16; 4]);

#[rtic::app(device = nrf52840_hal::pac)]
mod app {
    use core::f32::consts;

    use nrf52840_hal::pwm;

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
        // raw_access::test_modify(); // D

        // GPIO(general-Purpose Input/output): Its the set of pins on the nrf52840 that can be programed to behave however we want, physical pins
        // GPIO registers: the sw controls that configure those pins 
        // PWM(pulse-Width Modulation): Turning a digial pin on and off very fast so the avergae output looks like an analog value. 

        let gpio_p0 = unsafe { &mut *GPIO_P0::get() }; // get the reference to GPIO in memory (address to gpio registers)
        let pwm0 = unsafe { &mut *PWM0::get() };        // get the reference to PWM0 in memory
        let gpio_p1 = unsafe { &mut *GPIO_P1::get() }; // get the reference to GPIO in memory

        // GPIO: configure P1.13 as output pins
        gpio_p0.PIN_CNF[13].write(1 << 0);
        gpio_p1.PIN_CNF[13].write(1 << 0);

        // GPIO: Enable the buttons
        gpio_p0.PIN_CNF[11].write((0 << 0) | (0 << 1) | (3 << 2));    // Enable Button1
        gpio_p0.PIN_CNF[12].write((0 << 0) | (0 << 1) | (3 << 2));    // Enable button2

        // PWM configureation
       let mut duty_cycle: u16= (32767/2);              // start at duty cycle 50%
       let mut pwm_seq1 = [duty_cycle];       // stores the current duty cycle
 
        pwm0.MODE.write(1);                         // Set UpDown mode
        //pwm0.PRESCALER.write(7);                  // set PRESCALAR = 7 (DIV128)
        pwm0.PRESCALER.write(4);                    // set PRESCALAR = 4 (DIV16), clock divider
        pwm0.COUNTERTOP.write(32767);               // set max value before reseting, defines the period 

        pwm0.PSEL_OUT[0].write(13);                 // PWM channel 0 -> P0-13 
        pwm0.PSEL_OUT[1].write(13 | (1 << 5));      // PWM channel 0 -> P1-13 
        pwm0.SEQ_0_PTR.write(&pwm_seq1 as *const _ as u32);     
        pwm0.SEQ_0_CNT.write(pwm_seq1.len() as u32);

    
        // start PWM
        pwm0.ENABLE.write(1);                       // Enable PWM, turns it on
        pwm0.TASKS_SEQSTART[0].write(1);

        rprintln!(" PWM is running!");
        rprintln!(" Use button 1 and 2 to change blinking rate");


        loop {
            //cortex_m::asm::wfi() // sleep until interrupt
            // Read GPIO input register
            let buttons = gpio_p0.IN.read();
            //Button 1, if pressed and inside valid range add 1000 to duty cycle and save in the duty buffer
            if ( buttons & (1 << 11)) == 0 {
                
                if duty_cycle < (32767 - 1000) {        
                    duty_cycle += 1000;
                    pwm_seq1[0] = duty_cycle;
                    rprintln!("Duty cycle increased: {}", duty_cycle); 
                    } else {                                                    // set to max value to avoid overflow
                        duty_cycle = 32767;
                        pwm_seq1[0] = duty_cycle;
                        rprintln!("Duty cycle decreased: {} (max value)", duty_cycle);
                    }
                }
            //Button 2, if pressed and inside valid range decrease with 1000 to duty cycle and save in the duty buffer
            if (buttons & (1 << 12)) == 0 {
                
                if duty_cycle > 999 {
                    duty_cycle -= 1000;
                    pwm_seq1[0] = duty_cycle;
                    rprintln!("Duty cycle decresed: {}", duty_cycle);
                    } else {                                                    // set to zero to avoid overflow
                        duty_cycle = 0;
                        pwm_seq1[0] = duty_cycle;
                        rprintln!("Duty cycle decresed: {} (min value)", duty_cycle); 
                    }
                }

             // stupid wait
            wait(100000); 
            // Restart PWM sequence so update duty cycle is applied
            pwm0.TASKS_SEQSTART[0].write(1);    
            }    
            
            }

           

        }

