#!/bin/sh
$LZ encode
$LZ encode rot13 abc
$LZ decode base64 "abc"
$LZ decode base64 "ab!d"
$LZ decode base64 "AA=A"
$LZ decode base64 "QR=="
$LZ decode base64 "AAAA AAAA"
$LZ decode base64url "ab+/"
$LZ decode base32 "mzxq===="
$LZ decode base32 "MFRB===="
$LZ decode hex "4"
$LZ decode hex "4g"
$LZ decode url "%4"
$LZ decode url "%zz"
$LZ encode base64 --file=/no/such/file
$LZ batch /no/such/file
head -c 30001 /dev/zero > /tmp/larz-enc-big.$$; $LZ encode hex --file=/tmp/larz-enc-big.$$; rm -f /tmp/larz-enc-big.$$
