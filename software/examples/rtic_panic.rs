// examples/rtic_panic

#![no_main]
#![no_std]

use nrf52840_hal as _;
use panic_rtt_target as _;

#[rtic::app(device = nrf52840_hal::pac)]
mod app {
    use rtt_target::{rprintln, rtt_init_print};

    #[shared]
    struct Shared {}

    #[local]
    struct Local {}

    #[init]
    fn init(_: init::Context) -> (Shared, Local, init::Monotonics) {
        rtt_init_print!();
        rprintln!("init");

        for a in (0..=3).rev() {
            rprintln!("10/{} = {}", a, 10 / a);
        }

        (Shared {}, Local {}, init::Monotonics())
    }
}
