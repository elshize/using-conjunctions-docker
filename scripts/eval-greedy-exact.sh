#!/bin/bash

INTERSECT_BIN="/home/michal/intersect/target/release"
WORK="/data/michal/work/inter"
DATA="/data/michal/experiments/intersection-queries"

#set -x
set -e

function selections {
    run=$1
    method=$2
    k=$3
    #jq -c 'select(.intersections|length < 17)' "$DATA/intersections/$run.jl" \
    jq -c 'select(.query.term_ids|length < 6)' "$DATA/intersections/$run.jl" \
        | $INTERSECT_BIN/intersect -k "$k" -m "$method" --scale 1.25 \
        | jq -c '.query.selections'
}

function eval_selections {
    coll=$1
    track=$2
    size=$3
    selections "$coll.$track.queries.exact${size}" "greedy" 1000 > /tmp/greedy
    selections "$coll.$track.queries.exact${size}" "exact" 1000 > /tmp/exact
    count=$(diff -y --suppress-common-lines /tmp/greedy /tmp/exact | wc -l)
    prec=$(echo "1 - ($count / 1000)" | bc -l)
    echo $prec
}

# eval_selections "cw09b" "05" ""
# eval_selections "cw09b" "06" ""
# eval_selections "cw09b" "05" ".15b"
# eval_selections "cw09b" "06" ".15b"
# eval_selections "cw12b" "05"
# eval_selections "cw12b" "06"

function selection_times {
    coll=$1
    track=$2
    size=$3
    ks=(10 100 1000 10000)
    for k in "${ks[@]}"; do
        output="$DATA/selections/$coll.$track$size.$k.times"
        cat "$DATA/intersections/$coll.$track.queries.exact${size}.jl" \
            | $INTERSECT_BIN/intersect -k "$k" -m "greedy" --scale 1.25 --time \
            | jq -c '.elapsed' > $output
        total=0
        sum=0
        for time in $(cat $output); do
            ((sum += time))
            ((total += 1))
        done
        echo "Avg selection time for $coll.$track$size.$k: $((sum/total))"
    done
}

selection_times "cw09b" "05" ""
selection_times "cw09b" "06" ""
selection_times "cw09b" "05" ".30b"
selection_times "cw09b" "06" ".30b"
selection_times "cw09b" "05" ".75b"
selection_times "cw09b" "06" ".75b"
selection_times "cw09b" "05" ".150b"
selection_times "cw09b" "06" ".150b"
selection_times "cw09b" "05" ".225b"
selection_times "cw09b" "06" ".225b"
selection_times "cw09b" "05" ".300b"
selection_times "cw09b" "06" ".300b"

selection_times "cw12b" "05" ""
selection_times "cw12b" "06" ""
selection_times "cw12b" "05" ".30b"
selection_times "cw12b" "06" ".30b"
selection_times "cw12b" "05" ".75b"
selection_times "cw12b" "06" ".75b"
selection_times "cw12b" "05" ".150b"
selection_times "cw12b" "06" ".150b"
selection_times "cw12b" "05" ".225b"
selection_times "cw12b" "06" ".225b"
selection_times "cw12b" "05" ".300b"
selection_times "cw12b" "06" ".300b"
