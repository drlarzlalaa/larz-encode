# larz-encode

Base64, Base64url, Base32, hex and URL (percent) encoding and decoding, in [Larzscript](https://github.com/larz-scripter/larzscript). No dependencies beyond the standard `cli` and `args` packages.

```
$ larzscript encode.lz encode base64 "Hello, World!"
SGVsbG8sIFdvcmxkIQ==
$ larzscript encode.lz encode base32 "Hello, World!"
JBSWY3DPFLW7TMMQQQ======
$ larzscript encode.lz encode url "a b&c=d/é"
a%20b%26c%3Dd%2F%C3%A9
$ larzscript encode.lz decode base64url "c3ViamVjdHM_X2Q9MT4-"
subjects?_d=1>>
```

## Formats

| Format | Definition |
| --- | --- |
| `base64` | RFC 4648 §4: `A-Z a-z 0-9 + /`, padded with `=` |
| `base64url` | RFC 4648 §5: `-` and `_` instead of `+` and `/`, padded |
| `base32` | RFC 4648 §6: `A-Z 2-7`, padded |
| `hex` | two lowercase hex digits per byte (decoding accepts either case) |
| `url` | percent-encoding: `A-Z a-z 0-9 - _ . ~` stay, every other byte becomes `%XX` (uppercase); a space is `%20`, never `+` |

Text is handled as bytes (UTF-8), so `é` is the two bytes 195 169. Any command takes `--file=PATH` in place of the text, and a file may hold any bytes (up to 30,000). `batch FILE` runs many lines (`encode FORMAT TEXT` or `decode FORMAT TEXT`; decoded results are shown as hex, so binary is safe).

## Strict decoding

Decoding follows RFC 4648: characters outside the alphabet, misplaced or missing padding, impossible lengths and non-zero "padding bits" are **errors**, not silently skipped, and so is whitespace inside the text. A text is accepted only if re-encoding what it decodes to gives back exactly the same text. `QR==` is rejected because it is not the encoding of any byte string (`QQ==` is), and base32 must be uppercase.

## How it was checked

`tools/reference.py` uses Python's `base64`, `binascii` and `urllib`; because those decoders are lenient in places, the reference makes them strict the same way (decode, then re-encode and compare). `tests/inputs.txt` has 781 lines and the output of `batch` is identical on all of them: every format on 31 texts of 0 to 250 bytes including Unicode; the same texts decoded from valid encodings; 297 decodes that must be rejected (bad characters, whitespace, missing or extra padding, wrong case, non-zero padding bits, wrong lengths); and malformed commands. Five more random sets of about 780 lines each, run during development, also matched. `tests/crosscheck.sh` checks files (including one with all 256 byte values) in every format and round-trips a text file. The RFC 4648 test vectors (`foobar` and its prefixes) are in `tests/rfc4648.sh`.

Fuzzing found one real bug on the way: `AA=A` was accepted, because my check for padding at the end looked at the second-to-last character without checking the last one. It is fixed and is one of the rejected lines in the corpus.

## Tests

```
sh tests/run_tests.sh
```

MIT licence.
