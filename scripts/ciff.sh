#!/bin/bash

# This script takes indexes in the CIFF format (https://github.com/osirrc/ciff)
# and builds a PISA-compatible binary (uncompressed) index.
#
# First, the script will look in the $INPUT and $OUTPUT directories for the .ciff files.
# If they are not found, it will fall back to downloading them.
# This way, you can run it multiple times without spurious downloads,
# or provide your own CIFF index.

set -xe

CW09B_URL="https://drive.google.com/file/d/1-VOF7e3-CO9ZmMSOQgt4dqE3YlbS9H9T/view?usp=sharing"
CW12B_URL="https://drive.google.com/file/d/1nSnvcv_UTIPvk6NILPWMJlChd5WEphcw/view?usp=sharing"

CW09b_INPUT="$INPUT/CW09B.url.ciff"
CW12b_INPUT="$INPUT/CW12B.url.ciff"

mkdir -p $WORK/cw09b
mkdir -p $WORK/cw12b

if ! [ -f "$CW09b_INPUT" ]; then
    CW09b_INPUT="$OUTPUT/CW09B.url.ciff"
fi
if ! [ -f "$CW12b_INPUT" ]; then
    CW12b_INPUT="$OUTPUT/CW12B.url.ciff"
fi

if ! [ -f "$CW09b_INPUT" ]; then
    curl "$CW09B_URL" -o "$CW09b_INPUT"
fi
if ! [ -f "$CW12b_INPUT" ]; then
    curl "$CW12B_URL" -o "$CW12b_INPUT"
fi

ciff2pisa -c "$CW09b_INPUT" -o $WORK/cw09b/cw09b.url
ciff2pisa -c "$CW12b_INPUT" -o $WORK/cw12b/cw12b.url
