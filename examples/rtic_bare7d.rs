//! rtic_bare7d
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
    fugit::{MillisDurationU64, TimerInstantU64},
    hal::gpio::{Level, Output, Pin, PushPull},
    nrf52840_hal as hal, panic_rtt_target as _,
    rtt_target::{rprintln, rtt_init_print},
    systick_monotonic::*,
};

const TIMER_HZ: u32 = 4; // 4 Hz (250 ms granularity)
const TIME_0: Instant = TimerInstantU64::from_ticks(0); // Constant for time zero

type Led = Pin<Output<PushPull>>;
type Instant = TimerInstantU64<TIMER_HZ>;
type Duration = MillisDurationU64;

#[rtic::app(device = nrf52840_hal::pac, dispatchers= [TIMER0])]
mod app {
    use super::*;

    #[monotonic(binds = SysTick, default = true)]
    type MyMono = Systick<TIMER_HZ>;

    #[shared]
    struct Shared {}

    #[local]
    struct Local {
        led1: Led,
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

        // Initiate periodic process
        let next_instant = mono.now() + 1.secs();
        blink::spawn_at(next_instant, next_instant).unwrap();

        (Shared {}, Local { led1 }, init::Monotonics(mono))
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
    #[task(local = [cnt: u32 = 0, led1])]
    fn blink(cx: blink::Context, instant: Instant) {
        let duration_since_start: Duration = (instant - TIME_0).convert();
        rprintln!(
            "foo #{:?}, instant {:?}, duration since start {}",
            cx.local.cnt,
            instant,
            duration_since_start
        );
        if *cx.local.cnt % 2 == 0 {
            led::led_on(cx.local.led1);
        } else {
            led::led_off(cx.local.led1);
        }

        *cx.local.cnt += 1;

        // spawn next blink after 1 second
        let next_instant = instant + 1.secs();
        blink::spawn_at(next_instant, next_instant).unwrap();
    }
}

// This could be defined in a separated crate
// depending on embedded hal only.
mod led {
    use embedded_hal::digital::v2::OutputPin;
    use rtt_target::rprintln;

    #[inline(never)]
    pub fn led_on(_led: &mut impl  OutputPin) {
        rprintln!("led_on");
        _led.set_low().ok();
    }

    #[inline(never)]
    pub fn led_off(_led: &mut impl  OutputPin) {
        rprintln!("led_off");
        _led.set_high().ok();

       
    }
}
