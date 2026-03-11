# rtic_bare5

What it covers:

- abstractions in Rust
- `struct` and `impl`
- bitwise operations

---

## Background

In `rtic_bare4` we accessed the GPIO peripheral using unsafe code (the `read_u32/write_u32` took any arbitrary address as argument) so correctness was up to the programmer.

Rust allows allows us to build (zero-cost) abstractions, where the expert (i.e., You) can handle the dangerous parts and provide a fail safe API to the users of your libraries.

In this exercise we have model register access through `VolatileCell<T>`, which uses unsafe volatile read/write operations. `T` here can be any type that implements `Copy` (e.g., our primitive types, u8/u32, etc.).

We use `VolatileCell` to model the `GPIO`, in effect `GPIO_P0/P1` can be seen as _overlaying_ the hardware GPIO ports P0/P1 using the `GPIO` struct.

In this example we construct the peripheral abstraction by hand. Tools like [svd2rust](https://github.com/rust-embedded/svd2rust) automatically constructs Peripheral Access Crates (PACs) from vendor's hardware descriptions (SVD files), but the principle is similar.

For simplicity the modules `raw_access` and `nrf52840` are in this example part of the user application. Normally you would factor out these in a library (for you and others to re-use).

Commit your answer (bare5_1)

---

## Exercise 1

First run the example just to confirm that you got the led blinking.

Did you enjoy the blinking?

[Its lovely!]

Inspecting the user code `app`, you will find that only a single line using unsafe code.

Explain in your own words why `get` requires `unsafe`.

Hint: It is marked `unsafe` for a reason (confer to the Rust aliasing rules).

[The reason is that "get" returns a raw pointer to a fixed memory address that is outside the safe boundries of Rust, in other words it represent the memory-mapped hardware peripheral. This mean that Rust can not guarantee that the pointer is valid etc. So by calling "get" we promies the compiler that we will use the pointer correctly. ]

`{:p}` allows you to print an address in a nicely formatted way. What is the address printed for `gpio_p0.PIN_CNF[13]`?

```
address PIN_CNF[13]: 0x50000734
```

Check in the product specification [nRF52840_PS_v1.7](https://infocenter.nordicsemi.com/pdf/nRF52840_PS_v1.7.pdf) section 6.9.2 what this address represents. (No surprises there right:)

We see that `get` returns a raw pointer to this `GPIO` struct with the address computed as follows:

```rust
impl GPIO_P0 {
   pub fn get() -> *mut GPIO {
      (0x5000_0000 + 0x504) as *mut GPIO
   }
}
```

Now look at the `GPIO` struct definition. It is marked with the attribute:

```rust
 #[repr(C)]
```

This forbids Rust to do any smart padding/alignment and reordering of fields (what you C is what you get). This allows us to _overlay_ a structure on-top of the underlying HW. Explain in your own words the purpose of `_PAD1` in the `GPIO` struct and why it is not declared as `pub`.

[The purpose of `_PAD1` is to match the the structure layout in the sw part to the acctual layout of the hardware register layout, alignment purposes. This is done by padding in bytes. This `_PAD1` is not made public because the user should not have access to it and by making it private, we can prevent miss aligment violations for important addresses that comes after the padded memory bytes. ]

Explain in your own words why `[u8; 0x700-0x528]` gives us the right address for the following `PIN_CFN`.

[When looking at the datasheet we can see that the `DETECTMODE` register is ending at `0x528`, or up to not including `0x528`. The `PIN_CNF` registers starts at `0x700`. So we want to fill the memory inbetween them, so that we align the memory locations accoringly to the layout of the hardware memory. ]

Explain in your own words how `PIN_CNF[13]` gives us the right address for accessing pin configuration register 13. (You may look at `rtic_bare4.rs` to compare how the address was computed in a more primitive manner.)

[The basic ide is that `#[repr(C)]` guarantees the struct layout follows the hardware register layout exactly. The padding of bytes (`_PAD1`) aligns and basically makes shore that `PIN_CNF` starts at the right offset. But `PIN_CNF`is acctuallay an array with 32 volatileCells, where each elemnt represent one pin config. register and Rust can then performe correct pointer arithmics (because each element is 4 bytes wide) to reach the hardware register for pin 13.]

Commit your answer (bare5_1)

---

## Exercise 2

Hardware registers are typically divided into (bit) fields. It is quite common that you want to operate on a certain field. This can be accomplished by first reading the register, operate on the read value (and/or) to set the bits of interest, and finally write the result back to the register.

Doing it so manually is error prone, and we would like a "fail safe" way of doing this. Let us extend the API of `VolatileCell` to allow for _modifying_ fields of an underlying `u32` register.

`modify` takes 4 parameters:

- `&mut self`,
- `offset: u8`, the field offset in bits,
- `width: u8`, the field to width in bits, and
- `value: u32`, the value of the field.

E.g., a call:

```rust
t.modify(5, 3, 0b1110101);
```

Implies that bits 7,6,5 of `t` should be updated to hold `101` (the three lowest bits of the `value` passed). Other bits of the `value` argument should be ignored. Other bits in `t` should remain their value.

_Alternatively_, values ranging outside of width of the field to update could be considered illegal. In this case the above `modify` call would result in a `panic`. If you choose to implement this alternative API you need to change the provided test accordingly.

A skeleton implementation of `modify` is provided:

```rust
impl VolatileCell<u32> {
   #[inline(always)]
   pub fn modify(&mut self, offset: u8, width: u8, value: u32) {
      let r = self.read();
      rprintln!("r = {:b}", r);

      rprintln!("value = {:b}", value);
      let or_mask = 0; // replace with your own code
      rprintln!("or_mask {:b}", or_mask);
      let and_mask = 0; // replace with your own code
      rprintln!("and_mask {:b}", and_mask);

      let new_value = (r & and_mask) | or_mask;

      self.write(new_value);
   }
}
```

Add your own code for setting the `or_mask` and the `and_mask` (instead of the 0).

```
impl VolatileCell<u32> {
        #[inline(always)]
        pub fn modify(&mut self, offset: u8, width: u8, value: u32) {
            let r = self.read();                // read the current register value
            rprintln!("r = {:b}", r);

            rprintln!("value = {:b}", value);

            let field_mask = (1u32 << width) - 1;           // create a mask for the fild width
            let or_mask = (value & field_mask) << offset;   // extract the bits we are intrested in
            rprintln!("or_mask {:b}", or_mask);


            let and_mask = !(field_mask << offset);         // shift the mask and invert
            rprintln!("and_mask {:b}", and_mask);

            let new_value = (r & and_mask) | or_mask;
            rprintln!("new value {:b}", new_value);

            self.write(new_value);
        }
    }

```

To test that your implementation works as expected uncomment line `D`, in `idle`:

```rust
raw_access::test_modify(); // D
```

You should leave the tracing printouts for review purpose (a realistic implementation would of course omit the tracing the intermediate masks).

```
r = 0
value = 1110101
or_mask 10101000
and_mask 11111111111111111111111100000111
new value 10101000
r = 10101000
value = 10001
or_mask 10000
and_mask 11111111111111111111111110001111
new value 10011000

```

Commit your answer (bare5_2)

--Notice--

As with arithmetic operations, default semantics differ in between debug/dev and release builds. In debug << rhs is checked, rhs must be less than 32 (for 32 bit datatypes).

Over-shifting (where bits are spilled) is always considered legal, it is just the shift amount that is checked.

There are explicit unchecked versions available if so wanted.

---

## Learning Outcomes

- How to _overlay_ underlying memory mapped I/O by Rust data structures.
- The use of abstractions to reduce the need for `unsafe` user code.
- How to implement your own _"fail safe"_ API for low-level bit masking.

The Rust embedded echo system relies on the principles you have learned here.

The `cortex-m` crate for ARM Cortex-M peripherals, vendor specific Peripheral Access Crates (PACs), and Hardware Abstraction Layers (HALs), to name a few.

In the next set of labs you will learn how to make use of existing libraries, allowing us to go from zero to embedded hero in just 10 weeks!!!!
