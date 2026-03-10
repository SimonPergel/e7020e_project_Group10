# rtic_bare10

What it covers:

- serial over USB
- pesky loop based to elegant interrupt driven implementation

---

## Background

The `nRF52` series provides a USB FS (12mbit) interface. On the `nRF52840 DK` this is exposed on a second USB connector, check the DK manual for more info.

In this example you will use this to provide a Virtual COM Port (VCP).

Run the example `rtic_bare10` example using `probe-rs Release` in vscode or in a terminal:

``` rust
cargo run --example rtic_bare10 --release
```

Connect the second USB (micro) cable to your host. (If you don't have an extra cable do this together with some class mate.)

Check that you have a new USB device detected by your host:

``` shell
lsusb
...
Bus 003 Device 008: ID 16c0:27dd Van Ooijen Technische Informatica CDC-ACM class devices (modems)
...
```

If this does not work, check your cable setup and your host machine configuration.

---

## Exercise 1

Start a terminal program, e.g., `cutecom`.

```text
Connect to the port:

    Device       /dev/ttyACMx
    Baude Rate   115200
    Data Bits    8
    Stop Bits    1
    Parity       None
```

In my case it is `/dev/ttyACM3` but it might vary with your setup (dependent on connected devices).

Send the string "abc" (with return mapped to `CR`).

What was received?

[`ABC`]

Now look at the code:

Explain in your own words how this was achieved.

[` It seems that the code recives lower case letters and then flipping one specific bit in each byte, which means that it turns the lower case letter into upper case letter and then echo it back!`]

Commit your answers (bare10_1)

---

## Exercise 2

The implementation is a very simple blocking loop (polling the `usb_dev`) for data.

Turn this into an interrupt driven implementation similar to what you did with the serial communication.

Ask on Discord if you need further hints on how to catch the USB interrupt.

Functionality should remain the same as the original `rtic_bare10` example (which you also find as `rtic_usb_serial.rs`).

Commit your solution (bare10_2)

---

## Exercise 3

Once you get it interrupt driven you are home free and you can build any serial application work over the VCP.

Backport the command line parser from `rtic_bare8` into your USB serial application. You may choose to adopt the per priority tracing channel approach as done in `rtic_bare9`.

Commit your solution (bare10_3)

---

## Learning Outcomes

This is the final step for the labs, zero to hero in 2 weeks. You have reached the maturity to develop your own applications (e.g., the alarm clock ever).

- Virtual Com Port for serial communication over USB.
- Making an application interrupt driven.

Reactive programming allows you to respond to internal and external events. External events are captured by the HW as interrupts. Tasks can be connected to interrupts, such our RTIC application can react to external events. This is the pillar for implementing real-time systems with timing requirements associated to the application.

This is where it all begins!
