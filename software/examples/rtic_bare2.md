# rtic_bare2

Measuring execution time:

What it covers:

- Generating documentation
- Using core peripherals
- Measuring time using the DWT
- Inspecting binaries

---

## Setup

``` shell
cargo doc --example rtic_bare2 --open
```

NOTICE: For this to work comment out all but one panic handler in the `Cargo.toml` file.

`cargo doc` will document your crate, and open the docs in your browser. If it does not auto-open, then copy paste the path shown in your browser.

Notice, it will try to document all dependencies, you may have only one panic handler, so if the command fails, temporarily comment out all but one panic handler in `Cargo.toml`.

In the docs, search (`S`) for DWT, and click `cortex_m::peripheral::DWT`.

Read the API docs.

---

## Exercise 1

Build and run the application in vscode using `probe-rs Debug`.
It will take a while to run as we loop one million times.

What is the output?

[Start Count 3468118882
 End Count   3644119167
 Diff Count  176000285]

Rebuild and run using `probe-rs Release`.

[Start Count 2797462021
 End Count   2804462041
 Diff Count  7000020]

Compute the ratio between debug/release optimized code speedup.

[ratio showed that when running release, it was about 25 times faster than when running debug]

Commit your answers (bare2_1)

As seen there is a HUGE difference in between Debug and Release builds.

In `Debug` builds, the compiler preserves all abstractions, so there will be a lot of calls and pointer indirections.

In `Release` builds, the compiler strives to *inline* all abstractions into straight line code.

This is what Rust *"zero-cost abstractions"* means, not zero execution time but rather, as good as it possibly gets" (you typically pay no extra cost for using abstractions at run-time).

---

## Exercise 2

Explain in your own words why computing the difference (duration) is using a wrapping operation `end_count.wrapping_sub(start_count)`. Hint, what might happen if we use a normal subtraction that checks for overflow...

[The cycle counter can overflow and then wrap back to zero. So by using wrapping_sub it will compute the correct elapse time even if that happen. A normal subtraction could instead panic.]

Commit your answers (bare2_2)

---

## Exercise 3

To inspect the generated binary run:

``` shell
cargo objdump --example rtic_bare2 --release -- --disassemble > rtic_bare2_release.asm
```

Open the generated file in `vscode` and search for the `wait` function.

```
000004c2 <wait>:
     4c2: b580         	push	{r7, lr}        # saves(push) register r7(frame pointer) on to the stack and returns address (lr) on the stack.
     4c4: 466f         	mov	r7, sp              # moves stackpointer(sp) to r7, so r7 now points to to current stack pointer
     4c6: 2800         	cmp	r0, #0x0            # Excecute a comparison operation between input argument in r0 with the value zero
     4c8: bf08         	it	eq                  # Creats a If-then block, excecute next instruction only if previous comparision instruction is true
     4ca: bd80         	popeq	{r7, pc}        # Excecute a stack pop operation only if the previous equal condition is met based on the previous comparisons
     4cc: 3801         	subs	r0, #0x1        # Subtracts one from whats in r0 ( Decrement loop counter)
     4ce: bf00         	nop                     # no operation, lets one CPU cycle go past
     4d0: d1fc         	bne	0x4cc <wait+0xa>    # If r0 != 0, branch back to to decrement instruction    @ imm = #-0x8
     4d2: bd80         	pop	{r7, pc}            # this mone restores r7 and returns from the function, loads the value from stack into r7 and the next value into pc, increase sp accordingly
```


``` rust
pub fn wait(i: u32) {
    for _ in 0..i {
        // no operation (ensured not optimized out)
        cortex_m::asm::nop();
    }
}
```

Add comments to the pasted function explaining what the instructions do and how they collectively implement the `wait` function above.

(Lookup the `cmp`, `it`, `subs`, `bne`, `bx`/`bxeq` instructions).

See [Thumb instruction set summary](https://developer.arm.com/documentation/ddi0210/c/Introduction/Instruction-set-summary/Thumb-instruction-summary) for further details.

Commit your answers (bare2_3)

---

## Exercise 4 (Optional)

Generate dump for the `Debug` build.

``` shell
cargo objdump --example rtic_bare2 -- --disassemble > rtic_bare2_debug.asm
```

Open the generated file in `vscode` and search for the `wait` function.

[paste the `wait` function here]

Obviously the generated code is much more verbose (it is quite literally  implementing an "iterator" for the `u32` type).

Try to figure out the different sections: where the stack frame is built for the function, the iterator code, error handling (if any), and the return code, and write comments, en the assembly listing to explain how the generated code implements the `wait` function.

Commit your answers (bare2_4)

---

## Learning Outcomes

- You have confirmed that Rust generates:
  really, really, bad code in debug build (beware!).
  really, really, really good code in release build!

- You have setup cycle accurate timing measurements.
  Consistent and predictable (down to a few clock cycles).
  
- Dealing with hardware puts another dimension to coding. In order to achieve the maximum performance you need to understand the underlying hardware and all its subtle details.

- In cases you might want/need to look at the generated assembly, now you know how. There is no black magic, the compiler takes an input program (in Rust) and through a number of steps generates a binary (which we can with some effort understand).




