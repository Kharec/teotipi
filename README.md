# teotipi

A Gleam CLI and library for generating TOTP codes (RFC 6238).

## Usage

```bash
gleam run -- <base32-secret>
```

**Example:**

```
$ gleam run -- JBSWY3DPEHPK3PXP
123456
```

The secret is your Base32-encoded TOTP key (the one you'd scan as a QR code in an authenticator app).

## Library API

```gleam
import teotipi

// Returns a zero-padded 6-digit string
teotipi.totp_string("JBSWY3DPEHPK3PXP")  // Ok("123456")

// Returns a raw integer
teotipi.totp("JBSWY3DPEHPK3PXP")          // Ok(123456)
```

Both functions return `Error(Nil)` if the secret is not valid Base32.

## How it works

Implements TOTP as defined in [RFC 6238](https://datatracker.ietf.org/doc/html/rfc6238):

1. Decode the Base32 secret
2. Compute the time counter (`unix_seconds / 30`)
3. Run HMAC-SHA1 over the 64-bit counter
4. Apply dynamic truncation to extract a 6-digit code

## Testing

```bash
gleam test
```

## License

MIT — see [LICENSE](LICENSE).
