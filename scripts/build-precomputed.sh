BIN="/work/pisa/build/bin"

set -x

function pair_index {
    coll=$1
    size=$2
    quantized=$3
    base="$WORK/$coll/$coll.url"
    $BIN/build-pair-index \
        -i "$base$quantized.simdbp" \
        -e block_simdbp \
        --stemmer porter2 \
        --terms "$base.termlex" \
        -o "$base$quantized.$size.simdbp.query-pairs" \
        -q "$INPUT/train/aol-$coll-train-top-$size.jl"
}

pair_index "cw09b" "30b" ""
pair_index "cw09b" "75b" ""
pair_index "cw09b" "150b" ""
pair_index "cw09b" "225b" ""
pair_index "cw09b" "30b" ".quantized"
pair_index "cw09b" "75b" ".quantized"
pair_index "cw09b" "150b" ".quantized"
pair_index "cw09b" "225b" ".quantized"

pair_index "cw12b" "30b" ""
pair_index "cw12b" "75b" ""
pair_index "cw12b" "150b" ""
pair_index "cw12b" "30b" ".quantized"
pair_index "cw12b" "75b" ".quantized"
pair_index "cw12b" "150b" ".quantized"

# temporary workaround for an undentified crash
function pair_index_cw12b_225b {
    coll="cw12b"
    size="225b"
    quantized=$1
    base="$WORK/$coll/$coll.url"
    $BIN/build-pair-index \
        -i "$base$quantized.simdbp" \
        -e block_simdbp \
        --stemmer porter2 \
        --terms "$base.termlex" \
        -o "$base$quantized.$size.simdbp.query-pairs" \
        -q "$INPUT/train/aol-cw12b-intersection.jl"
}

pair_index_cw12b_225b ""
pair_index_cw12b_225b ".quantized"

# temporary workaround for an undentified crash
function pair_index_cw09b_300b {
    coll="cw09b"
    size="300b"
    quantized=$1
    base="$WORK/$coll/$coll.url"
    $BIN/build-pair-index \
        -i "$base$quantized.simdbp" \
        -e block_simdbp \
        --stemmer porter2 \
        --terms "$base.termlex" \
        -o "$base$quantized.$size.simdbp.query-pairs" \
        -q "$INPUT/train/cw09b.05-06.300b.jl"
}

pair_index_cw09b_300b ""
pair_index_cw09b_300b ".quantized"

# temporary workaround for an undentified crash
function pair_index_cw12b_300b {
    coll="cw12b"
    size="300b"
    quantized=$1
    base="$WORK/$coll/$coll.url"
    $BIN/build-pair-index \
        -i "$base$quantized.simdbp" \
        -e block_simdbp \
        --stemmer porter2 \
        --terms "$base.termlex" \
        -o "$base$quantized.$size.simdbp.query-pairs" \
        -q "$INPUT/train/cw12b.05-06.300b.jl"
}

pair_index_cw12b_300b ""
pair_index_cw12b_300b ".quantized"
