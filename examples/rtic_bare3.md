# rtic_bare3

What it covers

- Reading Rust documentation
- Timing abstractions and semantics
- Understanding Rust abstractions

 ---

## Setup

``` shell
cargo doc --example rtic_bare3 --open
```

(When documenting make sure that only one panic handler is enabled in Cargo.toml.)

In the docs, search (`S`) for `Monotonic` and read the API docs. Also search for `Instant`, and `Duration`. You will later use the `now` method, giving you an `Instant` in time. The difference between two `Instant`s is a `Duration`. (There are some ugly looking type parameters, but we can skip those for now...) 

To summarize:

- `Monotonic` is a "trait" for a timer implementation.
- `Instant` is a point in time.
- `Duration` is a range in time.

The `Systick::new(systick, FREQ_CORE)` returns a timer implementing the `Monotonic` trait. The `systick` *peripheral* is moved into the constructor, i.e.,the peripheral will be *consumed*. Thus, you cannot by mistake construct two timers from the same peripheral. The `FREQ_CORE` parameter is set to the core clock frequency (allowing to convert ticks into wall clock time). 

Using a timing library, e.g.[fugit](hhttps://docs.rs/fugit/latest/fugit/index.html), allows you operate on and convert between different time representations.

---

## Exercise 1

Build and run the application in vscode using `probe-rs Debug`.

What is the output in the Terminal?

```
Start Instant { ticks: 0 }
 End Instant { ticks: 300 }
 Diff Duration { ticks: 3000 }
 Diff 3000 ms
```

Now, build and run the application in vscode using `probe-rs Release`.

What is the output in the Terminal?

```
Start Instant { ticks: 0 }
End Instant { ticks: 10 }
Diff Duration { ticks: 100 }
Diff 100 ms
```

Compute the speedup (how many times faster is release)

[ Its 30 times faster]

Does this correspond to the speedup obtained in `rtic_bare2` (if not exact think about why the speedup may differ?)

Hint: What about timing precision for the `mono` timer used in this example.

[The speedup differ because time presition is completley diffrent for the two(rtic_bare2(15.6 ns) and rtic_bare3(10ms)).]

Commit your answers (bare3_1)

---

## Exercise 2

The implementation of `Systick` as a *monotonic* timer sets up periodic interrupt, in this case with a period of 10 milliseconds.

``` rust
type MyMono = Systick<100>; // 100 Hz, 10 ms granularity
```

On each interrupt the monotonic timer is increased. In cases you might want finer granularity (10ms is a fairly long time.)

Change the timer granularity to 2 micro seconds.

``` rust
type MyMono = Systick<500_000>; // 500 000 Hz, 500 kHz, 2 us granularity
```

Build and run the application in vscode using `probe-rs Release`.

What is the output in the Terminal?

```
Start Instant { ticks: 0 }
End Instant { ticks: 111111 }
Diff Duration { ticks: 222 }
Diff 222 ms
```

Explain in your own words why the measured value in milliseconds differs from Exercise 1 above.

Hint: What about the overhead occurring from the `Systick` timer interrupt.

[When we change the SysTic monotonic from 100 Hz to 500 Hz, we increases how often the SysTick iterrups. Basically from 100 to 500 000 iterrups per second, and each interrups is not free. For every tick the CPUu has to enter the interrupt, excecute the SysTick handler and then exit the interrupt. This will infact effect the wait - loop and make it take longer in real time]

Commit your answers (bare3_2)

---

## Exercise 3

In `examples/rtic_bare3_dwt`, you find an alternative implementation of the same program that uses the `DwtSystick` *monotonic* implementation. In contrast to the `Systick` "tick" based implementation `DwtSystick` uses the DWT cycle counter as a free-running timer.

This allows cycle accurate timing, while significantly reducing the number of interrupts the processor has to manage (and thus reduce CPU load).

Build and run the application in vscode using `probe-rs Release`.

What is the output in the Terminal?

```
Start Instant { ticks: 39 }
End Instant { ticks: 8000069 }
Diff Duration { ticks: 125 }
Diff 125 ms
```

Explain in your own words why the measured value in milliseconds relates to Exercise 1 and 2 above.

[DwtSystick combines advantages from both exercise 1 and 2. It gets higher presision like in exercise 2 but with a low CPU overhead like in exercise 1. DwtSystick does not work in the same but it manage to get both the good traits from excersie 1 and 2.]

Commit your answers (bare3_3)

---

## Learning Outcomes

- Time can be treated in a platform independent manner:

  In this exercise we have shown that we can step away from pure hardware accesses and deal with time in a more convenient and "abstract" fashion.

  `Instant` and `Duration` are associated with semantics (meaning) for working with time in an abstract way.

  - `Monotonic` as a trait is defines an API (e.g, the `now` method), and
  - `Systick` provides an implementation working for **all** Cortex M processors. 
  - `DwtSystick` provides an implementation that works for all Cortex M processors supporting a `DWT` unit (`DWT` is not implemented for the smallest Cortex M0/M0+ cores).

  If you implement your application based on `Instant` and `Duration`, your code will be "portable" across all platforms given that the platform provides a timer implementing the `Monotonic` trait (e.g., `Systick` or `DwtSystick`).

- The `Monotonic` trait just defines the API for a *monotonic* timer. E.g., we can have a Real-Time clock (with very low drift) for calendar like functionality, and at the same time another monotonic timer that provide fine granularity but shorter range.

- Code re-use:

  The implementation (testing and verification) of a `Monotonic` timer needs to be done only once, not scattered across thousands of manually written applications.

- Tradeoff between precision and overhead:

  The `Systick` implementation is "tick" based and allows to trade-off precision (granularity) to system load (code running to each time the `Systick` ("tick") interrupt is triggered). Other implementations of `Systick` may use a free running timer instead of the "tick" based approach, in this way an interrupt is triggered *only* when the full range of the timer is reached, thus significantly reducing the overhead. An extreme is the use of an hardware Real-Time-Clock (RTC), which has an in practice infinite range (thus infers no interrupt overhead).

  As a comparison, the Linux kernel is driven by a system tick (jiffy). By default it is set to 10ms, as a reasonable tradeoff between timing accuracy and interrupt handling overhead. Notice here, even "real-time" Linux is not a real-time operating system (no real-time properties/guarantees can be established). The design stems from the Unix operating system, designed for main frames in the 60s with the goals to support multi-tasking and multi-user scenarios, not real-time applications.
