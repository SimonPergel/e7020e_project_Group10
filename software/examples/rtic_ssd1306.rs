// examples/rtic_hello.rs

#![no_main]
#![no_std]

use nrf52840_hal as _;
use panic_rtt_target as _;

#[rtic::app(device = nrf52840_hal::pac)]
mod app {

    use embedded_graphics::mono_font::iso_8859_2::FONT_6X13;
    use rtt_target::{rprintln, rtt_init_print};

    #[shared]
    struct Shared {}

    #[local]
    struct Local {}

    #[init]
    fn init(cx: init::Context) -> (Shared, Local, init::Monotonics) {
        rtt_init_print!();
        rprintln!("\n--- Hello e7020e ---\n");

        use embedded_graphics::text::Text;
        use embedded_graphics::{mono_font::MonoTextStyle, pixelcolor::BinaryColor, prelude::*};
        use ssd1306::{prelude::*, I2CDisplayInterface, Ssd1306};

        use nrf52840_hal::{
            gpio::*,
            twim::{self, Twim},
        };

        // Connect SDA to P0.27 and SCL to pin P0.26
        let port0 = p0::Parts::new(cx.device.P0);

        let scl = port0.p0_26.into_floating_input().degrade();
        let sda = port0.p0_27.into_floating_input().degrade();

        let pins = twim::Pins { scl, sda };
        let i2c = Twim::new(cx.device.TWIM0, pins, twim::Frequency::K100);

        let interface = I2CDisplayInterface::new(i2c);
        let mut disp = Ssd1306::new(interface, DisplaySize128x32, DisplayRotation::Rotate0)
            .into_buffered_graphics_mode();

        disp.init().expect("Display initialization");
        disp.flush().expect("Cleans the display");

        let style = MonoTextStyle::new(&FONT_6X13, BinaryColor::On);
        Text::new("Hello E7020E!", Point::new(10, 24), style)
            .draw(&mut disp)
            .expect("Drawing text");

        disp.flush().expect("Render display");

        (Shared {}, Local {}, init::Monotonics())
    }
}
