#!/bin/sh
# Files, including one with every byte value, through every format against Python, plus decode round trips.
ok=0; bad=0
for f in tests/data/bytes.bin tests/data/sample.txt; do
  for fmt in base64 base64url base32 hex url; do
    mine=$($LZ encode $fmt --file=$f)
    ref=$(python3 -c "
import sys; sys.path.insert(0, 'tools'); import reference as r
print(r.encode('$fmt', open('$f', 'rb').read()))")
    if [ "$mine" = "$ref" ]; then ok=$((ok+1)); else bad=$((bad+1)); echo "DIFFERENT: encode $fmt $f"; fi
    back=$($LZ decode $fmt "$mine" | od -An -v -tx1 | tr -d ' \n'); want=$(od -An -v -tx1 $f | tr -d ' \n')
    # decode prints a trailing newline, and text output cannot carry NUL: compare only for the text file
    if [ "$f" = "tests/data/sample.txt" ]; then
      [ "$back" = "${want}0a" ] && ok=$((ok+1)) || { bad=$((bad+1)); echo "DIFFERENT: round trip $fmt $f"; }
    fi
  done
done
echo "$ok checks identical to the reference, $bad different"
