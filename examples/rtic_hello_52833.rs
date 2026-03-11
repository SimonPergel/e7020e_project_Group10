// examples/rtic_hello.rs
// Change the default feature to `52833` in the `Cargo.toml`
// Or compile with `--no-default-features --features 52833`

#![no_main]
#![no_std]

use panic_rtt_target as _;

#[rtic::app(device = nrf52833_hal::pac)]
mod app {

    use rtt_target::{rprintln, rtt_init_print};

    #[shared]
    struct Shared {}

    #[local]
    struct Local {}

    #[init]
    fn init(_: init::Context) -> (Shared, Local, init::Monotonics) {
        rtt_init_print!();
        rprintln!("\n--- init ---\n");
        for a in 1..=12 {
            rprintln!("RTIC Says Hello, to all students!! {}", a);
        }

        (Shared {}, Local {}, init::Monotonics())
    }
}

// From terminal:
// cargo run --example rtic_hello
//
// From vscode:
// You can select the debug session, debug icon on the left side, or press Ctrl-Shift-D.
// Chose 'probe-rs Debug' in the drop-down.
// Press the play symbol or F5. (this will compile/flash/debug the application)
//
// RTT Trace output will be visible in the TERMINAL pane at the bottom.
// The DEBUG CONSOLE pane shows the debug session status/log.
//
// You can experiment by inserting a breakpoint on line 25. Click to the left of 25.
// (Breakpoints are visible as red-dots, and to the left under BREAKPOINTS)
//
// The "transport has the following shortcuts"
// F5, to compile and start the application/resume from pause
// F6, to pause a running application
// F10, to step over statement
// F11, to step into function
// F12, to step out of function
//
// Ctrl-Shift-F5 to restart
// Shift-F5 to end a debug session
