// imports
// constraints (SECRET, PERIOD, DIGITS)
// TOTP module
// display module
// usb keybord module
// RTIC app
        // init
        // button task
        // usb task
        // rtc task
// helper function

#![no_std]
#![no_main]
use panic_rtt_target as _;

use {
        command_parser::{parse_result, Command},
        systick_monotonic::fugit::{TimerInstantU64,ExtU32}, // For time handling with the monotonic timer
        hal::{
            clocks::Clocks, 
            usbd::{UsbPeripheral, Usbd},
            // For GPIO and serial peripherals
            gpio::{p0::Parts as P0Parts, p1::Parts as P1Parts, Level} //Output, Pin, PushPull}
        }, 
        nrf52840_hal::{self as hal}, 
        rtt_target::{rprintln, rtt_init_print}, // For RTT logging (terminal output)
        usb_device::{
            class_prelude::UsbBusAllocator,
            device::{StringDescriptors, UsbDeviceBuilder, UsbVidPid},
        }, 
        usbd_serial::{SerialPort, USB_CLASS_CDC},
       // nb::block,                                      // For blocking on serial reads/writes
        systick_monotonic::Systick,                   // For the monotonic timer based on SysTick
    };

// Global constants
//const SECRET: &[u8] = b"supersecret";           // need to be changed, should not be saved in a varible, should be send to the pcb via cutecom
static mut SECRET: [u8; 32] = [0; 32];          // allocated in memory instead
static mut SECRET_LEN: usize = 0;               // This allows us to receive a secret from cutecom, write it into a global buffre and then use it to compute the OPT code
// Its maby better to store the secret in an struct instace, the the serial handler will update the struct but the secret will only live as long as the struct live

const TIME_STEP: u64 = 30;                      
const DIGITS: u32 = 6;
const TIMER_HZ: u32 = 1000;

type Led = hal::gpio::Pin<hal::gpio::Output<hal::gpio::PushPull>>;
type Instant = TimerInstantU64<TIMER_HZ>;

mod totp {
        // TOTP module
}

mod display {
        // if the bords is not connected to the pc, a button press should display the OPT code
}

mod usb_keyboard {
        // maby convert code to string 
        // send digit as HID keybord events
}

#[rtic::app(device = nrf52840_hal::pac, dispatchers = [SWI0_EGU0])]
mod app {
    use super::*;

    use usbd_serial::embedded_io::Write as _;
    #[monotonic(binds = SysTick, default = true)]
    type MyMono = Systick<TIMER_HZ>;

   
    #[shared]
    struct Shared {
        unix_time: u64,
        duty: u8,       // Basically we want to share state between UART task(data_in) and Blik task(blink)
        period_ms: u32, // derived from frequency
        running: bool,  // start and stoprunning: bool,  // start and stop

    }

    #[local]
    struct Local {
        led1: Led,              // P0.13
        led_mirror: Led,        // P1.3
        //button: hal::gpio::Pin<hal::gpio::Input<hal::gpio::PullUp>>,
        usb_dev: usb_device::device::UsbDevice<'static, Usbd<UsbPeripheral<'static>>>,   // This controlls transfers and all USB protocol handling
        serial: SerialPort<'static, Usbd<UsbPeripheral<'static>>>,                        // The CDC-ACM serial interface ( the virtual COM port), read from and write to
        buf: [u8;64],                                                                     // 64  byte buffer used for reading and incoming USB data
    }
    #[init(local = [
        usb_bus: Option<UsbBusAllocator<Usbd<UsbPeripheral<'static>>>> = None,
        clocks: Option<Clocks<hal::clocks::ExternalOscillator,hal::clocks::Internal, hal::clocks::LfOscStopped>> = None,
    ])]
    fn init(cx: init::Context) -> (Shared, Local, init::Monotonics) {
        rtt_init_print!();
        rprintln!("\n--- init ---");

        // Initialize the monotonic (core clock at 64 MHz)
        let mut mono = Systick::new(cx.core.SYST, 64_000_000); 
        let device = cx.device;                             // Gives access  to all the harware periphials on the nRF52840( like USB, CLOCK, GPIO and more)
        //Enable USBD interrupt
        device.USBD.intenset.write(|w| w.sof().set());
        
        let port0 = P0Parts::new(device.P0);
        let port1 = P1Parts::new(device.P1);

        // LED
        // P0.13, connected to LED1 on nRF52840 DK
        let led1 = port0.p0_13.into_push_pull_output(Level::Low).degrade();
        let led_mirror =port1.p1_13.into_push_pull_output(Level::Low).degrade();

        // This sets up the clock to work with precise timing required by the USB
        let clocks = Clocks::new(device.CLOCK).enable_ext_hfosc();
        // make static lifetime for clocks, stores the value inside the RTICs local memory, ensures the value lives for the entire program (static liftime)
        cx.local.clocks.replace(clocks.enable_ext_hfosc());    // static lifetime = value nerver dropped or become invalid
        
        let usb_bus = UsbBusAllocator::new(Usbd::new(UsbPeripheral::new(
            device.USBD,
            cx.local.clocks.as_ref().unwrap(),// refer to static lifetime
        )));
        cx.local.usb_bus.replace(usb_bus);
        
        //let usb_bus = cx.local.usb_bus.as_ref().unwrap();
        let serial = SerialPort::new(&cx.local.usb_bus.as_ref().unwrap());

        // Init button
       // let port0 = P0Parts::new(device.P0);
       // let button = port0.p0_11.into_pullup_input().degrade();

        //let usb_bus = cx.local.usb_bus.as_ref().unwrap();
        let serial = SerialPort::new(&cx.local.usb_bus.as_ref().unwrap());

        let usb_dev = UsbDeviceBuilder::new(&cx.local.usb_bus.as_ref().unwrap(), UsbVidPid(0x16c0, 0x27dd))
            .strings(&[StringDescriptors::default()
                .manufacturer("Fake company")
                .product("Serial port")
                .serial_number("TEST")])
            .unwrap()
            .device_class(USB_CLASS_CDC)
            .max_packet_size_0(64) // (makes control transfers 8x faster)
            .unwrap()
            .build();

        // start blinking 
        let start_blink = mono.now() + 10.millis();
        blink::spawn_at(start_blink, start_blink).unwrap();

        #[allow(unreachable_code)]
        (Shared { unix_time: 0, duty: 50, period_ms: 1000, running: true}, Local {led1,led_mirror, usb_dev, serial, buf:[0u8; 64]}, init::Monotonics(mono))
    }

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



    // When the button is pressed and generate the OPT code and display it
   // #[task(binds = GPIOTE, shared = [unix_time])]
   // fn button (mut cx: button::Context){

        // Calculate the current time
       // let time = cx.shared.unix_time.lock(|t| *t);
        // caculate the right OPT code based on the time
        //let opt = totp::generate(SECRET, time);

       // display::show(opt)
  //  }
    // When USB is connected -> send OPT
    #[task(binds = USBD, priority = 1, shared = [unix_time, duty, period_ms, running], local = [ usb_dev, serial, buf, len: usize = 0, data_arr: [u8; 10] = [0; 10]])]
    fn usb_interrupt(mut cx: usb_interrupt::Context){
        // Calculate the current time
       // let time = cx.shared.unix_time.lock(|t| *t);
        // caculate the right OPT code based on the time
        //let opt = totp::generate(SECRET, time);

      //  usb_keyboard::send::code(opt);
      let usb_dev = cx.local.usb_dev;
        let serial = cx.local.serial;
        let buf = cx.local.buf;                 // Initial buffer that hold the incomming bytes from serial port
        let len = cx.local.len;                 // this is the counter that tracks how many characters has been stores in data_arr
        let data_arr = cx.local.data_arr;   // this is like a small buffer to store incomming characters extracted from the buf-buffer 

        // IMPORTANTE: Each time a command is sent from cutecom, the characters dont come all att ones, just one byte at the time?

        // checks whether new data has arrived, and if this is true call serial.read() or serial.write(). There is work to do
        if !usb_dev.poll(&mut [serial]) {
                return;
        }
        //rprintln!("usb interrupt!");
        // Read data
        let Ok(count) = serial.read(buf) else {return};   // if somthing has been recived, store it temporary in buf
        if count == 0 {
            return;
        }

        // loop through each byte indi.
        for &c in &buf[..count] {
            let _ = serial.write(&[c]);     // Echo 
            // If it has enter 13, treat it as a complete commad and parse and excecute it(then reset len = 0)
            // if not, store the byte into data_arr at index "len" abd increament "len"
            match c {
                13 => { // CR
                    let slice = &data_arr[0..*len]; // extract (slice) to get the refernce to the command
                    // Takes the slice and tries to match it with the right handler
                    match parse_result(slice) {
                                Ok(Command::Duty(val)) => {
                                    cx.shared.duty.lock(|d| *d = val);
                                    rprintln!("Duty set to {}", val);
                                    let _ = write!(serial, "Duty set to {}\r\n", val).ok();
                                }
                                // Handles Frequency command
                                Ok(Command::FrequencyHz(freq)) => {
                                    let period_ms = 1000 / freq;                               // Converts the desired frequency to the time period in miliseconds
                                    cx.shared.period_ms.lock(|p| *p = period_ms);         // updated the shared varible that hold the current value of the period_ms
                                    rprintln!("Frequency set to {}", freq);
                                    let _ = write!(serial, "Duty set to {} Hz\r\n", freq).ok();                 // Sends back confirmation to the serial terminal in CuteCom
                                }
                                // Handles the Start command
                                Ok(Command::Start) => {
                                    cx.shared.running.lock(|r| *r = true);                  // setting the running boolen to true, signaling the blink function to start 
                                    let now = monotonics::now();            // Gets the current mono timer timestamp, needed because blink::spawn_at requires a timestamp
                                    blink::spawn_at(now, now).ok();                                    // Immediate scheduling the blink function to runn now( current time extracted from the line above)
                                    let _ = write!(serial, "Started\r\n").ok();
                                }
                                // Handles the stop command
                                Ok(Command::Stop) => {
                                    cx.shared.running.lock(|r| *r = false);                 // Sets the shared running boolen to false
                                    let now = monotonics::now();
                                    let _ = write!(serial, "Stopped\r\n").ok();
                                }
                                Err(e) => {
                                    rprintln!("Parse error {:?}", e);
                                }
                            }
                            *len = 0;
                        }
                        _ => {
                            data_arr[*len] = c;
                            *len = usize::min(*len + 1, data_arr.len() - 1);        // len always point to the next free position
                        }
                    }
        }
    }  
}            
mod led {
    use embedded_hal::digital::v2::OutputPin;

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

