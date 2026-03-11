// Convert time, both the server and the PCB devices
                // - TOTP does not use raw time
                // - time is devided into fixed time windows(30 sec)
                // - this makes shore the OTP stayes the same for the whole window
        // convert time to bytes, maby unnessary
                // - The hash function may reaquire an input in binary form
                // - Standard is 8 bytes counter to ensure consistant hashing across system
        // Compute(generate) the hash - secret + counte
        // Choose the starting posistion in the hash
                // the last bytes of the hash determines where to extract the code
        // convert to OTP to 6 digit code
        // 
// Parameters that must match the server

// 1. Secret key: shared key(usually Base32)
// 2. Hash algo.: SHA1 (most common)
// 3. Time step: should be 30 sec
// 4. Digit of the code: typically 6 digits(sometimes 8)
// 5. Current time: UNIX time

// Usfull doc: https://docs.rs/otp-auth/latest/otp/struct.Totp.html
impl Totp

pub fn new(
        alg: Algoritm,
        issuer: String,
        label: String,
        digits: u8,
        period: u64,
        secret: Secret,
) -> Self

use otp:: {Totp, Algoritm, Secret};
// Create a totp insatance
let totp = Totp:: new(
        Algoritm::SHA1,
        "MyDevice".into(),
        "user1".into(),
        6,                                      // number of digits
        30,                                     // period(time step)
        Secret::from_bytes(b"supersecret")      // secret key
)

#[task(binds = USBD, priority = 1)]
    fn gen_OTP(mut cx: usb_interrupt::Context) {

        // get current time for rtc(real time clock)
        let unix_time: u64 = rtc_get_unix_time();

        // generate OPT
        let opt = totp.generate_at(unix_time);

         
        
    }

    