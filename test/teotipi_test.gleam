import gleam/string
import gleeunit
import gleeunit/should
import teotipi

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn totp_string_test() {
  "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ"
  |> teotipi.totp_string
  |> should.be_ok
  |> string.length
  |> should.equal(6)
}

pub fn totp_string_padding_test() {
  "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ"
  |> teotipi.totp_string
  |> should.be_ok
}

pub fn totp_string_invalid_secret_test() {
  teotipi.totp_string("INVALID!!!")
  |> should.be_error
}

pub fn totp_function_test() {
  let code =
    "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ"
    |> teotipi.totp
    |> should.be_ok

  should.be_true(code > 0)
  should.be_true(code < 1_000_000)
}

pub fn totp_invalid_secret_test() {
  teotipi.totp("INVALID!!!")
  |> should.be_error
}

pub fn totp_consistency_test() {
  let secret = "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ"
  let result1 = teotipi.totp(secret)
  let result2 = teotipi.totp(secret)

  should.equal(result1, result2)
}

pub fn totp_different_secrets_test() {
  let code1 =
    "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ"
    |> teotipi.totp
    |> should.be_ok

  let code2 =
    "JBSWY3DPEHPK3PXPJBSWY3DPEHPK3PXP"
    |> teotipi.totp
    |> should.be_ok

  should.be_true(code1 > 0)
  should.be_true(code2 > 0)
}
