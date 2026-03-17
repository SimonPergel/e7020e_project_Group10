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
    hal::{
        clocks::Clocks,
        // For GPIO and serial peripherals
        gpio::{p0::Parts as P0Parts, p1::Parts as P1Parts, Level}, //Output, Pin, PushPull}
        usbd::{UsbPeripheral, Usbd},
    },
    nrf52840_hal::{self as hal},
    rtt_target::{rprintln, rtt_init_print}, // For RTT logging (terminal output)
    systick_monotonic::fugit::{ExtU32, TimerInstantU64}, // For time handling with the monotonic timer
    // nb::block,                                      // For blocking on serial reads/writes
    systick_monotonic::Systick, // For the monotonic timer based on SysTick
    usb_device::{
        class_prelude::UsbBusAllocator,
        device::{StringDescriptors, UsbDeviceBuilder, UsbVidPid},
    },
    usbd_serial::{SerialPort, USB_CLASS_CDC},
};

// Global constants
//const SECRET: &[u8] = b"supersecret";           // need to be changed, should not be saved in a varible, should be send to the pcb via cutecom

const TIME_STEP: u64 = 30;
const DIGITS: u32 = 6;
const TIMER_HZ: u32 = 1000;

type Led = hal::gpio::Pin<hal::gpio::Output<hal::gpio::PushPull>>;
type Instant = TimerInstantU64<TIMER_HZ>;

// Types for flash storage and NVMC peripheral, used in the secret_storage module to read/write secrets to flash memory
type FlashStorageBuf = [u8; secret_storage::PAGE_SIZE as usize];
type FlashNvmc = hal::nvmc::Nvmc<hal::pac::NVMC>;

mod totp {
    // TOTP module

    use super::*;

   """ use otp::{Totp, Algorithm, Secret};

    pub fn generate(secret: &[u8], unix_time: u64) -> u32 {
        let totp = Totp::new(
            Algorithm::SHA1,
            "dev".into(),
            "user".into(),
            super::DIGITS,
            super::TIME_STEP as u32,
            Secret::from_bytes(secret),
        );
        totp.generate(unix_time)
    }

    // init oneces

"""

}

mod display {
    // if the bords is not connected to the pc, a button press should display the OPT code
}

mod usb_keyboard {
    // maby convert code to string
    // send digit as HID keybord events
}

mod secret_storage {
    // use super::*;
    use crate::FlashNvmc;
    // I need this to be able to read/write to flash memory
    use embedded_storage::nor_flash::{NorFlash, ReadNorFlash};

    pub const FLASH_SIZE: u32 = 512 * 1024; // 512 kB flash memory, might be unnecessary to define this
    pub const PAGE_SIZE: u32 = 4096; // 4 kB page size
    pub const SECRET_PAGE_START: u32 = FLASH_SIZE - PAGE_SIZE; // Start of the last page in flash memory

    // This is to be able to validate that the secret was written to flash correctly
    const MAGIC: u32 = u32::from_le_bytes(*b"SECR");
    pub const SECRET_MAX_LEN: usize = 24; // Max length of the secret, we set it to 24 so it's word aligned.
    const HEADER_SIZE: usize = 4 + 4; // MAGIC (4 bytes) + length (4 bytes)
    const RECORD_SIZE: usize = HEADER_SIZE + SECRET_MAX_LEN; // Total size of the record to be stored in flash (32 bytes)

    #[inline(never)]
    pub fn write_secret(nvmc: &mut FlashNvmc, secret: &[u8]) {
        // TODO: Implement writing the secret to flash memory using the NVMC peripheral
        if secret.is_empty() || secret.len() > SECRET_MAX_LEN {
            return; // Invalid secret length
        }
        // Create a record to hold the magic, length and secret data
        let mut record = [0xFFu8; RECORD_SIZE];
        record[0..4].copy_from_slice(&MAGIC.to_le_bytes()); // Write the magic number
        record[4..8].copy_from_slice(&(secret.len() as u32).to_le_bytes()); // Write the length of the secret
        record[HEADER_SIZE..HEADER_SIZE + secret.len()].copy_from_slice(secret); // Write the secret data

        // Write the record to flash memory
        let _ = nvmc.erase(SECRET_PAGE_START, SECRET_PAGE_START + PAGE_SIZE); // IMPORTANT: Erase flash page before writing
        let _ = nvmc.write(SECRET_PAGE_START, &record); // Write the record to flash
    }

    #[inline(never)]
    pub fn read_secret(nvmc: &mut FlashNvmc, buffer: &mut [u8]) -> usize {
        // TODO: Implement reading the secret from flash memory into the provided buffer
        let mut header = [0u8; HEADER_SIZE];
        if nvmc.read(SECRET_PAGE_START, &mut header).is_err() {
            return 0; // Failed to read header, return 0 to indicate no valid secret
        }

        // Validate the magic number to ensure we have a valid record
        let magic = u32::from_le_bytes([header[0], header[1], header[2], header[3]]); // Extract the magic number
        if magic != MAGIC {
            return 0; // Invalid magic number, no valid secret stored
        }

        // Validate the length
        let len = u32::from_le_bytes([header[4], header[5], header[6], header[7]]) as usize; // Extract the length of the secret
        if len == 0 || len > SECRET_MAX_LEN {
            return 0; // Invalid length, return 0 to indicate no valid secret
        }

        // Read the secret data into the provided buffer
        if nvmc
            .read(SECRET_PAGE_START + HEADER_SIZE as u32, &mut buffer[..len])
            .is_err()
        {
            return 0; // Failed to read secret data, return 0 to indicate no valid secret
        }

        len // Return the length of the secret read into the buffer
    }
}

#[rtic::app(device = nrf52840_hal::pac, dispatchers = [SWI0_EGU0])]
mod app {
    use super::*;

    use usbd_serial::embedded_io::Write as _;
    #[monotonic(binds = SysTick, default = true)]
    type MyMono = Systick<TIMER_HZ>;

    // totp
    use otp::{Totp, Algorithm, Secret};


    #[shared]
    struct Shared {
        totp: Totp,
        unix_time: u64,
        duty: u8, // Basically we want to share state between UART task(data_in) and Blik task(blink)
        period_ms: u32, // derived from frequency
        running: bool, // start and stoprunning: bool,  // start and stop
        nvmc: FlashNvmc, // keep NVMC as a shared resource
        
    }

    #[local]
    struct Local {
        led1: Led,       // P0.13
        led_mirror: Led, // P1.3
        //button: hal::gpio::Pin<hal::gpio::Input<hal::gpio::PullUp>>,
        usb_dev: usb_device::device::UsbDevice<'static, Usbd<UsbPeripheral<'static>>>, // This controlls transfers and all USB protocol handling
        serial: SerialPort<'static, Usbd<UsbPeripheral<'static>>>, // The CDC-ACM serial interface ( the virtual COM port), read from and write to
        buf: [u8; 64], // 64  byte buffer used for reading and incoming USB data
    }
    #[init(local = [
        usb_bus: Option<UsbBusAllocator<Usbd<UsbPeripheral<'static>>>> = None,
        clocks: Option<Clocks<hal::clocks::ExternalOscillator,hal::clocks::Internal, hal::clocks::LfOscStopped>> = None,
        storage: FlashStorageBuf = [0xFF; secret_storage::PAGE_SIZE as usize],
    ])]
    fn init(cx: init::Context) -> (Shared, Local, init::Monotonics) {
        rtt_init_print!();
        rprintln!("\n--- init ---");

        // Initialize the monotonic (core clock at 64 MHz)
        let mut mono = Systick::new(cx.core.SYST, 64_000_000);
        let device = cx.device; // Gives access  to all the harware periphials on the nRF52840( like USB, CLOCK, GPIO and more)
                                //Enable USBD interrupt
        device.USBD.intenset.write(|w| w.sof().set());

        let port0 = P0Parts::new(device.P0);
        let port1 = P1Parts::new(device.P1);

        // LED
        // P0.13, connected to LED1 on nRF52840 DK
        let led1 = port0.p0_13.into_push_pull_output(Level::Low).degrade();
        let led_mirror = port1.p1_13.into_push_pull_output(Level::Low).degrade();

        // This sets up the clock to work with precise timing required by the USB
        let clocks = Clocks::new(device.CLOCK).enable_ext_hfosc();
        // make static lifetime for clocks, stores the value inside the RTICs local memory, ensures the value lives for the entire program (static liftime)
        cx.local.clocks.replace(clocks.enable_ext_hfosc()); // static lifetime = value nerver dropped or become invalid

        let usb_bus = UsbBusAllocator::new(Usbd::new(UsbPeripheral::new(
            device.USBD,
            cx.local.clocks.as_ref().unwrap(), // refer to static lifetime
        )));
        cx.local.usb_bus.replace(usb_bus);

        //let usb_bus = cx.local.usb_bus.as_ref().unwrap();
        let serial = SerialPort::new(&cx.local.usb_bus.as_ref().unwrap());

        // Initialize NVMC peripheral for flash memory access
        let nvmc = FlashNvmc::new(device.NVMC, cx.local.storage);
        // Init button
        // let port0 = P0Parts::new(device.P0);
        // let button = port0.p0_11.into_pullup_input().degrade();

        // Allocates a mut fixed size byte array on the stack, every element is initialized to 0u8
        // Rust requires a pre-allocate the space 
        let mut secret_buf = [0u8; secret_storage::SECRET_MAX_LEN];

        // returns the actual number of bytes written into the buffer, need real length for correct slicing later
        // writes the actual secret key from NVM into beginning of secret_buf
        let len = secret_storage::read_secret(&mut nvmc, &mut secret_buf);

        // takes the valid portion of the buffer, convert bytes into secret type, Secret is a safe wrapper around the secret key
        let secret = Secret::from_bytes(&secret_buf[..len]); 


        // Initialize the totp intstance, source - https://docs.rs/totp-rs/latest/totp_rs/
        let totp = Totp::new(               // creates a totp generator
            Algorithm::SHA1,
            "dev".into(),                   // Just a label, issuer name (e.g discord)          
            "user".into(),                  // Account name
            super::DIGITS,                  // number of digits in the generated code
            super::TIME_STEP as u32,        // time window the code should be valid
            secret,     
        );
        totp.generate_at(unix_time)
    }

        //let usb_bus = cx.local.usb_bus.as_ref().unwrap();
        let serial = SerialPort::new(&cx.local.usb_bus.as_ref().unwrap());

        let usb_dev = UsbDeviceBuilder::new(
            &cx.local.usb_bus.as_ref().unwrap(),
            UsbVidPid(0x16c0, 0x27dd),
        )
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
        (
            Shared {
                totp,
                unix_time: 0,
                duty: 50,
                period_ms: 1000,
                running: true,
                nvmc: nvmc, // Initialize the NVMC peripheral and store it in the shared resources
            },
            Local {
                led1,
                led_mirror,
                usb_dev,
                serial,
                buf: [0u8; 64],
            },
            init::Monotonics(mono),
        )
    }

    // Software PWM using duty from Shared
    #[task(shared = [duty, period_ms, running], local = [cnt: u32 = 0, led1, led_mirror, is_on: bool = false])]
    fn blink(mut cx: blink::Context, instant: Instant) {
        let duty = cx.shared.duty.lock(|d| *d); // This ensures safe access to the shared data
        let period_ms = cx.shared.period_ms.lock(|d| *d);
        let running = cx.shared.running.lock(|d| *d);

        // STOP command -> led should be forced OFF and no recheduling
        if !running {
            led::led_off(cx.local.led1); // P0.13 -> off
            led::led_off(cx.local.led_mirror); // P1.13 -> off
            *cx.local.is_on = false;
            return;
        }

        //let period_ms = 1000;
        let on_time = period_ms * duty as u32 / 100;
        let off_time = period_ms - on_time;

        // If LED is currently ON -> turn OFF
        if *cx.local.is_on {
            led::led_off(cx.local.led1); // P0.13 -> off
            led::led_off(cx.local.led_mirror); // P1.13 -> off
            *cx.local.is_on = false;
            if running {
                blink::spawn_at(instant + off_time.millis(), instant + off_time.millis()).unwrap();
            }

        // IF its OFF -> turn ON
        } else {
            led::led_on(cx.local.led1); // P0.13 -> on
            led::led_on(cx.local.led_mirror); // P1.13 -> on
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
    fn usb_interrupt(mut cx: usb_interrupt::Context) {
        // Calculate the current time
        // let time = cx.shared.unix_time.lock(|t| *t);
        // caculate the right OPT code based on the time
        //let opt = totp::generate(SECRET, time);

        //  usb_keyboard::send::code(opt);
        let usb_dev = cx.local.usb_dev;
        let serial = cx.local.serial;
        let buf = cx.local.buf; // Initial buffer that hold the incomming bytes from serial port
        let len = cx.local.len; // this is the counter that tracks how many characters has been stores in data_arr
        let data_arr = cx.local.data_arr; // this is like a small buffer to store incomming characters extracted from the buf-buffer

        // IMPORTANTE: Each time a command is sent from cutecom, the characters dont come all att ones, just one byte at the time?

        // checks whether new data has arrived, and if this is true call serial.read() or serial.write(). There is work to do
        if !usb_dev.poll(&mut [serial]) {
            return;
        }
        //rprintln!("usb interrupt!");
        // Read data
        let Ok(count) = serial.read(buf) else { return }; // if somthing has been recived, store it temporary in buf
        if count == 0 {
            return;
        }

        // loop through each byte indi.
        for &c in &buf[..count] {
            let _ = serial.write(&[c]); // Echo
                                        // If it has enter 13, treat it as a complete commad and parse and excecute it(then reset len = 0)
                                        // if not, store the byte into data_arr at index "len" abd increament "len"
            match c {
                13 => {
                    // CR
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
                            let period_ms = 1000 / freq; // Converts the desired frequency to the time period in miliseconds
                            cx.shared.period_ms.lock(|p| *p = period_ms); // updated the shared varible that hold the current value of the period_ms
                            rprintln!("Frequency set to {}", freq);
                            let _ = write!(serial, "Duty set to {} Hz\r\n", freq).ok();
                            // Sends back confirmation to the serial terminal in CuteCom
                        }
                        // Handles the Start command
                        Ok(Command::Start) => {
                            cx.shared.running.lock(|r| *r = true); // setting the running boolen to true, signaling the blink function to start
                            let now = monotonics::now(); // Gets the current mono timer timestamp, needed because blink::spawn_at requires a timestamp
                            blink::spawn_at(now, now).ok(); // Immediate scheduling the blink function to runn now( current time extracted from the line above)
                            let _ = write!(serial, "Started\r\n").ok();
                        }
                        // Handles the stop command
                        Ok(Command::Stop) => {
                            cx.shared.running.lock(|r| *r = false); // Sets the shared running boolen to false
                            let now = monotonics::now();
                            let _ = write!(serial, "Stopped\r\n").ok();
                        }
                        // Handles the stop command
                        Ok(Command::Time(t)) => {
                            cx.shared.unix_time.lock(|time| *time = t); 
                            let _ = write!(serial, "Unix time set to\r\n", t).ok();
                        }
                        Err(e) => {
                            rprintln!("Parse error {:?}", e);
                        }
                    }
                    *len = 0;
                }
                _ => {
                    data_arr[*len] = c;
                    *len = usize::min(*len + 1, data_arr.len() - 1); // len always point to the next free position
                }
            }
        }
    }

mod led {
    use embedded_hal::digital::v2::OutputPin;

    #[inline(never)]
    pub fn led_on(_led: &mut impl OutputPin) {
        //rprintln!("led_on");
        _led.set_low().ok();
    }

    #[inline(never)]
    pub fn led_off(_led: &mut impl OutputPin) {
        //rprintln!("led_off");
        _led.set_high().ok();
    }
}
