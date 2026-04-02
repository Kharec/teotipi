import argv
import gleam/bit_array
import gleam/crypto
import gleam/int
import gleam/io
import gleam/result
import gleam/string
import gleam/time/timestamp
import thirtytwo

pub fn main() {
  case argv.load().arguments {
    [secret, ..] ->
      case totp_string(secret) {
        Ok(code) -> io.println(code)
        Error(_) -> io.println("Error: invalid secret")
      }
    [] -> io.println("Usage: teotipi <base32-secret>")
  }
}

pub fn totp_string(secret_b32: String) -> Result(String, Nil) {
  use code <- result.map(totp(secret_b32))
  code |> int.to_string |> string.pad_start(6, "0")
}

pub fn totp(secret_b32: String) -> Result(Int, Nil) {
  use secret <- result.try(thirtytwo.decode(secret_b32))
  let now = timestamp.system_time()
  let #(seconds, _nanoseconds) = timestamp.to_unix_seconds_and_nanoseconds(now)
  let counter = seconds / 30

  let counter_bits = <<counter:big-int-size(64)>>
  let mac = crypto.hmac(counter_bits, crypto.Sha1, secret)

  Ok(truncate(mac))
}

fn truncate(mac: BitArray) -> Int {
  let assert <<_:bytes-size(19), last:int>> = mac
  let offset = int.bitwise_and(last, 0x0f)
  let assert Ok(slice) = bit_array.slice(mac, offset, 4)
  let assert <<b0:int, b1:int, b2:int, b3:int>> = slice
  let code =
    int.bitwise_and(b0, 0x7f)
    |> int.bitwise_shift_left(24)
    |> int.bitwise_or(int.bitwise_shift_left(b1, 16))
    |> int.bitwise_or(int.bitwise_shift_left(b2, 8))
    |> int.bitwise_or(b3)
  code % 1_000_000
}
