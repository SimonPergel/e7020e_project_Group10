# rtic_bare8

What it covers:

- serial communication
- bad design
- good design

---

## Preparation

The nRF52840 DK provides an Interface MCU that you use for programming and debugging your code. In addition Interface MCU also provides a virtual serial port. Check section `3.2 Virtual serial port` in the [nRF52840DK](https://docs.nordicsemi.com/bundle/ug_nrf52840_dk/page/UG/dk/intro.html) how signals are connected to the target MCU. (We don't use flow control, thus `cts` and `rts` are left out.)

On a linux host, the VCP (Virtual Com port) is presented under `/dev/ttyACMx`, where
`x` is an enumerated number (if 0 is busy it will pick 1, etc.)

---

## Exercise 1

Run the example, either in vscode with the `probe-rs Debug` profile or from terminal, whatever you are more comfortable with:

``` rust
cargo run --example rtic_bare8
```

Start a terminal program, e.g., `cutecom`.

Connect to the port:

```text
    Device       /dev/ttyACM0
    Baude Rate   115200
    Data Bits    8
    Stop Bits    1
    Parity       None
```

This setting is typically abbreviated as 115200 8N1.

Send a single character (byte), Use the "Input" field to write data to send. You can choose how `return` should be sent in the dropdown right of the "Input" field. Set it to `None`.

Verify that sent bytes are echoed back, and that RTT tracing is working.

Try sending "a", don't send the quotation marks, just a.

What do you receive in `cutecom` (or the terminal program you use)?

[` It seems to be nothing`]

What do you receive in the RTT terminal?

[`Byte on serial0: 97`]

Try sending: "abcd" as a single sequence, don't send the quotation marks, just abcd.

What did you receive in `cutecom`?

[` I receive aabc`]

What do you receive in the RTT terminal?

```
Byte on serial0: 97
Byte on serial0: 98
Byte on serial0: 99
Byte on serial0: 100

```

What do you believe to be the problem?

Hint: Look at the code in the loop.
What could go wrong here...

[` As I have understood it is that if multiple bytes are arriving quickly, the program cant process them fast enough becasue it blocks in the loop. Also the RX buffer is only one byte making it possible for bytes to be dropped`]

Experiment a bit, what is the max length sequence you can receive without errors?

[`The max length that i found by experimenting a bit is n-1, where n is the number of bytes sent`]


Commit your answers (bare8_1)

---

## Exercise 2

Now look at the `rtic_bare8b` example. In this case we split the processing (and echo back) to a lower priority task `data_in`. 

We have set the `priority` for the interrupt to 2, while the `data_in` is set to the default priority 1.

The `data_in::spawn` gives enqueues a message containing the data. The size of the queue is determined by the `capacity` attribute.

Try sending: "abcd" as a single sequence, don't send the quotation marks, just abcd.

What did you receive in `cutecom` (host side terminal program)?

Notice, that the last character might still be buffered on the receiver (host side) but it will be flushed out on next package.

[`abc`]

What do you receive in the RTT terminal?

```
uarte0 interrupt
Byte on serial0: 97
error WouldBlock
uarte0 interrupt
Byte on serial0: 98
error WouldBlock
uarte0 interrupt
Byte on serial0: 99
error WouldBlock
uarte0 interrupt
Byte on serial0: 100
error WouldBlock
data_in 97
data_in 98
data_in 99
data_in 100
```

(If your application runs into a panic there is something wrong, go back and check.)

Now try to stress the size of data sent in a single transfer. Try "abcde", "abcdef", etc. until it breaks.

What was the max length?

[`The maximum number of characters that is not giving an error is 5, and when I sent "abcdef" it breaks`]

Explain in your own word why the error occurs.

[`As I have understood it is that the error occurs because the queue in the data_in function has a capacity of 5 bytes. So when the queue is full( 5 characters) and by calling the data_in function, it will panic  `]

Now fix the problem so that you can receive 10 characters without error.

Was it simple?

[`yes it was, just change the capacity to 10`]

Commit your solution (bare8_2)

---

## Exercise 3

Now look closer at the `data_in` task.

Uncomment the `*len += 1` to increase the `len` on each character received.

Rust is designed for safety. Repeatedly send the characters "abc" from `cutecom`.

What will eventually eventually happen?

[`Enentually I git an index out of bounds error`]

What do you think would happen in a corresponding C program?

[` In C there is no out of bounds checking when trying to write past the end of an array, this would lead to undefined behavior `]

Fix the problem such that `len` cannot exceed the length of the `data_arr`, e.g. as shown below (indexes start from 0 so we need to subtract 1 from the array length).

``` rust
   *len = usize::min(*len + 1, data_arr.len() - 1);
```

What happens now if you continuously spam the serial port from `cutecom`.

[`As it apears, the program no longer crashes. The buffer index is limited to the array length, which makes the program not to crash becasue it prevent out of bounds access.`]

This is how Rust holds your back, hard to find bugs are caught early in the design process allowing you to come up with robust, reliable and safe implementations.

Commit your solution (bare8_3)

---

## Exercise 4

Now set the handling of `return` to `CR` (name comes from carriage return from old type writers).

The code matches on the incoming `data` (`u8`), and checks for the `CR` (13) character. If matched the content of the `data_arr` seen as a slice between `[0..*len]` (i.e., the first `len` characters of the data array) is displayed (as both a byte array and as a Rust `str`). If not matched we put the data in the buffer and increase the `len` as discussed earlier.

So whenever a `CR` is received you may want to process the `data_arr` as a command by a parser.

In the given code, we parse the input `slice` (bytes) by `parser` and `parse_result`. 

Document your example:

``` shell
cargo doc --example rtic_bare8b --open
```

You can search for the `command_parser` and you will find the functions `parse` and `parse_result`. These functions are found in the `command_parser` crate (in the `command-parser` folder).

This is a separate library that can be tested under `std` (i.e., on your host without running the code on the target.)

You can `cd` to the `command-parser` folder and open a new `vscode` instance there to view the code. You can try:

``` shell
cargo run --example ex1
```

This simple example shows the results of running the `parse` and `parse_functions` on some example byte slices. The `parse_result` is slightly more complex but much better (as you can report back to the user what type of parse error/failure occurred).


The crate has its own `README.md`. You can open that and select `Open Preview` to get a nicely formatted view.

Now extend the parsers to handle `duty val` where val should be of type `u8`. 

In the `src/lib.rs` file you find the source code and unit tests. When you extend the parser with new functionality then add both success and fail tests. You can also add a to the documentation by an example showing expected behavior. 

``` shell
cargo test
```

Will run all test, including testing the examples in your documentation. (That's quite neat right, to have examples tested as well, that way you can make sure that the documentation is up to date with the implementation.)

Looking closer at the `lib.rs` file you find:

``` rust
#![cfg_attr(not(test), no_std)]
```

This means that when compiled for testing then it will be compiled for `std`, if not it will be compiled for `std`. (The host side test framework requires a `std` environment for testing your code.)

This allows the crate to be tested on your host (`std`), but used in a `no_std` build as well (like in this `bare8b` example).

When you have working parsers for the `duty` command tested on the host, then test that it works as intended running it on the target, check both the happy path (where you get a `Command::Duty<u8>`) and the less happy path (`None`/`Error`).

Commit your solution (bare8_4)

---

## Exercise 5

Now its time to do something with the parsed command.

In previous labs we have managed to get a led blinking in various ways. 

Create a new file `rtic_bare8c` and combine the serial communication with the monotonic time version of blinking led, such that you can change the duty cycle using the `duty <u8>` command. You might also want to echo back the status (the set duty cycle).

Check with the logic probe that the duty cycle works as intended (sample some periods to check the on/off time).

Commit your solution (bare8_5)

---

## Exercise 6

In this part, extend the functionality of `rtic_bare8c` to also support the `start`, `stop` and `frequency` commands.

Verify that the period and duty cycle is set correctly using the logic analyzer.

Commit your solution (bare8_6)

---

## Exercise 7 (Optional)

In this optional assignment repeat exercise 5/6 based on the `PWM` peripheral version of blinking led.

The `start`/`stop` commands are quite easy to implement, the frequency however is a bit more complex.

To set the frequency you need to take both prescaler and top value into account. Not all frequencies can be achieved so you will have to make an approximation. The frequency to prescaler and top value calculation can be factored out to an external library allowing you to develop, debug and test it more easily.

Once you have it working, validate by using the logic analyzer that frequency and duty cycle is working correctly. You should be able to get a PWM running at several MHz using the hardware peripheral.

Commit your solution (bare8_7)

---

## Learning Outcome

In this exercise you have learned how to:

- Communicate over serial
- Write a command parser including error handling
- Test the parser host-side
- Integrate the parser into a more complex application

In the first example we were using a loop a to poll the data. (If you ever used Arduino, you might feel at home with the `loop` and poll design.) However, this approach may yield loss of data and/or terrible performance. (With that said, Arduino gets away with some simple examples as their drivers do internal magic - buffering data etc. The underlying poll problem still remains and eventually leads to bugs that are hard to find and fix.)

In the second part we opted for an event (interrupt) driven *reactive* approach. Leveraging on the RTIC task/resource model we obtain loss free data transfer with excellent performance. It is easy to follow and reason on the flow of data and buffering is under Your control as a programmer (not hidden in some mysterious driver).

You are now mastering many of the common skills needed for developing applications in Rust RTIC, good job!
