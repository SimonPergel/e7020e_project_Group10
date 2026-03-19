//! lib
//!
//! Showcase how you can test on host and later use on target

// no_std library except for test
#![cfg_attr(not(test), no_std)]

#[derive(Debug, PartialEq)]
pub enum Command<'a> {
    SetSecret(&'a [u8]),
    PrintSecret,
    Time(u64), // varible for Unix time
}

/// Parse a byte slice to an `Option<Command>`
/// None indicates an error
///
/// # Examples
/// ```
/// use command_parser::*;
/// assert_eq!(
///     parse(b"start some text that we don't care about"),
///     Some(Command::Start)
/// );
/// ```
/// ```
/// use command_parser::*;
/// assert_eq!(
///     parse(b"freq 1000 some text we don't care about"),
///     Some(Command::FrequencyHz(1000))
/// );
/// ```
pub fn parse(bytes: &[u8]) -> Option<Command<'_>> {
    let mut split = bytes.splitn(bytes.len(), |c| *c == b' ');
    let next = split.next()?;
    match next {
        b"setsecret" => {
            let next = split.next()?;
            Some(Command::SetSecret(next))
        }
        b"printsecret" => Some(Command::PrintSecret),
        b"time" => {
            let next = split.next()?;
            let str = core::str::from_utf8(next).ok()?;
            let t: u64 = str.parse().ok()?;
            Some(Command::Time(t))
        }
        _ => None,
    }
}

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

/// Parse a byte slice to an `Result<Command, Error>`
/// The Error type is locally defined indicating the error
///
/// # Examples
/// ```
/// use command_parser::*;
/// assert_eq!(
///     parse_result(b"start some text that we don't care about"),
///     Err(Error::ArgNumber)
/// );
/// ```
/// ```
/// use command_parser::*;
/// assert_eq!(
///     parse_result(b"freq    1000"),
///     Ok(Command::FrequencyHz(1000))
/// );
/// ```
pub fn parse_result(bytes: &[u8]) -> Result<Command<'_>, Error> {
    // let's work on &str instead of raw byte arrays
    let str = core::str::from_utf8(bytes).map_err(|_| Error::NonUtf8)?;
    let mut split = str.split_whitespace();
    let next = split.next().ok_or(Error::CommandNotFound)?;
    let result = match next {
        "setsecret" => {
            let next = split.next().ok_or(Error::ArgMissing)?;
            Ok(Command::SetSecret(next.as_bytes()))
        }
        "printsecret" => Ok(Command::PrintSecret),
        "time" => {
            // handle TIME command
            let next = split.next().ok_or(Error::ArgMissing)?;
            let t: u64 = next.parse().map_err(|_| Error::ArgError)?;
            Ok(Command::Time(t))
        }
        _ => Err(Error::CommandNotFound)?,
    };
    match split.next() {
        None => result,
        _ => Err(Error::ArgNumber),
    }
}

#[cfg(test)]
mod test_parse_result {
    use super::*;

    #[test]
    fn test_parse_result_not_found() {
        assert_eq!(
            parse_result(b"unrecognized some text that we don't care about"),
            Err(Error::CommandNotFound)
        );
    }

    #[test]
    fn test_parse_result_time_ok() {
        // The input is a valid command
        assert_eq!(
            parse_result(b"time 1710000000"),
            Ok(Command::Time(1710000000)) // return succesfull result
        );
    }
    #[test]
    fn test_parse_result_time_missing() {
        // The input command is missing
        assert_eq!(parse_result(b"time"), Err(Error::ArgMissing));
    }
    #[test]
    fn test_parse_result_time_invalid() {
        // The input is a invalid command
        assert_eq!(parse_result(b"time hej"), Err(Error::ArgError));
    }
}
