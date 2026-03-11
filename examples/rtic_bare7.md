# rtic_bare6

What is covers:

- RTIC based timing using the Monotonic trait
- Implementing a timed protocol (Morse)
- Optionally implement Morse protocol using the PWM peripheral

---

## Preparation

Run the application to see that it compiles and that you get a enjoyable blinking led with just a few lines of code thanks to the automatically generated `PAC` (Peripheral Access Crate) and the Rust `nRF` hal abstractions.

For reference, generate documentation:

``` shell
cargo doc --example rtic_bare7 --open
```

Look through the source code, and make sure you have understood how it operates.

In this case we use an RTIC resource to hold a `LED` abstraction:

``` rust
type LED = Pin<Output<PushPull>>;
```

`Pin<Output<PushPull>>` denotes the type for a pin set to be an output with push pull characteristics (exactly what you need/want for a blinking led).

``` rust
let led1 = port0.p0_13.into_push_pull_output(Level::Low).degrade();
```

Here `led1` is an instance of this type (for the `port0.p0_13` pin). `degrade` erases the port/pin specifics so that it gets the `LED` type.


The `blink` task is trigger by the `blink::spawn_at` (from `init` and later from within the `blink` task itself), at a fixed time instance.

``` rust
let next_instant = instant + 1.secs();
```

Computes the next time instance based on the current `instant` (given as a task argument).
This allows us to generate sequences of events without accumulated drift (besides the inaccuracy of the underlying hardware clock).

The local resource `cnt` is used as a counter. `cnt % 2` computes the modulo 2 (i.e the rest after division by 2) value of the counter (alternating between the values 0 and 1).

``` rust
*cx.local.cnt += 1;
```

Increases the counter. Recall the earlier labs on arithmetics. You may want to use a `wrapping` operation (or type) for `cnt` unless you have turned of overflow checking (else you may run into a panic when overflowing). 

---

## Exercise 1

Now let's try to break this program.

Omit the `degrade` call, and see if the program compiles.

What was the generated error?

[`error[E0308]: mismatched types`]

Undo the change so it compiles again.

Change to:

``` rust
let led1 = port0.p0_13.into_pulldown_input().degrade();
```

That is try to misconfigure the pin.

What was the generated error?

** `error: unused import: `Level`` and `error[E0308]: mismatched types` **

Change to:

``` rust
let led1 = port0.p0_13.into_push_pull_output(Level::High).degrade();
```

Here we have the correct output pin configuration but an initial pin state value set to `High`.

Do you get an error?

[` No i did not get any errors`]

What is the difference in behavior compared to the original program?

[` The diffrence is that when the pin becomes an output, its driven to LOW immediatly in the original program and HIGH for the new code implementation. This means that for the original program the first duration, the LED will be on and vice versa if the program use the new code `]

Change to:

``` rust
let led1 = port0.p0_14.into_push_pull_output(Level::Low).degrade();
```

Did you get an error?

[` No I did not get any errors`]

What is the difference in behavior compared to the original program?

[`Instead of LED 1 blinking, now LED 2 is the one blinking`]

Why was this accepted, while changing an output to an input was not?

[`The code still matches the expected type for led1, but we did not change type of the pin. Only the pin number and both pins are outputs so its allowed. But if we instead chanhing an output pin into and input pin, the type changes and it will fail beacause the rest of the code is expecting an output pin. `]

Hint:

Rust RTIC holds your hand, exactly to the amount to guarantee that your program makes sense. The mechanism at play here is *type state* programming. I.e., we encode the state (e.g., input vs. output) as part of the *type* of the pin. That prevents mis-use. 

By erasing (`degrade`) the actual pin-number from the type we get it more generic, so that *any* pin configured as a push-pull output can be toggled by the `blink` task.

We will use this property in the next exercise.

Commit your answers (bare7_1)

---

## Exercise 2

Now run the `rtic_bare7b` example.

What do you see happening?

[`The two LED(1 and 2) are alternate blinking.`]

Look at the code and explain in your own words how this behavior was achieved.

Hints1:
- We now have two `LED` instances. Locate the changes in the code.
- We now have two tasks. Locate the changes in the code.
- Look the `blink_function` and how is it able to handle two different leds.
- Look at the calls to the `blink_function` and the spawns.

[`In the code (Initiate periodic process), there are two diffrent LED instances that is created. The process are peroidic and is setup so LED 2 is to start one second after LED 1. This means that at first both LEDs are shining and after 1 second LED 1 is to blink and 1 second later, LED 2 is to blink. Both task then repeat every 1 second and this means that they will stay exactly one second out of phase untill the program is turn off. `]

The period of led1 and led2 is now 2 seconds.

Now we want led2 to blink with a period of 1 second, i.e. half the period.

Hint:
Look in the documentation for (`millis`).

Commit your working implementation as bare7_2

---

## Exercise 3 

Rust has a powerful trait based type system. We can leverage on this to further generalize the code as seen in `rtic_bare7d`.

Here we demonstrate how code operating on underlying hardware can be written solely based on the [embedded_hal](https://docs.rs/embedded-hal/latest/embedded_hal/) traits.

Generate the documentation and lookup `digital::v2::OutputPin`.
You should find something like:

``` rust
pub trait OutputPin {
    type Error;
    fn set_low(&mut self) -> Result<(), Self::Error>;
    fn set_high(&mut self) -> Result<(), Self::Error>;

    fn set_state(&mut self, state: PinState) -> Result<(), Self::Error> { ... }
    }
```

The `nrf52840-hal` implements the `embedded_hal::digital::v2::OutputPin` trait for the `OutputPin` type:

Lookup the implementation (follow the [src] link)

What is the Error type for OutputPin.

[`The type is "Infallible" `]


### Trait functions

Now look at the `mod led`, there you find two functions `led_on` and `led_off`. Looking closer at the `led_on`:

``` rust
pub fn led_on<E>(led: &mut dyn OutputPin<Error = E>) {...}
```

The `led` parameter is a trait object reference generic to the `Error` type. (The concrete `Error` type is given by the `nrf52840-hal` as seen above).

You can operate on the `led` parameter through its API (the `OutputPin` trait).

Use the trait functions to make the led blink:
Hint: its super simple, just one line for `led_on`, one line for `led_off`.

Was it simple?

[`If you follow the documentation and understand how it works, then its understandable. `]

With this two lines of code you have written your first "library". The `led` module is very portable, it depends ONLY the `embedded-hal`(and not the `nrf52840-hal`), so will work on any hardware which implements the `OutputPin` trait.

### Efficiency

The `led` parameter is a trait object (reference). In general trait objects are implemented by means of a VTABLE, and executed by "dynamic dispatch". This results in an indirect function call and hamper some possibilities for code optimization.

In many cases, Rust + LLVM can at compile time turn the "dynamic dispatch" into a "static dispatch". There is however no guarantee the compiler will succeed.

You can force static dispatch by using: `&mut impl Trait` instead of `&mut dyn Trait`.

Change the code to guarantee "static dispatch".

Was it simple?

[`It fairly simple`]

With this two lines of code you have written your second "library", now, with guaranteed "static dispatch".

Using static dispatch implementation you can even omit the type parameter, and let the compiler infer the concrete `Error` type.

Remove the type parameter, and verify that it still works.

Was it simple?

[yes and no]

### Validation

Comment out the `rprintln` in the `led_on` function (to reduce the noise, we want just to look at the code generated for the `set_low` operation).

``` shell
cargo objdump --example rtic_bare7d --release -- --disassemble --print-imm-hex > rtic_bare7d.asm
```

Lookup the `led_on` code in the `rtic_bare7d.asm` file. You should find something like:

```asm
000005e0 <rtic_bare7d::led::led_on::he613b08d49fb7aba>:
     5e0: 7800         	ldrb	r0, [r0]
     5e2: f240 510c    	movw	r1, #0x50c
     5e6: f2c5 0100    	movt	r1, #0x5000
     5ea: f501 7140    	add.w	r1, r1, #0x300
     5ee: 0682         	lsls	r2, r0, #0x1a
     5f0: f000 001f    	and	r0, r0, #0x1f
     5f4: f04f 0201    	mov.w	r2, #0x1
     5f8: bf5c         	itt	pl
     5fa: f240 510c    	movwpl	r1, #0x50c
     5fe: f2c5 0100    	movtpl	r1, #0x5000
     602: fa02 f000    	lsl.w	r0, r2, r0
     606: 6008         	str	r0, [r1]
     608: 4770         	bx	lr
```

It is not completely obvious how the compiler translated the `OutputPin.set_low()` to code (since it is what is does).

- r0 is the argument to the function (and indicate which pin to set low).
- r1 is used to compute the corresponding address.
- it will set r0 to 0x5000_050c + 0x300 initially

Look in the GPIO (6.9.2) what register this address correspond to.

[`It correspond to P1.OUTCLR register(Port 1)`]


- r1 will conditionally (based on `itt pl`) be set to address 0x5000_050c

Look in the GPIO (6.9.2) what register this address correspond to.

[`It correspond to P0.OUTCLR register(Port 0)`]

Explain in your own words the purpose of:

```asm
    602: fa02 f000    	lsl.w	r0, r2, r0
    606: 6008         	str	r0, [r1]
```

[`The purpose is to change the state of the GPIO pin by creating a bitmask and shifting it to the position corresponing to the pin-number, setting the targeted bit to 1. The second instruction stores the value saved in register R0 and writes this value to the GPIO harware memory(the address in R1)`]

My personal reflection:

To me it seems like the compiler is clever here. It is not allowed to inline `led_on` so it generates generic code serving both ports `P0` and `P1` and uses the argument to tell which port its on. It filters out the 32 lowest bits, and use that to create a bit mask for the clearing of the specific pin. Notice, the hal implements the `OutputPin` trait for both ports `P0` and `P1` and in our `led` module we don't give any restriction to which port we want to operate.

Rust + LLVM would of course have generated even smarter code if we did not prevent it from inlining, but then we would have been forced to look at the complete `blink` function. Even without inlining it should have enough information to give two implementations (one for `P0` and one for `P1` and since only `P0` is used the `P1` implementation could have been optimized out). It is always a trade-off between compiler complexity, compilation time, and performance. Rust + LLVM is steadily improving. There are also lots of hidden options to LLVM (e.g., how aggressive it should be regarding code duplication).

Commit your solution as bare7_3

---

## Exercise 4

For this exercise you should start from the `rtic_bare7c` example.

Look up [Morse Code](https://en.wikipedia.org/wiki/Morse_code) on wikipedia.

Each character is represented by a set of `short` and `long` pulses, e.g., `s = ...`, `o = ---`, etc. In this way you can send words like SOS by a sequence `... --- ...`.

```text
Each Morse code symbol is formed by a sequence of dits and dahs. 

The dit duration is the basic unit of time measurement in Morse code transmission. The duration of a dah is three times the duration of a dit. Each dit or dah within an encoded character is followed by a period of signal absence, called a space, equal to the dit duration. The letters of a word are separated by a space of duration equal to three dits, and words are separated by a space equal to seven dits.
```

Implement a system that sends SOS repeatedly according to the specification/standard. The transmission speed should be settable by a constant. Notice, for higher rates you will need to change the `TIMER_HZ` to get higher time resolution.

Hints:

- Use RTT tracing and breakpoints in the development/testing.
- Use the logic analyzer to observe the exact timing obtained. Its hard to judge by looking at the LED.

Commit your working implementation as bare7_4

---

## Exercise 5 (Optional)

Generalize your implementation to cope with the full alphabet. Send the text `1337 RUST RTIC FTW` in Morse code repeatedly.

Hints:

- Test each letter individually.
- Make use of RTT tracing and breakpoints to debug your code.
- Use the logic analyzer to observe the exact timing obtained. Its hard to judge by looking at the LED.

Commit your working implementation as bare7_5

---

## Exercise 6 (Extra Optional)

Make it emit Morse for

``` shell
1337 RUST RTIC FTW
1338 RUST RTIC FTW
1339 RUST RTIC FTW
1340 RUST RTIC FTW
...
```

That is, the Morse code printer should be able to deal with numeric values as integers, translate the integer (e.g. u32) to a sequence of symbols. One way to do this is to use the built in formatting of Rust to first obtain a sting and from there translate each character of the string into Morse.

Hint:

- Look at how you can use formatting to first create an `&str` and then convert the formatted text as Morse.

Commit your working implementation as bare7_6

---

## Exercise 7 (Mega Optional)

Look at your PWM code from `bare6`.

Use the loop mode in hardware to emit sequences, and trigger events/interrupts when each sequence is ready. You can use the special `WaveForm` mode for the `DECODER` for having each different periods.

I haven't implemented it myself, but I believe it should be possible to find a configuration that allows Morse to be correctly emitted by hardware (with a bit interrupt juggling between sequences).

Break down the problem in "baby steps":

- test the looping mode (with two sequences)
- test interrupts generated on sequence ends
- test the `WaveForm` mode changing period

Hints:

- The usual... tracing, breakpoints etc.
- Use  the logic analyzer to observe the exact timing obtained. Its hard to judge by looking at the LED.

Commit your working implementation as bare7_7

---

## Learning Outcomes

- The use of a Monotonic timer to generate sequences of tasks with precise timing 
- The use of HAL abstractions and type state programming to obtain code that is correct by design (impossible to mis-use/mis-configure)
- More advanced programming in Rust using traits, trait objects and static dispatch.
- Optional exercises covers further generalizations and utilization of underlying hardware for advanced purposes.

The embedded Rust ecosystem is designed to hold your back. Bugs are caught by the compiler and you can focus on the application logic.
