# RTIC on the nRF52840DK board

## Resources

- [nrf52840 Product Specification](https://docs.nordicsemi.com/bundle/ps_nrf52840/page/keyfeatures_html5.html), you may also download the Product Specification (v1.11) as a pdf.

- [Table of processor instructions](https://developer.arm.com/documentation/100166/0001/Programmers-Model/Instruction-set-summary/Table-of-processor-instructions?lang=en), for the Cortex M4 architecture. You may also download the whole Cortex-M4 Technical reference manual.

- [ARM and Thumb-2 Instruction Set Quick Reference Card](https://developer.arm.com/documentation/qrc0001/m), pdf only.

---

## Rust

We assume Rust to be installed using [rustup](https://www.rust-lang.org/tools/install).

Additionally you need to install the `thumbv7em-none-eabihf` target. You may also want to inspect generated binaries using `llvm-tools`.

```shell
rustup target add thumbv7em-none-eabihf
rustup component add llvm-tools
```

---

## Cargo sub-commands

The `cargo` tool is used to manage your applications. You may find the following extensions useful.

- `cargo-edit`, allows you to manage dependencies from the command line.

- `cargo-update`, allows you to update all cargo installed utilities by running:

  `cargo install-update -a`

- `cargo-tree`, allows you to see all dependencies brought in by your application.

```shell
cargo install cargo-edit cargo-update cargo-tree
```

## Rust Embedded

We assume the following tools are in place:

- [cargo-binutils](https://github.com/rust-embedded/cargo-binutils)

- [cargo-bloat](https://github.com/RazrFalcon/cargo-bloat)

- [nrf-unlock](https://github.com/perlindgren/nrf-unlock)

- [probe-rs](https://github.com/probe-rs/probe-rs)

```shell
cargo install cargo-binutils cargo-bloat
cargo install probe-rs --locked --features=cli
cargo install --git https://github.com/perlindgren/nrf-unlock
```

---

## Nordic utilities

Tools for working with the Nordic range of MCUs. Under arch you can install them through `aur`:

```shell
yay nrf5x-command-line-tools
```

To unlock the 52840DK (allowing you to program it over SWD), you can either use the `nrf-unlock` (see above) or the `nrfjprog` tool.

run:

```shell
nrfjprog --recover
```

This operation might take some time (it erases the complete flash memory and flash protection bits).

Notice, the nRF 52840DK comes with the flash protected, so you must run `nrfjprog --recover` to unlock the device.

---

## For low level `gdb` based debugging (optional)

Linux tooling:

- `openocd`
- `arm-none-eabi-gdb`, or`gdb-multiarch` (if running under ubuntu/debian)

Install these tools using your package manager.

---

## Editor

You may use any editor of choice. We recommend `vscode`, the `rust-analyzer` and `probe-rs debugger` plugins. There are many other great plugins for improved git integration, `.md` linting and preview etc.

In the `.vscode` folder of this project, you find a number of configuration files (`launch.json` for target debugging, `tasks.json` for building, etc.), that facilitates embedded Rust development.

For installing the `probe-rs debugger` follow the instructions [here](https://probe.rs/docs/tools/vscode/).

The [vscode](https://marketplace.visualstudio.com/items?itemName=probe-rs.probe-rs-debugger) plugin is now available also from the marketplace (last checked 2024-02-12).

---

All tools are available under both Linux, OSX, and Windows.

## Windows

To use `probe-rs` under Windows you need to install the WinUSB driver. Notice this might class with the `JLink` usb driver installed by the `nRF-Command-Line-Tools`, so I would recommend using `probe-rs` based tooling instead (see above).

- [zadig](https://zadig.akeo.ie/)
- [nRF-Command-Line-Tools](https://www.nordicsemi.com/Products/Development-tools/nRF-Command-Line-Tools/Download?lang=en#infotabs)

## OSX

Should work as described for (arch) Linux. The package manager `brew` or `macports` are your friends. OSX and Linux shares the same POSIX (Unix) heritage, for the OSX case it is based on a classic BSD kernel implementation. `brew`relies to large degree on the OSX system libraries, while `macports`installs dependencies from source (which might take longer time, but reduces the risk of library incompatibilities).

If you run into weird Rust compilation/tooling problems, check you packaga manager to make sure it has not installed any Rust related stuff (rustc, cargo, rustup etc.). Duplicatie toolchains may lead to very strange problems/errors.

---

## Other Useful Resources

- General Embedded
  - [Introduction to SPI](https://www.analog.com/en/analog-dialogue/articles/introduction-to-spi-interface.html#), a short introduction to the SPI interface.

---

## Setup

This crate is contains a ready made configuration for compiling, running/tracing Rust RTIC on the `nRF52840 DK`.

- `Cargo.toml` specifies all dependencies.

- `.cargo/config.toml` specifies further build options. By default `cargo run` will use `probe-run` as specified:

  ```toml
  runner = "probe-rs --chip nRF52840_xxAA"
  # runner = "probe-rs --chip nRF52833_xxAA --no-default-features --features 52833"

  ```

---

## Examples

### Terminal trace using RTT on the nrf52840 DK

Select the runner in `.cargo/config.toml`:

```shell
runner = "probe-rs --chip nRF52840_xxAA"
```

Run your application from terminal:

```shell
cargo run --example rtic_hello
```

(Press Ctrl-C to exit.)

Tracing of panics is supported by the `panic_rtt` crate.

### Terminal trace using RTT using the nrf52840 DK to program an nrf528433 target

Connect the SWD cable to the target. Target needs to be separately powered at 3.0-3.3v unless a level shifter is used in between the DK and the target MCU.

Select the runner in `.cargo/config.toml`:

```shell
runner = "probe-rs --chip nRF52833_xxAA --no-default-features --features 52833"
```

Run your application from terminal:

```shell
> cargo run --example rtic_hello_52833
```

---

### VSCODE based debug and trace examples for the nrf52840 DK

Some simple bare metal examples for you to try out before starting to run your own code: (Here we assume the tools mentioned above have been successfully installed into their default locations. If you installed manually, you may need to tweak paths accordingly, ask in the `software` channel on Discord if you run into some trouble.)

Enable debug view (Ctrl-D), select either `probe-rs Debug` or `probe-rs Release` profile. Press F5 to launch and debug the program in the currently active `vscode` window.

- `rtic_hello.rs`, this example prints the output in the `TERMINAL` pane.
- `rtic_panic.rs`, this example shows how to trace panic messages (in this case over RTT.

- `rtic_crash.rs`, this example shows how a HardFault can be caught by a custom handler.

- `rtic_blinky.rs`, this example shows how you can setup a `SysTick` timer to get a periodically blinking LED without accumulated drift.

- `rtic_usb_serial.rs`, this example showcase a Virtual Com Port (VCP) over USB ACM/CDC using the target USB port of the `nRF52840 DK`

  - Connect a micro USB cable between the host and the target MCU.
  - On the host run a serial terminal (e.g. `cutecom`) and connect to `/dev/ttyACMx` with a setting of 115200 N1.
  - The target application will echo back text sent in upper case.

- `rtic_usb_mouse.rs`, this example emulates a mouse over USB-HID.

  - Connect a micro USB cable between the host and the target MCU.
  - The target will wiggle your mouse pointer.

- `rtic_usb_serial_interrupt.rs`, this example showcase how to make a USB device interrupt driven. The trick is that you need to give the `usb-bus` and `serial` device driver a `'static` lifetime (i.e., these need to live on forever). Normally the lifetime of a variable (resource) is only its local scope. What we do here is to declare the `usb_bus` and `serial` driver as `local` resources to init (those will have a `'static` lifetime). We use the `Option` type to be able to give them a `None` value initially (in Rust all variables need to hold a valid value, thus we need to initialize them). Once the `usb_dev` and `serial` have been constructed we can `replace` the `None` values correspondingly. One can refer to the _inner_ `Some` of the `Option` by `as_ref().unwrap()`. Using this pattern all user code can be written in _safe_ Rust.

- `rtic_paw3395`, minimal viable example for setup and use of the PixArt paw3395 sensor.

- `rtic_cpi_paw3395`, minimal viable example for reading and setting cpi.

Notice, for now we disabled the setup sequence as it seems to fail calibration and make communication instable (reason unknown). Default (boot settings) seems to render satisfiable results.

### VSCODE based debug and trace examples for the nrf52840 DK to program an nrf528433 target

For connecting the DK and general vscode debugging, see above.

Select either `52833 probe-rs Debug` or `52833 probe-rs Release` profile.

- `rtic_hello_52833.rs`, this example prints the output in the `TERMINAL` pane.
- `rtic_usb_mouse_52833`, this example emulates a mouse over USB-HID.

Under the hood, the Rust feature system is used: by default the `52840` is used to select the `nrf52840` target. Building for the `nrf52833` is done by `--no-default-features --features 52833`.

### Cargo Embed

For the `nrf52840 DK` run:

```shell
cargo embed --example rtic_hello
```

Alternatively to manually run:

```shell
cargo embed --example rtic_hello_52833 --no-default-features --features 52833
```

---

### Debugging using GDB (optional)

Select the runner in `.cargo/config.toml` according to your `gdb` install, e.g.:

```shell
runner = "arm-none-eabi-gdb -q -x openocd.gdb"
```

Start `openocd` in a separate terminal:

```shell
> openocd -f openocd.cfg
```

Run the application: e.g.

```shell
> cargo run <application>
```

The `openocd.gdb` script is used to setup the behavior of the debug session, you may change it to your liking. (The default script puts breakpoints at `DefaultHandler`, `HardFault` and `main`, edit it for your needs.)

### Gdb the GNU debugger (optional)

Gdb offers a lot of functionality, you may even write scripts in python to automate debugging. For a summary of commands see e.g., [gdb-refcard](http://fac-staff.seattleu.edu/elarson/web/Linux/gdb-refcard.pdf).

Many of the commands can be executed from the `DEBUG CONSOLE` in `vscode`.

---

## Concluding remarks on debug and trace

Chose the approach and tools dependent on your application needs. If plain tracing is sufficient chose `probe run` or for more flexibility `cargo embed`. If you need to interactively debug your application, use the `probe-rs` vscode integration.

You may also look at [defmt](https://crates.io/crates/defmt), it supports deferred formatting to reduce the run-time overhead (on the target).

---

## Logic Analyzer

The `Hobby Components` [HCTEST0006](https://hobbycomponents.com/testing/243-hobby-components-usb-8ch-24mhz-8-channel-logic-analyser) is a low-cost entry level 8 channel logic analyzer.

It is supported by the [sigrok](https://sigrok.org/wiki/Main_Page) open source signal analysis software suit. The [PulseView](https://sigrok.org/wiki/PulseView) tool is an all in one frontend for digital oscilloscopes and logic analyzers.

Install the `pulseview` tool and the `sigrok-firmware-fx2lafw`. Under arch run:

```shell
yay pulseview sigrok-firmware-fx2lafw
```

For setting up `udev` rules follow the instructions [here](https://gist.github.com/thefekete/7995329c8370cb511a080ee441212b41). This allows you to run the `pulseview` tool as user (else you need `sudo` to get access to the USB device).

### Setup Logic Analyzer

Check that your analyzer turns up as a USB device:

```shell
lsusb
...
Bus 003 Device 009: ID 1d50:608c OpenMoko, Inc. Fx2lafw
```

Now you can start the `pulseview` tool.

- Connect To Device
  - Step 1 select `fx2lafw (...)`,
  - Step 2 make sure that `USB` is selected
  - Step 3 Press : `Scan for devices`
  - Step 4 Select the `sigrok FX2 LO (8ch) ...`
  - Step 5 Press OK.

Now you should be able select sample rate (up to 24MHz) and number of samples and run a capture.

### Trouble shooting

If you don't see the `fx2lafw` alternative among selectable device drivers, then you have a problem with your `sigrok-firmware-fx2lafw` install. If you can select it but the `Scan for devices` is not available or fails, then you have a problem with the permissions (or operating system usb driver). This is highly system dependent, for linux based systems permissions are typically managed/set using `udev` rules as described above.

## Logic Analyzer Nordic PPK2

The Nordic Power Profiler Kit II is a desgined to measure Power consumption of embedded devices. It also comes with a primitive Logic analyzer, that can to track up to 8 channels. To get started install the nRF Connect for Desktop tool. It is available for the Major Platforms (Linux, macOS and Windows) here: https://www.nordicsemi.com/Products/Development-tools/nRF-Connect-for-Desktop/Download. The tool is a "Launchpad" for different subtools. We are interested in the Power Profiler. Install and then launch it. 
Here are some steps you can test your PPK2 as Logic Analyzer:
Flash the test_ppk example to your devboard: `cargo run --example test_ppk`
This application is almost the same as rtic_bare4 with the exception that P1.13 is turned off and on with P0.13 (LED1). P1.13 is particularly pratical because it is exposed via a male Pin on the Devboard (Pretty central in a 2x3 Pin Header). Connect that Pin to Channel 0 of your PPK2. Now the logic analyzer needs a source of logical 0 (0V / GND) and a source of logical 1 (3.3V / VDD nRF). Attach the GND cable of the PPK2 to the extarnal Supply (-) Pin. It is located on the left Hand side of the DevKit below the USB-Connector. Finally attach the VCC cable of the PPK2 to the VDD nRF PIN. It is the leftmost PIN in the large horizontal male Pin-Header.

After all cables are set up, make sure that the devboard is running (you can check whether LED1 is blinking nicely). Connect your PPK2, make sure the switch is turned on and that you use the correct USB-Plug (USB DATA/POWER). In the power Profiler Application you should see the PPK2 now, select it. Enable at least digital Channel 0 and click start. If everything works correctly you should see a nice squarewave on the digital signal graph. The digital-channels graph is very small and in between the Log-window and the large power-consumption graph. Unfortunately the PowerProfiler Software is not too sophisticated but you can make your own measurements/calculations by hovering with the mouse and reading the timestamps.

---

## Exercises

Bare metal programming:

- `examples/rtic_bare1.rs`, in this exercise you learn about debugging, inspecting the generated assembly code, about checked vs. unchecked (wrapping) arithmetics. Provides essential skills and understanding of low-level (bare metal) programming.
- `examples/rtic_bare2.rs`, in this exercise you learn how to measure execution time using raw timer access.
- `examples/rtic_bare3.rs`, here you learn more about RTIC timing semantics and timing abstractions.
- `examples/rtic_bare4.rs`, in this exercise you will encounter a simple bare metal peripheral access API. The API is very unsafe and easy to misuse.
- `examples/rtic_bare5.rs`, here you will write your own peripheral access API. This API is much safer as you get control over bit-fields in a well defined way, thus less error prone.

- `examples/rtic_bare6.rs`, here you will write your own low-level driver and learn how to use a logic analyzer.

- `examples/rtic_bare7.rs`, here you will learn to use Monotonic timers and implement a timed protocol.

- `examples/rtic_bare8.rs`, here you will learn about serial communication. You will also learn how to work with external crates and how to write test.

- `examples/rtic_bare9.rs`, here you will learn more about `rtt` tracing, setting up a trace channel per RTIC priority level.

- `examples/rtic_bare10.rs`, here you will learn how to setup an ACM/CDC Virtual Com Port (VCP) over USB.

---

## Troubleshooting

---

### Fail to connect or program (flash) your target

- Make sure you have installed all the tools.

- Check that your `nRF52840 DK` is found by the host. You should see something like:

  ```shell
  > lsusb
  ...
  Bus 003 Device 009: ID 1366:1051 SEGGER J-Link
  ...
  ```

  - If not check your micro USB cable. Notice, you need a USB data cable (not a USB charging cable).

  - If the problem is still remains, there might be a USB issue with the host (or VM if you run Linux under a VM that is).

- If the device found by host:

  - If running in vscode reports an error like this:

    ```shell
    Caused by:
    0: An ARM specific error occurred.
    1: An operation could not be performed because it lacked the permission to do so: erase_all
    ```

    Then run the following command in the terminal:

    ```shell
    nrf-unlock
    ```

    or,

    ```shell
    nrfjprog --recover
    ```

    Or try using `cargo embed`.

  - In other cases, it might be your `nRF52840 DK`, try swapping cables and kits with other students.

- Don't hesitate to ask on the course Discord.
