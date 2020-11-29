BIN="/work/pisa/build/bin"

set -x
set -e

function queries {
    coll=$1
    run=$2
    size=$3
    base="$WORK/$coll/$coll.url"
    python3 /scripts/query.py \
        -k 10 100 10000 \
        -r "$run" \
        --queries-dir "$DATA/queries" \
        --pairs "$size" \
        --pisa-bin "$BIN" \
        --index-basename "$base" \
        --fwd "$base" \
        --output-dir "$DATA" \
        --only-intersection-queries
}

# queries "cw09b" "cw09b.05.queries.hybrid" "30b"
# queries "cw09b" "cw09b.05.queries.hybrid" "75b"
# queries "cw09b" "cw09b.05.queries.hybrid" "150b"
# queries "cw09b" "cw09b.05.queries.hybrid" "225b"
# queries "cw09b" "cw09b.05.queries.hybrid" "300b"
# queries "cw09b" "cw09b.05.queries.hybrid" "750b"

# queries "cw09b" "cw09b.06.queries.hybrid" "30b"
# queries "cw09b" "cw09b.06.queries.hybrid" "75b"
# queries "cw09b" "cw09b.06.queries.hybrid" "150b"
# queries "cw09b" "cw09b.06.queries.hybrid" "225b"
# queries "cw09b" "cw09b.06.queries.hybrid" "300b"
# queries "cw09b" "cw09b.06.queries.hybrid" "750b"

# queries "cw12b" "cw12b.05.queries.hybrid" "30b"
# queries "cw12b" "cw12b.05.queries.hybrid" "75b"
# queries "cw12b" "cw12b.05.queries.hybrid" "150b"
# queries "cw12b" "cw12b.05.queries.hybrid" "225b"
# queries "cw12b" "cw12b.05.queries.hybrid" "300b"
# queries "cw12b" "cw12b.05.queries.hybrid" "750b"

# queries "cw12b" "cw12b.06.queries.hybrid" "30b"
# queries "cw12b" "cw12b.06.queries.hybrid" "75b"
# queries "cw12b" "cw12b.06.queries.hybrid" "150b"
# queries "cw12b" "cw12b.06.queries.hybrid" "225b"
# queries "cw12b" "cw12b.06.queries.hybrid" "300b"
# queries "cw12b" "cw12b.06.queries.hybrid" "750b"

##

# queries "cw09b" "cw09b.05.queries.exact" "30b"
# queries "cw09b" "cw09b.05.queries.exact" "75b"
# queries "cw09b" "cw09b.05.queries.exact" "150b"
# queries "cw09b" "cw09b.05.queries.exact" "225b"
# queries "cw09b" "cw09b.05.queries.exact" "300b"
# queries "cw09b" "cw09b.05.queries.exact" "750b"

# queries "cw09b" "cw09b.06.queries.exact" "30b"
# queries "cw09b" "cw09b.06.queries.exact" "75b"
# queries "cw09b" "cw09b.06.queries.exact" "150b"
# queries "cw09b" "cw09b.06.queries.exact" "225b"
# queries "cw09b" "cw09b.06.queries.exact" "300b"
# queries "cw09b" "cw09b.06.queries.exact" "750b"

# queries "cw12b" "cw12b.05.queries.exact" "30b"
# queries "cw12b" "cw12b.05.queries.exact" "75b"
# queries "cw12b" "cw12b.05.queries.exact" "150b"
# queries "cw12b" "cw12b.05.queries.exact" "225b"
# queries "cw12b" "cw12b.05.queries.exact" "300b"
# queries "cw12b" "cw12b.05.queries.exact" "750b"

# queries "cw12b" "cw12b.06.queries.exact" "30b"
# queries "cw12b" "cw12b.06.queries.exact" "75b"
# queries "cw12b" "cw12b.06.queries.exact" "150b"
# queries "cw12b" "cw12b.06.queries.exact" "225b"
# queries "cw12b" "cw12b.06.queries.exact" "300b"
# queries "cw12b" "cw12b.06.queries.exact" "750b"

function queries_short {
    coll=$1
    run=$2
    size=$3
    base="$WORK/$coll/$coll.url"
    jq 'select(.term_ids|length < 6)' -c "$DATA/queries/$run.jl" > "$DATA/queries/$run-short.jl"
    cp "$DATA/queries/$run-short.jl" "$DATA/queries/$run-short.quantized.jl"
    cp "$DATA/queries/$run-short.jl" "$DATA/queries/$run-short-brute-force.jl"
    cp "$DATA/queries/$run-short.jl" "$DATA/queries/$run-short-brute-force.quantized.jl"
    python3 /scripts/query.py \
        -k 1000 \
        -r "$run-short-brute-force" \
        --queries-dir "$DATA/queries" \
        --pairs "$size" \
        --pisa-bin "$BIN" \
        --index-basename "$base" \
        --fwd "$base" \
        --output-dir "$DATA" \
        --only-intersection-queries \
        --brute-force-selection
    python3 /scripts/query.py \
        -k 1000 \
        -r "$run-short" \
        --queries-dir "$DATA/queries" \
        --pisa-bin "$BIN" \
        --index-basename "$base" \
        --fwd "$base" \
        --output-dir "$DATA" \
        --only-intersection-queries
    # TODO: Subtract selection times
}

queries_short "cw09b" "cw09b.05.queries.hybrid" "30b"
queries_short "cw09b" "cw09b.05.queries.hybrid" "75b"
queries_short "cw09b" "cw09b.05.queries.hybrid" "150b"
queries_short "cw09b" "cw09b.05.queries.hybrid" "225b"
queries_short "cw09b" "cw09b.05.queries.hybrid" "300b"

queries_short "cw09b" "cw09b.06.queries.hybrid" "30b"
queries_short "cw09b" "cw09b.06.queries.hybrid" "75b"
queries_short "cw09b" "cw09b.06.queries.hybrid" "150b"
queries_short "cw09b" "cw09b.06.queries.hybrid" "225b"
queries_short "cw09b" "cw09b.06.queries.hybrid" "300b"

queries_short "cw09b" "cw09b.05.queries.exact" "30b"
queries_short "cw09b" "cw09b.05.queries.exact" "75b"
queries_short "cw09b" "cw09b.05.queries.exact" "150b"
queries_short "cw09b" "cw09b.05.queries.exact" "225b"
queries_short "cw09b" "cw09b.05.queries.exact" "300b"

queries_short "cw09b" "cw09b.06.queries.exact" "30b"
queries_short "cw09b" "cw09b.06.queries.exact" "75b"
queries_short "cw09b" "cw09b.06.queries.exact" "150b"
queries_short "cw09b" "cw09b.06.queries.exact" "225b"
queries_short "cw09b" "cw09b.06.queries.exact" "300b"
