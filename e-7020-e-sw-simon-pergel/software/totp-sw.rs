#[task(binds = USBD, priority = 1)]
    fn OTP(mut cx: usb_interrupt::Context) {
        // Convert time, both the server and the PCB devices
                // - TOTP does not use raw time
                // - time is devided into fixed time windows(30 sec)
                // - this makes shore the OTP stayes the same for the whole window
        // convert time to bytes, maby unnessary
                // - The hash function may reaquire an input in binary form
                // - Standard is 8 bytes counter to ensure consistant hashing across system
        // Compute(generate) the hash - secret + counte
        // Choose the starting posistion in the hash
        // convert to OTP
        // 
    }