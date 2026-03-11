//! rtic_bare7c
//!
//! What is covers:
//! - RTIC based timing using the Monotonic trait
//! - Implementing a timed protocol (Morse)
//! - Optionally implement Morse protocol using the PWM peripheral

#![no_main]
#![no_std]
#![deny(unsafe_code)]
#![deny(warnings)]

use {
    cortex_m::asm,
    embedded_hal::digital::v2::OutputPin,           // Standard GPIO output trait
    fugit::{MillisDurationU64, TimerInstantU64},
    hal::gpio::{Level, Output, Pin, PushPull},
    nrf52840_hal as hal, panic_rtt_target as _,
    rtt_target::{rprintln, rtt_init_print},
    systick_monotonic::*,
};

const TIMER_HZ: u32 = 1000;                             // Timer frequency for the mono timer
const TIME_0: Instant = TimerInstantU64::from_ticks(0); // Constant for time zero  , base reference

// duration for one "dit" in milisec
const SPEED_CONSTANT: u64 = 200;

// This array defines the SOS pattern, the values are dit units
const SEQ_SOS: [u32; 18] = [
    //S
    1, 1, 1, 1, 1, 3,
    //O
    4, 1, 4, 1, 4, 3,
    //S
    1, 1, 1, 1, 1, 7,

];

type Led = Pin<Output<PushPull>>;
type Instant = TimerInstantU64<TIMER_HZ>;   // used for scheduling tasks
type Duration = MillisDurationU64;          // Defines the time span

#[rtic::app(device = nrf52840_hal::pac, dispatchers= [TIMER0])]
mod app {
    use super::*;

    #[monotonic(binds = SysTick, default = true)]
    type MyMono = Systick<TIMER_HZ>;

    #[shared]
    struct Shared {}

    // Stored in RAM, can only belong to one TASk
    #[local]
    struct Local {
        led1: Led,
        step_index: usize,
    }

    #[init]
    fn init(cx: init::Context) -> (Shared, Local, init::Monotonics) {
        rtt_init_print!();
        rprintln!("\n---init---\n");

        // Initialize the monotonic (core clock at 64 MHz)
        let mut mono = Systick::new(cx.core.SYST, 64_000_000);
        let port0 = hal::gpio::p0::Parts::new(cx.device.P0);

        // LED
        // P0.13, connected to LED1 on nRF52840 DK
        let led1 = port0.p0_13.into_push_pull_output(Level::Low).degrade();

        // Initiate periodic process, after 1 sec ( schedules first morse process)
        let start_instance = mono.now() + 1.secs();
        morse::spawn_at(start_instance, start_instance).unwrap();

        (Shared {}, Local { led1, step_index: 0}, init::Monotonics(mono))
    }

    #[idle]
    fn idle(_cx: idle::Context) -> ! {
        rprintln!("idle");
        loop {
            // Puts the device into sleep.
            // However Systick requires the core clock of the MCU to be active
            // Thus we will get about 1.5mA
            asm::wfi();
            rprintln!("wake");
        }
    }

    // Drift free periodic task
    #[task(local = [cnt: u32 = 0, step_index, led1])]
    fn morse(cx: morse::Context, instant: Instant) {
        let duration_since_start: Duration = (instant - TIME_0).convert();

        rprintln!(
            "foo #{:?}, instant {:?}, duration since start {}",
            cx.local.cnt,
            instant,
            duration_since_start
        );
        let step_index= *cx.local.step_index;       // Hold the current step index of the array, where we currently has moved to in the SOS sequence array
        let _duration_unit = SEQ_SOS[step_index];

        // Even step_index -> LED OFF
        // ODD step_index -> LED ON
        if step_index % 2 == 0 {
            cx.local.led1.set_high().ok();
        } else {
            cx.local.led1.set_low().ok();
        }
        // Advance sequnece index by 1(one step forward) and when end of SOS array has been rached, wrap around and start over 
        // Note "%" resets both the step_inex and the SOS sequence array
        *cx.local.step_index = (step_index + 1) % SEQ_SOS.len();
        // Convert Morse units to millisec
        let _delay_ms = (_duration_unit as u64) * SPEED_CONSTANT;

        let next_instant = instant + _delay_ms.millis();
        morse::spawn_at(next_instant, next_instant).unwrap();
    }

}
