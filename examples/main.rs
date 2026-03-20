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

mod raw_access {
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
}

// C like API...
mod nrf52833 {
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
}

use nrf52833::*;

use {
    command_parser::{parse_result, Command},
    hal::{
        clocks::Clocks,
        // For GPIO and serial peripherals
        usbd::{UsbPeripheral, Usbd},
    },
    nrf52833_hal::{self as hal},
    rtt_target::{rprintln, rtt_init_print}, // For RTT logging (terminal output)
    systick_monotonic::fugit::ExtU64, // For time handling with the monotonic timer
    // nb::block,                                      // For blocking on serial reads/writes
    systick_monotonic::Systick, // For the monotonic timer based on SysTick
    usb_device::{
        class_prelude::UsbBusAllocator,
        device::{StringDescriptors, UsbDeviceBuilder, UsbVidPid},
    },
    usbd_serial::{SerialPort},
    usbd_human_interface_device::{device::keyboard::{BootKeyboard, BootKeyboardConfig}, page::Keyboard, prelude::{UsbHidClass, *}},
    frunk::{HCons, HNil},
};

// Global constants
const TIME_STEP: u64 = 30;
const DIGITS: u32 = 6;
const TIMER_HZ: u32 = 1000;

// Types for flash storage and NVMC peripheral, used in the secret_storage module to read/write secrets to flash memory
type FlashNvmc = hal::nvmc::Nvmc<hal::pac::NVMC>;

mod display {
    use nrf52833_hal::{
        twim::{Twim, Pins, Frequency},
        gpio::{p0::Parts as P0Parts, p1::Parts as P1Parts, Floating, Input},
        pac::TWIM0,
    };
    use rtt_target::rprintln;

    use crate::app::init;

    const ADDR: u8 = 0x3C; // Common SSD1306 I2C address

    pub struct Display {
        twim: Twim<TWIM0>,
    }
    const FONT: [[u8; 5]; 11] = [
            // 0-9 + ':'
            [0x3E, 0x51, 0x49, 0x45, 0x3E], // 0
            [0x00, 0x42, 0x7F, 0x40, 0x00], // 1
            [0x62, 0x51, 0x49, 0x49, 0x46], // 2
            [0x22, 0x49, 0x49, 0x49, 0x36], // 3
            [0x18, 0x14, 0x12, 0x7F, 0x10], // 4
            [0x2F, 0x49, 0x49, 0x49, 0x31], // 5
            [0x3E, 0x49, 0x49, 0x49, 0x32], // 6
            [0x01, 0x71, 0x09, 0x05, 0x03], // 7
            [0x36, 0x49, 0x49, 0x49, 0x36], // 8
            [0x26, 0x49, 0x49, 0x49, 0x3E], // 9
            [0x00, 0x36, 0x36, 0x00, 0x00], // :
        ];

    impl Display {
        pub fn new(twim0: TWIM0, p0: nrf52833_hal::pac::P0, p1: nrf52833_hal::pac::P1) -> Self {
            // Initilizes Port0 and Port 1
            let port0= P0Parts::new(p0);
            let port1=P1Parts::new(p1);
           // access both pins and change them into input pins
            let scl= port1.p1_09.into_floating_input().degrade();   // the clock line, gives controll, when to read or write
            let sda= port0.p0_11.into_floating_input().degrade();   // the data line, devises read ir writre data on SDA in sync with SCL

            // Create a pin struct for convinence
            let pins = Pins {scl, sda};

            // I2C - is a communication method that lets chips talk to each other using only two wires
            // SCL - Searial clock that TWIM generates the clock pulese
            // SDA - Seral data that moves the data on the line
            // creates a Two-Wire Interface Master
            let twim = Twim::new(twim0, pins, Frequency::K400);

            let mut display= Self { twim };
            display.init();
            // disp.init();

            rprintln!("Display initialized");

            display
        }
        // function that handles sending a command to the display
        fn write_command(&mut self, cmd: u8) {
            let buffer = [0x00, cmd];
            self.twim.write(ADDR, &buffer).ok();    // this basically sends [ COMMAND_MODE, COMMAND]
        }
        // this function send pixle data to the display
        fn write_data(&mut self, data: &[u8]) {
            let mut buffer = [0u8; 17];
            buffer[0] = 0x40;                   // set display start Line

            for chunk in data.chunks(16) {       // sending data in chunks of 16 bytes(display limit, cant handle more)
                let len = chunk.len();
                buffer[1..1 + len].copy_from_slice(chunk);
                self.twim.write(ADDR, &buffer[..1 + len]).ok(); // sends the display chunks like [DATA_MODE, pixle1,...,]
            }
        }
    
        // inital code that has to be set(SETUP) - DataSheet https://se.farnell.com/midas/mdob128032gv-wi/oled-display-cob-128-x-32-pixel/dp/3407291
        fn init(&mut self) {
            let init_cmds = [
                0xAE, 0xD5, 0x80, 0xA8, 0x1F, 0xD3, 0x00,
                0x40, 0x8D, 0x14, 0xA1, 0xC8, 0xDA, 0x12,
                0x81, 0xFF, 0xD9, 0x22, 0xDB, 0x30, 0xA4,
                0xA6, 0xAF,
            ];

            for &cmd in &init_cmds {
                self.write_command(cmd);
            }
        }
        // the screen is 128x32 pixles
        pub fn clear_display(&mut self) {
            for page in 0..4 {                     // The display us divided into 4 x 8 rows( 4 page)
                self.write_command(0xB0 + page);                   // The display us divided into 4 x 8 rows( 4 page)
                self.write_command(0x00);
                self.write_command(0x10);
                self.write_data(&[0x00; 128]);

                
            }
        }
      
        pub fn show_code_message(&mut self, code: u32) {
            self.clear_display();

            // Set cursor to start (page 0, column 0)
            self.write_command(0xB0); // page 0
            self.write_command(0x00); // lower column
            self.write_command(0x10); // higher column

        }
         
    }
         

}



mod usb_keyboard {
    // maby convert code to string
    // send digit as HID keybord events
}
// HMAC ( Hash-based Message Authentication Code) is like a construction or a method 
// HMAC = hash function(SHA1) + secret Key + a specific algorithmic recipe

mod totp {
    use hmac::{Hmac, Mac};
    use sha1::Sha1;


    // Type alias for HMAC-SHA1
    type HmacSha1 = Hmac<Sha1>;

    /// Generate a TOTP code
    pub fn generate_totp(secret: &[u8], unix_time: u64, digits: u32, step: u64) -> u32 {
        // Convert time into timestep (in our case a 30 sec window where code should be valid)
        let counter = unix_time / step;   
        // Create the HMAC object first before we add the counter, order is important for the HMAC process
        let mut mac = HmacSha1::new_from_slice(secret).unwrap();
        // First convert mac into bytes(HMAC works on bytes not numbers) and then feed it into the HMAC
        mac.update(&counter.to_be_bytes());
        // Compute the final HMAC hash, this should return a 20 byte array(SHA1 output size)
        let hash = mac.finalize().into_bytes();

        // dynamic truncation  - from example 5.4 - https://datatracker.ietf.org/doc/html/rfc4226
        let offset = (hash[19] & 0x0f) as usize;
        let code = ((u32::from(hash[offset]) & 0x7f) << 24
            | (u32::from(hash[offset + 1]) & 0xff) << 16
            | (u32::from(hash[offset + 2]) & 0xff) << 8
            | (u32::from(hash[offset + 3]) & 0xff)) 
            % 10u32.pow(digits);
        code
    }
}

mod secret_storage {
    use crate::FlashNvmc;
    use embedded_storage::nor_flash::{NorFlash, ReadNorFlash};
    use rtt_target::rprintln;

    pub const FLASH_SIZE: u32 = 512 * 1024; // 512 kB flash memory according to product specification of nRF52833
    pub const PAGE_SIZE: u32 = 4096; // 4 kB page size
    pub const SECRET_PAGE_START: u32 = FLASH_SIZE - PAGE_SIZE; // Start of the last page in flash memory

    // This is to be able to validate that the secret was written to flash correctly
    const MAGIC: u32 = u32::from_le_bytes(*b"SECR");
    pub const SECRET_MAX_LEN: usize = 32; // Max length of the secret, we set it to 32 bytes
    const HEADER_SIZE: usize = 4 + 4; // MAGIC (4 bytes) + length (4 bytes)
    const RECORD_SIZE: usize = HEADER_SIZE + SECRET_MAX_LEN; // Total size of the record to be stored in flash (40 bytes)

    #[inline(never)]
    pub fn write_secret(nvmc: &mut FlashNvmc, secret: &[u8]) {
        // Check that the secret is valid, we expect a secret that is longer than 0 chars and shorter than SECRET_MAX_LEN
        if secret.is_empty() || secret.len() > SECRET_MAX_LEN {
            return;
        }

        // Create a record to hold the magic, length and secret data
        let mut record = [0xFFu8; RECORD_SIZE];
        record[0..4].copy_from_slice(&MAGIC.to_le_bytes()); // Write the magic number to record
        record[4..8].copy_from_slice(&(secret.len() as u32).to_le_bytes()); // Write the length of the secret to record
        record[HEADER_SIZE..HEADER_SIZE + secret.len()].copy_from_slice(secret); // Write the secret data to record

        // Clear the page and then write the record to flash, only write to RTT terminal if something fails
        if nvmc.erase(0, PAGE_SIZE).is_err() {
            rprintln!("Failed to erase flash page");
            return;
        }
        if nvmc.write(0, &record).is_err() {
            rprintln!("Failed to write secret to flash");
            return;
        }

        // Clear the record from RAM after writing to flash for security reasons
        // This is slight unnecessary since we're not locking the flash memory after writing, but we thought we'd prepare for it anyways
        let mut i = 0;
        while i < record.len() {
            record[i] = 0x00;
            i += 1;
        }
    }

    #[inline(never)]
    pub fn read_secret(nvmc: &mut FlashNvmc, buffer: &mut [u8]) -> usize {
        let mut header = [0u8; HEADER_SIZE];

        // Offset 0 since we mapped nvmc to the secret page (Last 4096 bytes of flash)
        if let Err(e) = nvmc.read(0, &mut header) {
            // This only reads header.len() number of bytes, which is 8 bytes (4 for magic and 4 for length)
            rprintln!("Failed to read secret header: {:?}", e);
            return 0;
        }

        // Extract and validate the magic number to ensure we have a valid record
        let magic = u32::from_le_bytes([header[0], header[1], header[2], header[3]]); // Converts raw bytes to a u32 magic number, we expect 0x52434553 which is "RCES" in ASCII (SECR backwards)
        if magic != MAGIC {
            // This works because both the MAGIC and magic header is stored in little endian format (supposed to read least significant byte first)
            rprintln!("Invalid magic number in flash, no valid secret stored");
            return 0;
        }

        // Validate the length
        let len = u32::from_le_bytes([header[4], header[5], header[6], header[7]]) as usize; // Extract the length of the secret
        if len == 0 || len > SECRET_MAX_LEN || len > buffer.len() {
            rprintln!(
                "Secret length in flash is invalid, missing or too big for buffer: {}",
                len
            );
            return 0; // Invalid length, return 0 to indicate no valid secret
        }

        // Read the secret data into the provided buffer
        if let Err(e) = nvmc.read(HEADER_SIZE as u32, &mut buffer[..len]) {
            rprintln!("Failed to read secret data from flash: {:?}", e);
            return 0;
        }

        len // Return the length of the secret read into the buffer
    }

    #[inline(never)]
    // This was also for debugging purposes when we needed to verify that the secret was actually written to flash memory
    pub fn print_secret(nvmc: &mut FlashNvmc) {
        let mut buffer = [0u8; SECRET_MAX_LEN];
        let len = read_secret(nvmc, &mut buffer);
        if len > 0 {
            rprintln!("Secret in flash: {:?}", &buffer[..len]);
        } else {
            rprintln!("No valid secret found in flash");
        }
    }
}

#[rtic::app(device = nrf52833_hal::pac, dispatchers = [TIMER0])]
mod app {
    use super::*;

    use usbd_serial::embedded_io::Write as _;
    #[monotonic(binds = SysTick, default = true)]
    type MyMono = Systick<TIMER_HZ>;

    // totp
    //use otp::{Algorithm, Secret, Totp};

    #[shared]
    struct Shared {
        unix_time: u64,
        nvmc: FlashNvmc, // keep NVMC as a shared resource
        code: [Keyboard; 6],
        vir_keyboard: UsbHidClass<'static, Usbd<UsbPeripheral<'static>>, HCons<BootKeyboard<'static, Usbd<UsbPeripheral<'static>>>, HNil>>,
        gpio_p0: &'static mut GPIO,
        serial: SerialPort<'static, Usbd<UsbPeripheral<'static>>>,
        display: display::Display,
    }

    #[local]
    struct Local {
        //button: hal::gpio::Pin<hal::gpio::Input<hal::gpio::PullUp>>,
        usb_dev: usb_device::device::UsbDevice<'static, Usbd<UsbPeripheral<'static>>>, // This controlls transfers and all USB protocol handling
        buf: [u8; 64], // 64  byte buffer used for reading and incoming USB data
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
        let device = cx.device; // Gives access  to all the harware periphials on the nRF52840( like USB, CLOCK, GPIO and more)
                                //Enable USBD interrupt
        device.USBD.intenset.write(|w| w.sof().set());

        // This sets up the clock to work with precise timing required by the USB
        let clocks = Clocks::new(device.CLOCK).enable_ext_hfosc();
        // make static lifetime for clocks, stores the value inside the RTICs local memory, ensures the value lives for the entire program (static liftime)
        cx.local.clocks.replace(clocks.enable_ext_hfosc()); // static lifetime = value nerver dropped or become invalid

        let usb_bus: UsbBusAllocator<Usbd<UsbPeripheral<'_>>> = UsbBusAllocator::new(Usbd::new(UsbPeripheral::new(
            device.USBD,
            cx.local.clocks.as_ref().unwrap(),
        )));
        cx.local.usb_bus.replace(usb_bus);

        let serial = SerialPort::new(&cx.local.usb_bus.as_ref().unwrap());

        let mut vir_keyboard = UsbHidClassBuilder::new()
            .add_device(BootKeyboardConfig::default())
            .build(cx.local.usb_bus.as_ref().unwrap());

        // Map only the last flash page to a mutable slice, we'll store the secret there.
        let flash_page = unsafe {
            core::slice::from_raw_parts_mut(
                secret_storage::SECRET_PAGE_START as *mut u8,
                secret_storage::PAGE_SIZE as usize,
            )
        };
        let nvmc = FlashNvmc::new(device.NVMC, flash_page);
        
        // Had to change device class in order for windows to recognize it as a keyboard + serial connection.
        let mut usb_dev = UsbDeviceBuilder::new(cx.local.usb_bus.as_ref().unwrap(), UsbVidPid(0x1209, 0x0001))
            .strings(&[StringDescriptors::default()
                .manufacturer("Fake company")
                .product("Serial port + Keyboard")
                .serial_number("TEST")])
            .unwrap()
            .composite_with_iads()
            .max_packet_size_0(64) // (makes control transfers 8x faster)
            .unwrap()
            .build();

        let code: [Keyboard; 6] = [Keyboard::A, Keyboard::A, Keyboard::C, 
            Keyboard::D, Keyboard::F, Keyboard::F];

        let gpio_p0 = unsafe { &mut *GPIO_P0::get() }; // get the reference to GPIOA in memory
        gpio_p0.PIN_CNF[29].write(0b1100); // Enable button 1
        let display = display::Display::new(device.TWIM0, device.P0, device.P1);

        // Unlocks the button etc.
        unsafe {
            core::ptr::write_volatile(0x4000_6510 as *mut u32, 1 | (29 << 8) | (2 << 16));
            core::ptr::write_volatile(0x4000_6304 as *mut u32, 1);
        }

        hid_tick::spawn().ok();

        #[allow(unreachable_code)]
        (
            Shared {
                code: code,
                unix_time: 0,
                nvmc: nvmc, // Initialize the NVMC peripheral and store it in the shared resources
                vir_keyboard,
                gpio_p0,
                serial,
                display,
            },
            Local {
                usb_dev,
                buf: [0u8; 64],
            },
            init::Monotonics(mono),
        )
    }

    #[task(shared = [display])]
    fn display_otp(mut cx: display_otp::Context, code:u32) {
        cx.shared.display.lock(|display| {
            display.show_code_message(code);
        });

    }

    #[task(shared = [code, unix_time, nvmc, display])]
    fn generate_otp(mut cx: generate_otp::Context) {
        // Helper function used for converting the numbers into Keyboard keys
        fn digit_to_key(digit: u8) -> Keyboard {
            match digit {
                1 => Keyboard::Keyboard1,
                2 => Keyboard::Keyboard2,
                3 => Keyboard::Keyboard3,
                4 => Keyboard::Keyboard4,
                5 => Keyboard::Keyboard5,
                6 => Keyboard::Keyboard6,
                7 => Keyboard::Keyboard7,
                8 => Keyboard::Keyboard8,
                9 => Keyboard::Keyboard9,
                0 => Keyboard::Keyboard0,
                _ => Keyboard::Space, // A safe fallback if a number > 9 is passed
            }
        }
        // Allocates a mut fixed size byte array on the stack, every element is initialized to 0u8 (32 zeros)
        // Rust requires a pre-allocate the space
        let mut secret_buf = [0u8; secret_storage::SECRET_MAX_LEN];
        // let len = secret_storage::read_secret(&mut cx.shared.nvmc.lock(|n| n), &mut secret_buf);

        // reads the secret from flash memory into the secret buffer
        // lock because it shared, prevent race conditions(for saftey)
        let len = cx
            .shared
            .nvmc
            .lock(|nvmc| secret_storage::read_secret(nvmc, &mut secret_buf));
        if len == 0 {
            rprintln!("Invalid secret!");
            return;
        }
        // if the secret is not of size 32, take only the secret part (uses the documented length)
        let secret = &secret_buf[..len];
        // generate the OTP code by calling the TOTP fucntion (in mod totp)
        let otp_code =
            totp::generate_totp(secret, cx.shared.unix_time.lock(|t| *t), DIGITS, TIME_STEP);
        rprintln!("OTP code: {}", otp_code);

        // Prepare Digit extraction 
        // extract one digit at the time and add it to a temp array
        let mut digits = [0u8; 6];
        let mut temp = otp_code;   

        for i in (0..6).rev() {
            digits[i] = (temp % 10) as u8;  // extract the last element 
            temp/= 10;                      // remove it from the tempural array
        }
        // Store the code in the shared varible with the type Keyboard
        cx.shared.code.lock(|code| {                    // lock and access the shared varible
            for (i, d) in digits.iter().enumerate() {           // iterates over the  extracted digits from previous step
                code[i] = digit_to_key(*d);                                 // This will convert the numerical digits into keyboard rep.
            }                                                               // neumerate: build on iterator to provide a sequence pairs (consists of index and a refernce to where its located)
        });
        display_otp::spawn(otp_code).ok();
        send_data::spawn().ok();
    }

    // When USB is connected -> send OPT
    #[task(binds = USBD, priority = 3, local = [usb_dev, buf, len: usize = 0, data_arr: [u8; 64] = [0; 64]], shared = [serial, vir_keyboard, unix_time, nvmc])]
    fn usbd(mut cx: usbd::Context) {
        let usb_dev = cx.local.usb_dev;
        let buf = cx.local.buf; // Initial buffer that hold the incomming bytes from serial port
        let len = cx.local.len; // this is the counter that tracks how many characters has been stores in data_arr
        let data_arr = cx.local.data_arr; // this is like a small buffer to store incomming characters extracted from the buf-buffer

        (cx.shared.serial, cx.shared.vir_keyboard).lock(|serial, vir_keyboard| {
            let mut classes: [&mut dyn usb_device::class::UsbClass<_>; 2] = [
                &mut *serial, 
                &mut *vir_keyboard
            ];

            if !usb_dev.poll(&mut classes) {
                return;
            }

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
                    10 => {} // Ignore LF
                    13 => {
                        // CR
                        let slice = &data_arr[0..*len]; // extract (slice) to get the refernce to the command
                                                        // Takes the slice and tries to match it with the right handler
                        match parse_result(slice) {
                            // Handles the SetSecret command
                            Ok(Command::SetSecret(secret)) => {
                                use base32ct::{Base32UpperUnpadded, Encoding};

                                let mut clean = [0u8; 64];
                                let mut n = 0usize;

                                // Loop to convert the secret to a clean base32 format, removing padding and other unwanted chars
                                for &b in secret {
                                    let c = match b {
                                        b'a'..=b'z' => b - 32, // convery lowercase to uppercase
                                        b'A'..=b'Z' | b'2'..=b'7' => b,
                                        b'=' | b' ' | b'\t' | b'\r' | b'\n' => continue, // ignore padding/whitespace/newlines etc
                                        _ => {
                                            rprintln!("Invalid secret byte: 0x{:02X}", b);
                                            n = 0;
                                            break;
                                        }
                                    };

                                    if n >= clean.len() {
                                        n = 0;
                                        break;
                                    }
                                    clean[n] = c;
                                    n += 1;
                                }

                                // We expect a secret that is longer than 0 chars
                                if n == 0 {
                                    let _ = write!(serial, "Invalid secret format\r\n").ok();
                                } else {
                                    let clean_slice = &clean[..n];

                                    let mut decoded = [0u8; secret_storage::SECRET_MAX_LEN];

                                    match Base32UpperUnpadded::decode(&clean_slice[..n], &mut decoded) {
                                        Ok(decoded_secret) => {
                                            cx.shared.nvmc.lock(|n| {
                                                secret_storage::write_secret(n, &decoded_secret)
                                            });
                                            rprintln!("Secret set");
                                            let _ = write!(serial, "Secret set\r\n").ok();
                                        }
                                        Err(e) => {
                                            rprintln!("Failed to decode secret via Base32: {:?}", e);
                                            let _ = write!(
                                                serial,
                                                "Failed to decode secret via base32\r\n"
                                            )
                                            .ok();
                                        }
                                    }
                                }
                            }
                            Ok(Command::PrintSecret) => {
                                cx.shared.nvmc.lock(|n| secret_storage::print_secret(n)); // Reads the secret from flash memory and prints it to the RTT terminal
                                let _ = write!(serial, "Secret printed to RTT terminal\r\n").ok();
                            }
                            // Handles the stop command
                            Ok(Command::Time(t)) => {
                                cx.shared.unix_time.lock(|time| *time = t);
                                let _ = write!(serial, "Unix time set to {}\r\n", t).ok();
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
        });
    }

    // Checks if a button press happens, if it happens, spawn the send_data function.
    #[task(binds = GPIOTE, local = [last_press: u64 = 0])]
    fn button_interrupt(cx: button_interrupt::Context) {
        unsafe { core::ptr::write_volatile(0x4000_6100 as *mut u32, 0); }
        let now = monotonics::now().ticks();
        if now - *cx.local.last_press > 200 {
            *cx.local.last_press = now;
            generate_otp::spawn().ok();
        }
    }

    // Keeps the usb connection fresh so windows doesn't drop the connection.
    #[task(shared = [vir_keyboard, gpio_p0])]
    fn hid_tick(mut cx: hid_tick::Context) {
        cx.shared.vir_keyboard.lock(|vir_keyboard| {
            match vir_keyboard.tick() {
                Ok(_) => {}
                Err(_) => {}
            }
        });

        hid_tick::spawn_after(1u64.millis()).ok();
    }

    // Function to send data over to the computer.
    #[task(shared = [vir_keyboard, code], local = [index: usize = 0])]
    fn send_data(mut cx: send_data::Context) {
        rprintln!("\n--- send_data ---");
        let i = *cx.local.index;
        // Code variable is always 6 index long, loops through each digit, this is done so the same character
        // after each other can be sent.
        if i < 6 {
            let key = cx.shared.code.lock(|code| code[i]);

            cx.shared.vir_keyboard.lock(|vir_keyboard| {
                vir_keyboard.device().write_report([key]).ok();
            });

            *cx.local.index += 1;
            release_keys::spawn_after(20u64.millis()).ok();
            send_data::spawn_after(40u64.millis()).ok();
        }
        // When all digits are sent, reset index to 0 and send a Enter Keyboard command.
        else {
            *cx.local.index = 0;

            cx.shared.vir_keyboard.lock(|vir_keyboard| {
                vir_keyboard.device().write_report([Keyboard::ReturnEnter]).ok();
            });
            release_keys::spawn_after(20u64.millis()).ok();
        }
    }

    // Function to release the key, has to be done as otherwise windows will not regard it as a received character.
    #[task(shared = [vir_keyboard])]
    fn release_keys(mut cx: release_keys::Context) {
        let no_keys: [Keyboard; 0] = [];

        cx.shared.vir_keyboard.lock(|vir_keyboard| {
            vir_keyboard.device().write_report(no_keys).ok();
        });
    }
}