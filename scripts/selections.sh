#!/bin/bash

BIN="/work/pisa/build/bin"

set -x
set -e

DATA="/data"

mkdir -p "$DATA/selections"

function select_intersections {
    coll=$1
    track=$2
    size=$3
    method=$4
    k=$5
    jq 'select(.term_ids|length < 6)' -c "$DATA/queries/$coll.$track.queries.hybrid.jl" \
        | $BIN/selections \
            -i $WORK/$coll/$coll.url.simdbp \
            -w $WORK/$coll/$coll.url.bm25.vbmw \
            -e block_simdbp \
            -k "$k" \
            --terms $WORK/$coll/$coll.url.termlex \
            --stemmer porter2 \
            --pair-index $WORK/$coll/$coll.url${size}.simdbp.query-pairs \
            --scale 1.25 --disk-resident-pairs \
            $method
}

function select_intersections_for_all_queries {
    coll=$1
    track=$2
    size=$3
    method=$4
    k=$5
    cat "$DATA/queries/$coll.$track.queries.hybrid.jl" \
        | $BIN/selections \
            -i $WORK/$coll/$coll.url.simdbp \
            -w $WORK/$coll/$coll.url.bm25.vbmw \
            -e block_simdbp \
            -k "$k" \
            --terms $WORK/$coll/$coll.url.termlex \
            --stemmer porter2 \
            --pair-index $WORK/$coll/$coll.url${size}.simdbp.query-pairs \
            --scale 1.25 --disk-resident-pairs \
            $method
}

function eval_selections {
    coll=$1
    track=$2
    size=$3
    ks=(10 100 1000 10000)
    for k in "${ks[@]}"; do
        brute="$DATA/selections/brute-force.$coll.$track-short$size.$k.jl"
        greedy="$DATA/selections/greedy.$coll.$track-short$size.$k.jl"
        select_intersections "$coll" "$track" "$size" "--brute-force" "$k" > "$brute"
        select_intersections "$coll" "$track" "$size" "" "$k" > "$greedy"
        select_intersections_for_all_queries "$coll" "$track" "$size" "" "$k" \
            > "$DATA/selections/greedy.$coll.$track$size.$k.jl"
    done
}

eval_selections "cw09b" "05" ".all"
eval_selections "cw09b" "06" ".all"
eval_selections "cw09b" "05" ".30b"
eval_selections "cw09b" "06" ".30b"
eval_selections "cw09b" "05" ".75b"
eval_selections "cw09b" "06" ".75b"
eval_selections "cw09b" "05" ".150b"
eval_selections "cw09b" "06" ".150b"
eval_selections "cw09b" "05" ".225b"
eval_selections "cw09b" "06" ".225b"
eval_selections "cw09b" "05" ".300b"
eval_selections "cw09b" "06" ".300b"

eval_selections "cw12b" "05" ".all"
eval_selections "cw12b" "06" ".all"
eval_selections "cw12b" "05" ".30b"
eval_selections "cw12b" "06" ".30b"
eval_selections "cw12b" "05" ".75b"
eval_selections "cw12b" "06" ".75b"
eval_selections "cw12b" "05" ".150b"
eval_selections "cw12b" "06" ".150b"
eval_selections "cw12b" "05" ".225b"
eval_selections "cw12b" "06" ".225b"
eval_selections "cw12b" "05" ".300b"
eval_selections "cw12b" "06" ".300b"
