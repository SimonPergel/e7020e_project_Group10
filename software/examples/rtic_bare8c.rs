//! rtic_bare7d
//!
//! What is covers:
//! - RTIC based timing using the Monotonic trait
//! - Implementing a timed protocol (Morse)
//! - Optionally implement Morse protocol using the PWM peripheral

#![no_main]
#![no_std]
//#![deny(unsafe_code)]
//#![deny(warnings)]

use panic_rtt_target as _;

use {
        command_parser::{parse_result, Command},
        core::fmt::Write, // To format the strings we send over serial
        cortex_m::asm,    // For the wfi (wait for interrupt) instruction in the idle loop
        embedded_hal::{digital::v2::OutputPin, serial::Write as _, serial::*}, // For controlling the LED and serial communication
        systick_monotonic::fugit::{MillisDurationU64, TimerInstantU64,ExtU32}, // For time handling with the monotonic timer
        hal::{
            // For GPIO and serial peripherals
            gpio::{p0::Parts as P0Parts, p1::Parts as P1Parts, Level, Output, Pin, PushPull},
            pac::UARTE0,
            uarte::{self, UarteRx, UarteTx},
        },
        nb::block, // For blocking on serial reads/writes
        nrf52840_hal as hal,
        rtt_target::{rprintln, rtt_init_print}, // For RTT logging (terminal output)
        systick_monotonic::Systick,                   // For the monotonic timer based on SysTick
    };

const TIMER_HZ: u32 = 1000; // 4 Hz (250 ms granularity)
const TIME_0: Instant = TimerInstantU64::from_ticks(0); // Constant for time zero

type Led = hal::gpio::Pin<hal::gpio::Output<hal::gpio::PushPull>>;
type Instant = TimerInstantU64<TIMER_HZ>;
type Duration = MillisDurationU64;

//use nrf52840_hal::{pac::UART0, uarte::UarteRx};
//use usb_device::device;

#[rtic::app(device = nrf52840_hal::pac, dispatchers= [TIMER0])]
mod app {
    use crate::app::shared_resources::period_ms_that_needs_to_be_locked;

    use super::*;

    #[monotonic(binds = SysTick, default = true)]
    type MyMono = Systick<TIMER_HZ>;

    #[shared]
    struct Shared {
        duty: u8,       // Basically we want to share state between UART task(data_in) and Blik task(blink)
        period_ms: u32, // derived from frequency
        running: bool,  // start and stop
        data_arr: [u8; 10],
        len: usize,

    }

    #[local]
    struct Local {
        led1: Led,              // P0.13
        led_mirror: Led,        // P1.13
        tx: UarteTx<UARTE0>,
        rx: UarteRx<UARTE0>,
        
        
    }
    #[init(local = [
        SERIAL0_TX_BUF: [u8; 1] = [0; 1],
        SERIAL0_RX_BUF: [u8; 1] = [0; 1],
    ])]
    fn init( cx: init::Context) -> (Shared, Local, init::Monotonics) {
        rtt_init_print!();
        rprintln!("\n---init---\n");

        // Initialize the monotonic (core clock at 64 MHz)
        let mut mono = Systick::new(cx.core.SYST, 64_000_000); 
        let device = cx.device;
        let port0 = P0Parts::new(device.P0);
        let port1 = P1Parts::new(device.P1);

        // LED
        // P0.13, connected to LED1 on nRF52840 DK
        let led1 = port0.p0_13.into_push_pull_output(Level::Low).degrade();
        let led_mirror =port1.p1_13.into_push_pull_output(Level::Low).degrade(); 
        // enable UARTE0 endrx interrupt
        device.UARTE0.intenset.modify(|_, w| w.endrx().set_bit());
        // Initiate periodic process
        let (tx, mut rx) = uarte::Uarte::new(
            device.UARTE0,
            uarte::Pins {

                txd: port0.p0_06.into_push_pull_output(Level::High).degrade(),
                rxd: port0.p0_08.into_floating_input().degrade(),
                cts: None,
                rts: None,
            },
            uarte::Parity::EXCLUDED,
            uarte::Baudrate::BAUD115200,
        )
        .split(cx.local.SERIAL0_TX_BUF, cx.local.SERIAL0_RX_BUF)
        .expect("Could not split serial0");

        // on NRF* serial interrupts are only called after the first read, trigger first read
        let _ = rx.read();

        // start blinking 
        let start_blink = mono.now() + 10.millis();
        blink::spawn_at(start_blink, start_blink).unwrap();


        (Shared { duty: 50, period_ms: 1000, running: true, data_arr:[0;10], len: 0 }, Local { led1, led_mirror, tx, rx }, init::Monotonics(mono))
    }

    #[idle]
    fn idle(_cx: idle::Context) -> ! {
        rprintln!("idle");
        loop {
            // Puts the device into sleep.
            // However Systick requires the core clock of the MCU to be active
            // Thus we will get about 1.5mA
            asm::wfi();
            //rprintln!("wake");
        }
    }
    //Notes:
    // cx: This is the RTIC contex, which gives access to the shared and local resources
    // instant: the scheduled time at wich this task was triggered
    // RTICs mono timer passes the timestamp so you can schedule the next event drift-free

    // Software PWM using duty from Shared
    #[task(shared = [duty, period_ms, running], local = [cnt: u32 = 0, led1, led_mirror, is_on: bool = false])]
    fn blink( mut cx: blink::Context, instant: Instant) {
        let duty = cx.shared.duty.lock(|d| *d); // This ensures safe access to the shared data
        let period_ms = cx.shared.period_ms.lock(|d| *d);
        let running = cx.shared.running.lock(|d| *d);
        
        // STOP command -> led should be forced OFF and no recheduling
        if !running {
            led::led_off(cx.local.led1);        // P0.13 -> off
            led::led_off(cx.local.led_mirror);  // P1.13 -> off
            *cx.local.is_on = false;
            return;
        }

        //let period_ms = 1000;        
        let on_time = period_ms * duty as u32 /100;
        let off_time = period_ms - on_time;

        
        // If LED is currently ON -> turn OFF
        if *cx.local.is_on {
            led::led_off(cx.local.led1);        // P0.13 -> off
            led::led_off(cx.local.led_mirror);  // P1.13 -> off
            *cx.local.is_on = false;
            if running {
                blink::spawn_at(instant + off_time.millis(), instant + off_time.millis()).unwrap();
            }
           
        // IF its OFF -> turn ON
        } else {
            led::led_on(cx.local.led1);             // P0.13 -> on
            led::led_on(cx.local.led_mirror);       // P1.13 -> on
            *cx.local.is_on = true;
            if running {
                blink::spawn_at(instant + on_time.millis(), instant + on_time.millis()).unwrap();
            }
            
        }
    }


    //#[task(capacity = 10, shared = [duty], local = [tx, len: usize = 0, data_arr: [u8; 10] = [0; 10]])]
    // fn data_in(cx: data_in::Context, data: u8) {

    #[task(capacity = 20, shared = [duty, period_ms, running], local = [tx, len: usize = 0, data_arr: [u8; 10] = [0; 10]])]
    fn data_in( mut cx: data_in::Context, data: u8) {
        let tx = cx.local.tx;
        let len = cx.local.len;
        let data_arr = cx.local.data_arr;

        rprintln!("data_in {}", data);

        // Echo byte back
        block!(tx.write(data)).ok();
        
        match data {
            13 => { // CR
                let slice = &data_arr[0..*len];
                match parse_result(slice) {
                    Ok(Command::Duty(val)) => {
                        cx.shared.duty.lock(|d| *d = val);
                        rprintln!("Duty set to {}", val);
                        write!(tx, "Duty set to {}\r\n", val).ok();
                    }
                    // Handles Frequency command
                    Ok(Command::FrequencyHz(freq)) => {
                        let period_ms = 1000 / freq;                               // Converts the desired frequency to the time period in miliseconds
                        cx.shared.period_ms.lock(|p| *p = period_ms);         // updated the shared varible that hold the current value of the period_ms
                        rprintln!("Frequency set to {}", freq);
                        write!(tx, "Duty set to {} Hz\r\n", freq).ok();                 // Sends back confirmation to the serial terminal in CuteCom
                    }
                    // Handles the Start command
                    Ok(Command::Start) => {
                        cx.shared.running.lock(|r| *r = true);                  // setting the running boolen to true, signaling the blink function to start 
                        let now = monotonics::now();            // Gets the current mono timer timestamp, needed because blink::spawn_at requires a timestamp
                        blink::spawn_at(now, now).ok();                                    // Immediate scheduling the blink function to runn now( current time extracted from the line above)
                        write!(tx, "Started\r\n").ok();
                    }
                    // Handles the stop command
                    Ok(Command::Stop) => {
                        cx.shared.running.lock(|r| *r = false);                 // Sets the shared running boolen to false
                        let now = monotonics::now();
                        write!(tx, "Stopped\r\n").ok();
                    }
                    Ok(cmd) => {
                        write!(tx, "Unknown command {:?}\r\n", cmd).ok();
                        rprintln!("Unknown command {:?}\r\n", cmd);
                    }
                    Err(e) => {
                        rprintln!("Parse error {:?}", e);
                    }
                }
                *len = 0;
            }
            _ => {
                data_arr[*len] = data;
                *len = usize::min(*len + 1, data_arr.len() - 1);
            }
        }


    }

    #[task(binds = UARTE0_UART0, priority = 2, local = [rx])]
    fn uarte0_interrupt(cx: uarte0_interrupt::Context) {
        rprintln!("uarte0 interrupt");

        while match cx.local.rx.read() {
            Ok(b) => {
                rprintln!("Byte on serial0: {}", b);
                data_in::spawn(b).unwrap(); // panic if queue full
                true
            }
            Err(err) => {
                rprintln!("error {:?}", err);
                false
            }
        } {
            // just continue with next read
        }
    }
}

// This could be defined in a separated crate
// depending on embedded hal only.
mod led {
    use embedded_hal::digital::v2::OutputPin;
    use rtt_target::rprintln;

    #[inline(never)]
    pub fn led_on(_led: &mut impl  OutputPin) {
        //rprintln!("led_on");
        _led.set_low().ok();
    }

    #[inline(never)]
    pub fn led_off(_led: &mut impl  OutputPin) {
        //rprintln!("led_off");
        _led.set_high().ok();
  
    }
}                    
        
        

