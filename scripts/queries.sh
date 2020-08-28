BIN="$WORK/pisa/build/bin"
INTERSECT_BIN="$WORK/intersect/target/release"

set -x
mkdir -p "$DATA/benchmark"
mkdir -p "$DATA/inspect"
mkdir -p "$DATA/evaluate"
mkdir -p "$DATA/intersections"
mkdir -p "$DATA/selections"

function selections {
    coll=$1
    run=$2
    base="$WORK/$coll/$coll.url"
    python3 /scripts/selection.py \
        -k 10 100 1000 10000 \
        -r "$run" \
        --queries-dir "$DATA/queries" \
        --selections-dir "$DATA/selections" \
        --scaling 1.0 1.25 1.5 1.75 2.0 \
        --pisa-bin "$BIN" \
        --intersect-bin "$INTERSECT_BIN" \
        --index-basename "$base" \
        --fwd "$base" \
        --output-dir "$DATA"
}

selections "cw09b" "cw09b.05.queries.qk3"
selections "cw09b" "cw09b.06.queries.qk3"
selections "cw12b" "cw12b.05.queries.qk3"
selections "cw12b" "cw12b.06.queries.qk3"

selections "cw09b" "cw09b.05.queries.exact"
selections "cw09b" "cw09b.06.queries.exact"
selections "cw12b" "cw12b.05.queries.exact"
selections "cw12b" "cw12b.06.queries.exact"

function queries {
    coll=$1
    run=$2
    base="$WORK/$coll/$coll.url"
    python3 /scripts/query.py \
        -k 10 \
        -r "$run" \
        --queries-dir "$DATA/queries" \
        --selections-dir "$DATA/selections" \
        --selections all.greedy.s1.0 all.greedy.s1.25 all.greedy.s1.5 \
                     all.greedy.s1.75 all.greedy.s2.0 \
        --pisa-bin "$BIN" \
        --index-basename "$base" \
        --fwd "$base" \
        --output-dir "$DATA" \
        --only-intersection-queries
}

queries "cw09b" "cw09b.05.queries.qk3"
queries "cw09b" "cw09b.06.queries.qk3"
queries "cw12b" "cw12b.05.queries.qk3"
queries "cw12b" "cw12b.06.queries.qk3"

queries "cw09b" "cw09b.05.queries.exact"
queries "cw09b" "cw09b.06.queries.exact"
queries "cw12b" "cw12b.05.queries.exact"
queries "cw12b" "cw12b.06.queries.exact"
