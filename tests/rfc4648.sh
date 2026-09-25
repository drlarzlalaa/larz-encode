#!/bin/sh
# The test vectors of RFC 4648 section 10 (the empty string, f, fo, foo, foob, fooba, foobar) in base64, base32 and hex.
for t in "" f fo foo foob fooba foobar; do
  echo "[$t] $($LZ encode base64 "$t") $($LZ encode base32 "$t") $($LZ encode hex "$t")"
done
for t in "" Zg== Zm8= Zm9v Zm9vYg== Zm9vYmE= Zm9vYmFy; do echo "base64 [$t] -> [$($LZ decode base64 "$t")]"; done
for t in "" MY====== MZXQ==== MZXW6=== MZXW6YQ= MZXW6YTB MZXW6YTBOI======; do echo "base32 [$t] -> [$($LZ decode base32 "$t")]"; done
