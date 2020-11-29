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
        -q "/pairs/aol-$coll-train-top-$size.jl"
}

# pair_index "cw09b" "30b" ""
# pair_index "cw09b" "75b" ""
# pair_index "cw09b" "150b" ""
# pair_index "cw09b" "225b" ""
# pair_index "cw09b" "30b" ".quantized"
# pair_index "cw09b" "75b" ".quantized"
# pair_index "cw09b" "150b" ".quantized"
# pair_index "cw09b" "225b" ".quantized"

# pair_index "cw12b" "30b" ""
# pair_index "cw12b" "75b" ""
# pair_index "cw12b" "150b" ""
# pair_index "cw12b" "30b" ".quantized"
# pair_index "cw12b" "75b" ".quantized"
# pair_index "cw12b" "150b" ".quantized"

function pair_index_small {
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
        -q "$INPUT/train/$coll.05-06.$size.jl"
}

# pair_index_small "cw09b" "30b" ""
# pair_index_small "cw09b" "75b" ""
# pair_index_small "cw09b" "150b" ""
# pair_index_small "cw09b" "225b" ""
# pair_index_small "cw09b" "300b" ""
# pair_index_small "cw09b" "750b" ""
# pair_index_small "cw09b" "30b" ".quantized"
# pair_index_small "cw09b" "75b" ".quantized"
# pair_index_small "cw09b" "150b" ".quantized"
# pair_index_small "cw09b" "225b" ".quantized"
# pair_index_small "cw09b" "300b" ".quantized"
# pair_index_small "cw09b" "750b" ".quantized"

# pair_index_small "cw12b" "30b" ""
# pair_index_small "cw12b" "75b" ""
# pair_index_small "cw12b" "150b" ""
# pair_index_small "cw12b" "225b" ""
# pair_index_small "cw12b" "300b" ""
# pair_index_small "cw12b" "750b" ""
# pair_index_small "cw12b" "30b" ".quantized"
# pair_index_small "cw12b" "75b" ".quantized"
# pair_index_small "cw12b" "150b" ".quantized"
# pair_index_small "cw12b" "225b" ".quantized"
# pair_index_small "cw12b" "300b" ".quantized"
# pair_index_small "cw12b" "750b" ".quantized"
