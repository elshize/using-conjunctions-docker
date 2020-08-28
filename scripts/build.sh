BIN="/work/pisa/build/bin"

set -x

BUILD_INDEX="$(dirname "$0")/build-index.sh"
# DONE: bash "$BUILD_INDEX" "$BIN" "$WORK" "$DATA" cw09b
# DONE: bash "$BUILD_INDEX" "$BIN" "$WORK" "$DATA" cw12b

# DONE: mkdir -p "$DATA/queries"
# DONE: cp "$INPUT/queries/cw09b.05.queries.jl" "$DATA/queries"
# DONE: cp "$INPUT/queries/cw09b.06.queries.jl" "$DATA/queries"
# DONE: cp "$INPUT/queries/cw12b.05.queries.jl" "$DATA/queries"
# DONE: cp "$INPUT/queries/cw12b.06.queries.jl" "$DATA/queries"

THRESHOLDS="$(dirname "$0")/thresholds.py"
function thresholds {
    coll=$1
    track=$2
    python3 "$THRESHOLDS" \
        -q "$DATA/queries/$coll.$track.queries" \
        --pairs "$INPUT/aol.clean.$coll.mapped.pairs" \
        --triples "$INPUT/aol.clean.$coll.mapped.triples" \
        --pisa-bin "$BIN" \
        -i "$WORK/$coll/$coll.url"
}

# DONE: thresholds "cw09b" "05"
# DONE: thresholds "cw09b" "06"
# DONE: thresholds "cw12b" "05"
# DONE: thresholds "cw12b" "06"

function pair_index {
    coll=$1
    run=$2
    quantized=$3
    base="$WORK/$coll/$coll.url"
    $BIN/build-pair-index \
        -i "$base$quantized.simdbp" \
        -e block_simdbp \
        --stemmer porter2 \
        --terms "$base.termlex" \
        -o "$base$quantized.$run.simdbp.query-pairs" \
        -q "$DATA/queries/$run$quantized.jl"
}

# DONE: pair_index "cw09b" "cw09b.05.queries.qk3" ""
# DONE: pair_index "cw09b" "cw09b.06.queries.qk3" ""
# DONE: pair_index "cw12b" "cw12b.05.queries.qk3" ""
# DONE: pair_index "cw12b" "cw12b.06.queries.qk3" ""
# DONE: pair_index "cw09b" "cw09b.05.queries.qk3" ".quantized"
# DONE: pair_index "cw09b" "cw09b.06.queries.qk3" ".quantized"
# DONE: pair_index "cw12b" "cw12b.05.queries.qk3" ".quantized"
# DONE: pair_index "cw12b" "cw12b.06.queries.qk3" ".quantized"

# DONE: pair_index "cw09b" "cw09b.05.queries.exact" ""
# DONE: pair_index "cw09b" "cw09b.06.queries.exact" ""
# DONE: pair_index "cw12b" "cw12b.05.queries.exact" ""
# DONE: pair_index "cw12b" "cw12b.06.queries.exact" ""
# DONE: pair_index "cw09b" "cw09b.05.queries.exact" ".quantized"
# DONE: pair_index "cw09b" "cw09b.06.queries.exact" ".quantized"
# DONE: pair_index "cw12b" "cw12b.05.queries.exact" ".quantized"
# DONE: pair_index "cw12b" "cw12b.06.queries.exact" ".quantized"
