use command_parser::{parse, parse_result};

fn parse_str(s: &str) {
    println!("\ninput        {}", s);
    let s = s.as_bytes();
    println!("parse        {:?}", parse(s));
    println!("parse_result {:?}", parse_result(s));
}

fn main() {
    parse_str("start");
    parse_str("freq");
    parse_str("freq 100");
    parse_str("freq x");
    parse_str("freq ");
    parse_str("freq    1000");
    parse_str("start  bogus");
}
