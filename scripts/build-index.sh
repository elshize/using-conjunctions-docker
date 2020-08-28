#!/bin/bash

set -e
set -x

BIN="$1" && shift
WORK="$1" && shift
DATA="$1" && shift
COLL="$1" && shift

# Define the index basename
BASE="$WORK/$COLL/$COLL.url"

# Build term lexicon
$BIN/lexicon build "$BASE.terms" "$BASE.termlex"

# Build document lexicon
$BIN/lexicon build "$BASE.documents" "$BASE.doclex"

# Create block-max index metadata.
$BIN/create_wand_data -c "$BASE" -o "$BASE.bm25.bmw" -s bm25 -b 128

# Create variable block-max index metadata.
$BIN/create_wand_data -c "$BASE" -o "$BASE.bm25.vbmw" -s bm25 -l 22.5

# Compress inverted index with SIMDBP-128 encoding.
$BIN/compress_inverted_index -c "$BASE" -o "$BASE.simdbp" -e block_simdbp \
    --check

# Create quantized block-max index metadata.
$BIN/create_wand_data -c "$BASE" -o "$BASE.bm25.quantized.bmw" -s bm25 -b 128 \
    --quantize

# Create quantized variable block-max index metadata.
$BIN/create_wand_data -c "$BASE" -o "$BASE.bm25.quantized.vbmw" -s bm25 -l 22.5 \
    --quantize

# Quantize and compress inverted index with SIMDBP-128 encoding.
$BIN/compress_inverted_index -c "$BASE" -o "$BASE.quantized.simdbp" \
    -w "$BASE.bm25.quantized.bmw" -s bm25 -e block_simdbp --quantize --check
