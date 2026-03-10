# rtic_bare6

What it covers:

- writing your own low-level driver
- using a logic analyzer

---

## Preparation

Install the `sigrok`/`pulseview` tooling for the logic analyzer (see the `README.md`).

Read the documentation for the `nRF52840` PWM peripheral (Section 6.17). (Yes, reading it from start to end actually helps understanding how it works.)

## Exercise 1

In this exercise you will implement a `blinky` application utilizing the hardware PWM peripheral. PWM is has a lot of useful applications as an energy efficient way to drive a load. In this example we use a LED (you might want to have one or many dimmable LEDs in your project).

The general PWM principle is simple:

- a counter is set to count from 0 to a given `top` value (and then restart from 0)
- an output pin changes dependent on events (e.g., counter `restart`, counter `compare` etc.)

Different vendors may implement this is various ways and offer different types of counting modes (counting upwards, upwards and downwards), and offers different means to handle event generation and setting of compare values etc.

The `nRF52` series provides a quite flexible `PWM` peripheral, so you need to read the product specification in detail to understand how it works.

In the `rtic_bare6` file you find a register layout for `PWM` matching the hardware.

Your first assignment is to implement a simple blinking LED with lowest possible frequency and a 50% duty cycle.

Before starting to code, let's first think about the problem in theory looking at the data sheet. What is the the minimum `PWM` frequency?

[freq_min = PWM_clock/PeriodLength*2 = 125 000 / (2 * 32767) = 1.907 Hz]

Explain how you accomplish this, what values goes into what registers.

```
The base-Clock for the PWM periphial is 16 MHz and the max prescale value is `DIV128`. Dividing the base clock with the prescaler value gives the slowes PWM clock (125 kHz). The `COUNTERTOP` alows a maximum value of 32767 and the `MODE` is set to `UpAndDown` which means that we have to multiply with 2 (According to the data-sheet(page544))
- `COUNTERTOP`= 32767
- `PRESCALER` = 7
- `MODE` = UpAndDown
```

Hints:

- The `PWM` frequency is determined from `PRESCALER`, `COUNTERTOP` and `MODE` (updown has twice the period)
- The duty cycle is determined by the compare value (`COUNTERTOP`/2 gives a 50% duty cycle)

Now you can go ahead implement the code.

Hint:

- You need to setup the pin direction to output (similar to `bare5`).
- You need to setup a _sequence_ in RAM, and set the `SEQ_0_PTR` to point to the address of the sequence. Assume `pwm0` is the register.

```rust
    let pwm0 = unsafe { &mut *PWM0::get() }; // get the reference to PWM0 in memory

    ...

    let mut pwm_seq1 = [0x7000u16 | 0x8000]; // Falling Edge Parity
    rprintln!("pwm_seq {:p}", &pwm_seq1); // print the address of seq1
    pwm0.SEQ_0_PTR.write(&pwm_seq1 as *const _ as u32);
```

Notice, you need to adjust the `pwm_seq1` array value(s) to your use case. For a simple PWM you can do with a single sequence with one element (using the common loading scheme) and no loop.

Commit your blinking LED code (bare6_1)

---

## Exercise 2

It can be hard to see that frequency and duty cycle is exactly correct. (For a blinking LED it might not be that critical, but if you use PWM to control e.g., a servo or as a digital communication means it is important that you the exact correct waveform.)

You can verify this using an oscilloscope (that will allow you to observe the analog characteristics such as raise/fall times, ringing/overshoots etc.) However, if we are merely interested in the digital characteristics (0/1, low/high), we can use a logic analyzer instead. This also allows us to decode signalling protocols, SPI/I2C/USART/USB etc.

The `Hobby Components` analyzer is a low-end/cheap (10 Euro) analyzer that allows sample rates up to 24MHz (I successfully tested it at 48MHz, but it depends on the host-pc to keep up with the incoming data, so your milage might vary). In any case, for inspecting the digital waveform for our slow blinking LED it should be sufficient. (The PIN speed of the `nRF-52` series is limited to 8MHz, so the logic analyzer will cope with any signals/protocols that the `nRF` throws at you, with the exception of USB if you cannot run it at 48MHz.)

Check the `nRF42840 DK` documentation an find a suitable `GND` and a header with the `LED` pin exposed.

Connect `GND` and `Channel 0` from the analyzer to the `GND` and `LED` correspondingly. Start `pulseview` and select the `sigrok FX2 LA` decoder.

Take 100k samples at 100kHz (one second). That should cover more than one period right. Measure the PWM frequency, and the duty cycle.

Measured PMW frequency.

```
dt = 510 ms(messured)
frequency_PMW = (1/(dt))*1000 = 1000/510 = 1.96 Hz
```

Measured duty cycle (in percentage of the period).

[`duty cycle = ON_time/total_time = (253/510)*100 = ~50 %`]

Compute the ratio in between measured PMW frequency and calculated frequency.

[`ratio = frequency_PWM / frequency_calculated  = 1.96 / 1.907 = 1.0277`]

Why do you think they may differ?

[`The calculated frequency value is based on ideal values from the datasheet, in real life this may differ a tiny bit. This is because of integer rounding, not spot on data collection used in the calculations and clock source accuracy.`]

Now change the `PRESCALER` to give a 1MHz PMW clock.

What is the expected PMW frequency.

[`freq_min = PWM_clock/PeriodLength*2 = 1*10^6 / (2 * 32767) = 15.259 Hz`]

Verify the computed PMW frequency (you need to change sample frequency).

Measured PMW frequency.

```
dt = 63.59 ms(messured)
frequency_PMW = (1/(dt))*1000 = 1000/63.59 = 15.7257 Hz
```

Compute the ratio in between measured PMW frequency and calculated frequency.

[`ratio = frequency_PWM / frequency_calculated  = 15.7257 / 15.259 = 1.03 `]

Hint:

You should see the same ratio as before, else you might need to adjust the sample frequency.

Commit your blinking LED code (bare6_2)

---

## Exercise 3

Your code is a sequence of setup steps (and then just a never ending loop).

Look at the `GPIO` input and see how you can read the BUTTONs.

In the never ending loop, poll two buttons, and let one button increase the duty cycle and another button decrease the duty cycle.

You might want to "wait" in between checking the buttons (so the changes are not too quick). You can use the stupid `wait` (that just runs a loop). It is stupid as it burns CPU cycles and the time it takes to run will be dependent on if you compile in dev or release mode. But it will do for now. Later we will take advantage of the interrupt driven nature of RTIC to perform tasks in a timely manner.

Comment the code such that it is obvious to the end user how to use your super LED button application.

Commit your blinking LED code (bare6_3)

---

## Exercise 4 (Optional)

The low-level code quickly becomes a bit messy. You may want to factor out functionality for setting up the GPIO PINS as inputs/outputs, functions for configuring/setting up the PWM, and separate function that sets a PWM compare value.

Refactor your application to suit your needs and comment each function so that other developers clearly understand their purpose and how they should be used.

Commit your blinking LED code (bare6_4)

---

## Learning Outcomes

In this exercise you have learned how to:

- read data sheets and implement a PWM driver at the lowest level
- read digital inputs, and
- verify digital signal characteristics using a logic analyzer.
- Optionally you have re-factored code for improving readability and facilitate re-use. This is the first baby steps towards a Hardware Abstraction Layer (HAL).

  After about 98734578943573 iterations you might come up with something that is both generic enough for a wide variety of use cases and yet simple to use. This is the **Art of HAL Design**.

  Luckily lots of talented and enthusiastic developers in the open source community are to our aid. For the `nRF52` series of micro-controllers there is a ready-made HAL with abstraction for both GPIO and PWM.

  Later you might want to improve your HAL. E.g., the PWM supports longer sequences and loops. The loop functionality requires that you use two sequences. You may use the `SHORT` to connect a loop end event to restarting a sequence (or you may use an interrupt for even more flexibility). Compare to how the official [`nrf-hal`](https://github.com/nrf-rs/nrf-hal) Rust HAL supports PWM. Eventually you can contribute upstream. Judging from their example the `PWM` support is easy to use but quite limited compared to what the hardware actually supports.
