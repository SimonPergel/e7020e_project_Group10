# rtic_bare4

What it covers:

- Raw pointers
- Volatile read/write
- GPIO (a primitive abstraction)
- Bitwise operations

---

## Background

Hardware access is at the heart of embedded programming. In this exercise we will take a very primitive and unsafe approach to accessing peripherals.

We will use raw pointer reading/writing similar to C/C++ style programming. Later you will learn how to make safe abstractions to underlying hardware.

---

## Exercise 1

Build and run the application use the debug profile (`probe-rs Debug`).

Did you enjoy the blinking?

[Yes, very much!]

Now lookup the [nRF52840_PS_v1.8](https://infocenter.nordicsemi.com/pdf/nRF52840_PS_v1.8.pdf), and read each section referred:

- 6.9   GPIO - General Purpose input/output
- 6.9.2 Registers

Also look in the documentation for the [nRF52840 DK](https://infocenter.nordicsemi.com/pdf/nRF52840_DK_User_Guide_20201203.pdf).

Search for `LED 1` and figure out how it is connected.

Document the program:

- Explain at a higher level what the program does, what is the purpose of lines marked `A`, `B` and `C`. You may want to put a breakpoint at each `wait` and run let the program break at these to inspect the state of the LED.

```
Answer:
High-level: The program basically runs a simple blinking example. Its sets pin 13 to high(LED1 turns on), waits 1000000 cycles(busy wait) then clears the pin(set to low) which makes the LED turns off and then waits again before doing it all over again. 
A:The pin 13 is set to one which means it is now acting as an outputpin. 
B: Tuns LED 1 on.   
C: This turns the LED 1 of.
```

- For each low-level access `A`, `B` and `C` refer to the corresponding section in the Product Specification (data-sheet), and the dev-kit manual.
```
Answer:
A: section - 6.9.2.10 PIN_CNF[n] (n=0..31)
B: section - 6.9.2.2 OUTSET
C: section - 6.9.2.3 OUTCLR
```

- Explain the address computation in `A`, and bitwise operations in `A`, `B` and `C`. (What are the effects.)
```
Answer:
A:P0_CNF is the base address of the pin config. register, then it adds 52 which points to pin 13. The pin 13 is then set to one which means it is now acting as an outputpin. 
B: Tuns LED1 on by shifting a "1" "13" times (set bit 13 to high), which corresponds to pin 13, P0_SET is the is the GIPO output set register.
C: This turns the LED1 of by clearing bit 13. This is done by `1 << 13` to `P0_CLR` which clears the corresponing bit in the GPIO output register, which drives pin `P0.13` low and making the LED1 turn of.
```
Commit your answers (bare4_1)

---

## Exercise 2

The function `write_u32` is marked `unsafe`.

Explain in your own words why?

[This function is marked unsafe because Rust need to know that its safe to write to an address outside Rust boundres(what Rust sees), Rust basically needs a guarantee from the programmer that by writing to this address certain conditions is still holding, example valid memory location, address properly aligned for u32 or that it is legal or harmless.  ]

The function `read_u32` is also marked `unsafe`.

Explain in your own words why?

[ The function must be marked as unsafe because even reading of an memory address could have consequences, so the programmer need to guarantee that certain conditions holds, some example is that the address should be aligned correclty and that is may not cuase any unexpected changes ]

Hint: Read the documentation [read_volatile](https://doc.rust-lang.org/core/ptr/fn.read_volatile.html). Even reading a memory address might have side effects...

Commit your answers (bare4_2)

---

## Exercise 3

Volatile read/writes are explicit *volatile operations* in Rust, while in C they are declared at type level (i.e., access to variables declared volatile amounts to volatile reads/and writes).

Both C and Rust (even more) allows code optimization to re-order operations as long as data dependencies are preserved.

What would happen if `B` is ordered after `C`.

[If just B is moved after C, the LED would appear constantly ON. The reason may be that is would blink so fast(immediate switch) that the human eye would not be able to see the ON/OF switch]

Notice `B` and `C` refer to different locations/addresses and has as such no data dependencies. Thus, without the ordering property of volatile operations Rust would have been free to re-order them. (Re-ordering is done by the compiler to improve the efficiency of the code.)

Commit your answers (bare4_3)

---

## Exercise 4

Now uncomment the two lines marked `D`, and run the code.

What are the printed values of `P0_DIR`?
```
Before: P0_DIR prints 0
After: P0_DIR prints 8192
```

Explain in your own words, how the value of the `>P0_DIR` register is changed without any operation writing to it.

[When writing to PIN_CNF[n].DIR, the GPIO hardware automatically updates the corresponding bit in P0_DIR. If you read in the data sheet for PIN_CNF, it seems that both PIN_CNF and PIN_DIR are pointing to the same physical register bit on the hardware. ]

Hint: Read the documentation for the `DIR` and `CNF` registers carefully, the answer is there.

Commit your answers (bare4_4)

---

## Exercise 5

The vscode plugin also supports parsing and displaying System View Description (SVD) files showing the memory mapped peripherals. In the `launch.json` you give a path to the SVD file:

``` toml
"coreConfigs": [
    {
        "coreIndex": 0,
        ...
        "svdFile": "./.vscode/nrf52840.svd"
    }
]
```

Under `VARIABLES/Peripherals`, you find the complete list of peripherals. 

Navigate to the `GPIO` peripheral, expand it find and `Add to Watch` both `GPIO.P0.OUT.PIN13` and `GPIO.P0.PIN_CNF13`.

Restart the application (it should halt at the first `wait`. At this point you should now see the values of `GPIO.P0.OUT.PIN13` and `GPIO.P0.PIN_CNF13`). You can expand the `GPIO.P0.PIN_CNF13` to find all the fields.

What are the value of each field in `CNF13`

```
DIR = 1 @ 0x50000734:0..1
INPUT = 0  @ 0x50000734:1..2
PULL = 00  @ 0x50000734:2..4
DRIVE = 000  @ 0x50000734:8..11
SENSE = 00  @ 0x50000734:16..18

```

Commit your answers (bare4_5)

---

## Learning Outcomes

- You have learned about `volatile` read/write operations and the importance of instruction ordering.

- You have introduced a primitive abstraction to reading/writing raw data, and abstract their addresses using constants (similar to C). 

- Similar to C, our interface (API) is still completely unsafe. (We can pass in any address to the `read/write` functions, thus correctness is completely up to the programmer.)

- As you have seen in exercise 4, you really need to understand the underlying hardware by reading manuals and data sheets to understand what is happening. The devil is in the details.

- In exercise 5 you learned how to use vendor provided SVD files in order to watch peripheral registers changing over time. This can be very useful when developing and debugging low-level code.
