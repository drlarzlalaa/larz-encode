#!/bin/sh
# 781 lines: every format on 31 texts of 0 to 250 bytes (with Unicode), the same texts decoded from valid encodings, decodes of
# deliberately broken text (bad characters, whitespace, missing or extra padding, wrong case, nonzero padding bits), and
# malformed commands. tools/reference.py batch prints identical lines using base64, binascii and urllib.
$LZ batch tests/inputs.txt
