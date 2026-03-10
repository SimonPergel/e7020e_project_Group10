# command-parser

A simple command line parse with `#[no_std]` support.

The `parse` function takes a `&[u8]` (byte slices) as input and returns an `Option<Command>`, either `None` (on failure) or `Some(Command)` on success.

The `parse_result` function is similar, it takes a `&[u8]` but internally turns this into an `&str` (the Rust utf8 string slice representation). It is not a fully fledged `String` (it is not dynamically sized, that would need an `std` allocator).

It returns a `Result<Command, Error>` where `Error` is a locally defined error type.

``` rust
/// Error type for parse_result
#[derive(Debug, PartialEq)]
pub enum Error {
    /// Input not Utf8 conformant
    NonUtf8,
    /// Command Missing or Illegal
    CommandNotFound,
    /// Argument missing
    ArgMissing,
    /// Parsing error for the argument
    ArgError,
    /// Nr Arguments wrong
    ArgNumber,
}
```

As seen there are many different errors here:

- `NonUtf8` indicates that it was not possible to convert into a Rust `&str` (e.g., the input data was corrupted)
- `CommandNotFound` indicates that the first argument was not matched to a known command.
- `ArgMissing` indicates that we experted an argument, but was not provided one.
- `ArgError` indicates that the we could not parse the input argument (e.g., an illegal number).
- `ArgNumber` indicates that input contained excess arguments (too many arguments).

The implementation is not complete so you need to add more functionality. Feel free to edit/add error types, it is just a quick and dirty hack to show how it might look.

The example also show that you can develop/debug the code on your host machine and add tests.

There are unit tests for both the `parse` and `parse_result`.

To run the tests on the host:

``` shell
cargo test
```

There is also an executable example:

``` shell
cargo run --example ex1
```

When you add more functionality, make sure to add both unit tests and extend the example (or create new examples) to cover for the extended functionality. It is in general much easier to develop, debug and test code on the host. (You can easily setup a CI that automatically tests your code on the git server).
