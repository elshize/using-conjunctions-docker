BIN="/work/pisa/build/bin"

set -x

BUILD_INDEX="$(dirname "$0")/build-index.sh"
# bash "$BUILD_INDEX" "$BIN" "$WORK" "$DATA" cw09b
# bash "$BUILD_INDEX" "$BIN" "$WORK" "$DATA" cw12b

mkdir -p "$DATA/queries"
# cp "/queries/cw09b.05.queries.jl" "$DATA/queries"
# cp "/queries/cw09b.06.queries.jl" "$DATA/queries"
# cp "/queries/cw12b.05.queries.jl" "$DATA/queries"
# cp "/queries/cw12b.06.queries.jl" "$DATA/queries"

# TODO
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

# thresholds "cw09b" "05"
# thresholds "cw09b" "06"
# thresholds "cw12b" "05"
# thresholds "cw12b" "06"

function pair_index {
    coll=$1
    quantized=$2
    base="$WORK/$coll/$coll.url"
    cat $DATA/queries/$coll.0*.queries.jl | $BIN/build-pair-index \
        -i "$base$quantized.simdbp" \
        -e block_simdbp \
        --stemmer porter2 \
        --terms "$base.termlex" \
        -o "$base$quantized.all.simdbp.query-pairs"
}

# pair_index "cw09b" ""
# pair_index "cw09b" ".quantized"
pair_index "cw12b" ""
pair_index "cw12b" ".quantized"
