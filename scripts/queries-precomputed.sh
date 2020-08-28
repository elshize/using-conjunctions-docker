BIN="/work/pisa/build/bin"
INTERSECT_BIN="/work/intersect/target/release"

set -x
set -e

function selections {
    coll=$1
    run=$2
    size=$3
    base="$WORK/$coll/$coll.url"
    python3 /scripts/selection.py \
        -k 10 100 1000 10000 \
        -r "$run" \
        --queries-dir "$DATA/queries" \
        --selections-dir "$DATA/selections" \
        --scaling 1.25 \
        --pisa-bin "$BIN" \
        --intersect-bin "$INTERSECT_BIN" \
        --index-basename "$base" \
        --fwd "$base" \
        --output-dir "$DATA" \
        --existing-pairs \
        --use-pairs "$size"
}

selections "cw09b" "cw09b.05.queries.qk3" "30b"
selections "cw09b" "cw09b.06.queries.qk3" "30b"
selections "cw09b" "cw09b.05.queries.qk3" "75b"
selections "cw09b" "cw09b.06.queries.qk3" "75b"
selections "cw09b" "cw09b.05.queries.qk3" "150b"
selections "cw09b" "cw09b.06.queries.qk3" "150b"
selections "cw09b" "cw09b.05.queries.qk3" "225b"
selections "cw09b" "cw09b.06.queries.qk3" "225b"
selections "cw09b" "cw09b.05.queries.qk3" "300b"
selections "cw09b" "cw09b.06.queries.qk3" "300b"

selections "cw12b" "cw12b.05.queries.qk3" "30b"
selections "cw12b" "cw12b.06.queries.qk3" "30b"
selections "cw12b" "cw12b.05.queries.qk3" "75b"
selections "cw12b" "cw12b.06.queries.qk3" "75b"
selections "cw12b" "cw12b.05.queries.qk3" "150b"
selections "cw12b" "cw12b.06.queries.qk3" "150b"
selections "cw12b" "cw12b.05.queries.qk3" "225b"
selections "cw12b" "cw12b.06.queries.qk3" "225b"
selections "cw12b" "cw12b.05.queries.qk3" "300b"
selections "cw12b" "cw12b.06.queries.qk3" "300b"

selections "cw09b" "cw09b.05.queries.exact" "30b"
selections "cw09b" "cw09b.06.queries.exact" "30b"
selections "cw09b" "cw09b.05.queries.exact" "75b"
selections "cw09b" "cw09b.06.queries.exact" "75b"
selections "cw09b" "cw09b.05.queries.exact" "150b"
selections "cw09b" "cw09b.06.queries.exact" "150b"
selections "cw09b" "cw09b.05.queries.exact" "225b"
selections "cw09b" "cw09b.06.queries.exact" "225b"
selections "cw09b" "cw09b.05.queries.exact" "300b"
selections "cw09b" "cw09b.06.queries.exact" "300b"

selections "cw12b" "cw12b.05.queries.exact" "30b"
selections "cw12b" "cw12b.06.queries.exact" "30b"
selections "cw12b" "cw12b.05.queries.exact" "75b"
selections "cw12b" "cw12b.06.queries.exact" "75b"
selections "cw12b" "cw12b.05.queries.exact" "150b"
selections "cw12b" "cw12b.06.queries.exact" "150b"
selections "cw12b" "cw12b.05.queries.exact" "225b"
selections "cw12b" "cw12b.06.queries.exact" "225b"
selections "cw12b" "cw12b.05.queries.exact" "300b"
selections "cw12b" "cw12b.06.queries.exact" "300b"

function queries {
    coll=$1
    run=$2
    size=$3
    base="$WORK/$coll/$coll.url"
    python3 /scripts/query.py \
        -k 10 100 1000 10000 \
        -r "$run" \
        --queries-dir "$DATA/queries" \
        --selections-dir "$DATA/selections" \
        --selections "$size.greedy.s1.25" \
        --pisa-bin "$BIN" \
        --index-basename "$base" \
        --fwd "$base" \
        --output-dir "$DATA" \
        --only-intersection-queries
}

queries "cw09b" "cw09b.05.queries.qk3" "30b"
queries "cw09b" "cw09b.06.queries.qk3" "30b"
queries "cw09b" "cw09b.05.queries.qk3" "75b"
queries "cw09b" "cw09b.06.queries.qk3" "75b"
queries "cw09b" "cw09b.05.queries.qk3" "150b"
queries "cw09b" "cw09b.06.queries.qk3" "150b"
queries "cw09b" "cw09b.05.queries.qk3" "225b"
queries "cw09b" "cw09b.06.queries.qk3" "225b"
queries "cw09b" "cw09b.05.queries.qk3" "300b"
queries "cw09b" "cw09b.06.queries.qk3" "300b"

queries "cw12b" "cw12b.05.queries.qk3" "30b"
queries "cw12b" "cw12b.06.queries.qk3" "30b"
queries "cw12b" "cw12b.05.queries.qk3" "75b"
queries "cw12b" "cw12b.06.queries.qk3" "75b"
queries "cw12b" "cw12b.05.queries.qk3" "150b"
queries "cw12b" "cw12b.06.queries.qk3" "150b"
queries "cw12b" "cw12b.05.queries.qk3" "225b"
queries "cw12b" "cw12b.06.queries.qk3" "225b"
queries "cw12b" "cw12b.05.queries.qk3" "300b"
queries "cw12b" "cw12b.06.queries.qk3" "300b"

queries "cw09b" "cw09b.05.queries.exact" "30b"
queries "cw09b" "cw09b.06.queries.exact" "30b"
queries "cw09b" "cw09b.05.queries.exact" "75b"
queries "cw09b" "cw09b.06.queries.exact" "75b"
queries "cw09b" "cw09b.05.queries.exact" "150b"
queries "cw09b" "cw09b.06.queries.exact" "150b"
queries "cw09b" "cw09b.05.queries.exact" "225b"
queries "cw09b" "cw09b.06.queries.exact" "225b"
queries "cw09b" "cw09b.05.queries.exact" "300b"
queries "cw09b" "cw09b.06.queries.exact" "300b"

queries "cw12b" "cw12b.05.queries.exact" "30b"
queries "cw12b" "cw12b.06.queries.exact" "30b"
queries "cw12b" "cw12b.05.queries.exact" "75b"
queries "cw12b" "cw12b.06.queries.exact" "75b"
queries "cw12b" "cw12b.05.queries.exact" "150b"
queries "cw12b" "cw12b.06.queries.exact" "150b"
queries "cw12b" "cw12b.05.queries.exact" "225b"
queries "cw12b" "cw12b.06.queries.exact" "225b"
queries "cw12b" "cw12b.05.queries.exact" "300b"
queries "cw12b" "cw12b.06.queries.exact" "300b"
