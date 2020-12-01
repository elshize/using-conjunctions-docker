BIN="/work/pisa/build/bin"

set -x
set -e

function queries {
    coll=$1
    run=$2
    size=$3
    flags=$4
    base="$WORK/$coll/$coll.url"
    python3 /scripts/query.py \
        -k 1000 \
        -r "$run" \
        --queries-dir "$DATA/queries" \
        --pairs "$size" \
        --pisa-bin "$BIN" \
        --index-basename "$base" \
        --fwd "$base" \
        --output-dir "$DATA" \
        $flags --only-intersection-queries
}

queries "cw09b" "cw09b.05.queries.hybrid" "30b" ""
queries "cw09b" "cw09b.05.queries.hybrid" "75b" ""
queries "cw09b" "cw09b.05.queries.hybrid" "150b" ""
queries "cw09b" "cw09b.05.queries.hybrid" "225b" ""
queries "cw09b" "cw09b.05.queries.hybrid" "300b" ""

queries "cw09b" "cw09b.06.queries.hybrid" "30b" ""
queries "cw09b" "cw09b.06.queries.hybrid" "75b" ""
queries "cw09b" "cw09b.06.queries.hybrid" "150b" ""
queries "cw09b" "cw09b.06.queries.hybrid" "225b" ""
queries "cw09b" "cw09b.06.queries.hybrid" "300b" ""

queries "cw12b" "cw12b.05.queries.hybrid" "30b" ""
queries "cw12b" "cw12b.05.queries.hybrid" "75b" ""
queries "cw12b" "cw12b.05.queries.hybrid" "150b" ""
queries "cw12b" "cw12b.05.queries.hybrid" "225b" ""
queries "cw12b" "cw12b.05.queries.hybrid" "300b" ""

queries "cw12b" "cw12b.06.queries.hybrid" "30b" ""
queries "cw12b" "cw12b.06.queries.hybrid" "75b" ""
queries "cw12b" "cw12b.06.queries.hybrid" "150b" ""
queries "cw12b" "cw12b.06.queries.hybrid" "225b" ""
queries "cw12b" "cw12b.06.queries.hybrid" "300b" ""

##

cp "$DATA/queries/cw09b.05.queries.hybrid.jl" \
    "$DATA/queries/cw09b.05.queries.hybrid-no-ssd.jl"
cp "$DATA/queries/cw09b.06.queries.hybrid.jl" \
    "$DATA/queries/cw09b.06.queries.hybrid-no-ssd.jl"
cp "$DATA/queries/cw12b.05.queries.hybrid.jl" \
    "$DATA/queries/cw12b.05.queries.hybrid-no-ssd.jl"
cp "$DATA/queries/cw12b.06.queries.hybrid.jl" \
    "$DATA/queries/cw12b.06.queries.hybrid-no-ssd.jl"
cp "$DATA/queries/cw09b.05.queries.hybrid.quantized.jl" \
    "$DATA/queries/cw09b.05.queries.hybrid-no-ssd.quantized.jl"
cp "$DATA/queries/cw09b.06.queries.hybrid.quantized.jl" \
    "$DATA/queries/cw09b.06.queries.hybrid-no-ssd.quantized.jl"
cp "$DATA/queries/cw12b.05.queries.hybrid.quantized.jl" \
    "$DATA/queries/cw12b.05.queries.hybrid-no-ssd.quantized.jl"
cp "$DATA/queries/cw12b.06.queries.hybrid.quantized.jl" \
    "$DATA/queries/cw12b.06.queries.hybrid-no-ssd.quantized.jl"

queries "cw09b" "cw09b.05.queries.hybrid-no-ssd" "30b" "--no-ssd"
queries "cw09b" "cw09b.05.queries.hybrid-no-ssd" "75b" "--no-ssd"
queries "cw09b" "cw09b.05.queries.hybrid-no-ssd" "150b" "--no-ssd"
queries "cw09b" "cw09b.05.queries.hybrid-no-ssd" "225b" "--no-ssd"
queries "cw09b" "cw09b.05.queries.hybrid-no-ssd" "300b" "--no-ssd"

queries "cw09b" "cw09b.06.queries.hybrid-no-ssd" "30b" "--no-ssd"
queries "cw09b" "cw09b.06.queries.hybrid-no-ssd" "75b" "--no-ssd"
queries "cw09b" "cw09b.06.queries.hybrid-no-ssd" "150b" "--no-ssd"
queries "cw09b" "cw09b.06.queries.hybrid-no-ssd" "225b" "--no-ssd"
queries "cw09b" "cw09b.06.queries.hybrid-no-ssd" "300b" "--no-ssd"

queries "cw12b" "cw12b.05.queries.hybrid-no-ssd" "30b" "--no-ssd"
queries "cw12b" "cw12b.05.queries.hybrid-no-ssd" "75b" "--no-ssd"
queries "cw12b" "cw12b.05.queries.hybrid-no-ssd" "150b" "--no-ssd"
queries "cw12b" "cw12b.05.queries.hybrid-no-ssd" "225b" "--no-ssd"
queries "cw12b" "cw12b.05.queries.hybrid-no-ssd" "300b" "--no-ssd"

queries "cw12b" "cw12b.06.queries.hybrid-no-ssd" "30b" "--no-ssd"
queries "cw12b" "cw12b.06.queries.hybrid-no-ssd" "75b" "--no-ssd"
queries "cw12b" "cw12b.06.queries.hybrid-no-ssd" "150b" "--no-ssd"
queries "cw12b" "cw12b.06.queries.hybrid-no-ssd" "225b" "--no-ssd"
queries "cw12b" "cw12b.06.queries.hybrid-no-ssd" "300b" "--no-ssd"

##

queries "cw09b" "cw09b.05.queries.exact" "30b" ""
queries "cw09b" "cw09b.05.queries.exact" "75b" ""
queries "cw09b" "cw09b.05.queries.exact" "150b" ""
queries "cw09b" "cw09b.05.queries.exact" "225b" ""
queries "cw09b" "cw09b.05.queries.exact" "300b" ""

queries "cw09b" "cw09b.06.queries.exact" "30b" ""
queries "cw09b" "cw09b.06.queries.exact" "75b" ""
queries "cw09b" "cw09b.06.queries.exact" "150b" ""
queries "cw09b" "cw09b.06.queries.exact" "225b" ""
queries "cw09b" "cw09b.06.queries.exact" "300b" ""

queries "cw12b" "cw12b.05.queries.exact" "30b" ""
queries "cw12b" "cw12b.05.queries.exact" "75b" ""
queries "cw12b" "cw12b.05.queries.exact" "150b" ""
queries "cw12b" "cw12b.05.queries.exact" "225b" ""
queries "cw12b" "cw12b.05.queries.exact" "300b" ""

queries "cw12b" "cw12b.06.queries.exact" "30b" ""
queries "cw12b" "cw12b.06.queries.exact" "75b" ""
queries "cw12b" "cw12b.06.queries.exact" "150b" ""
queries "cw12b" "cw12b.06.queries.exact" "225b" ""
queries "cw12b" "cw12b.06.queries.exact" "300b" ""

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
        --pairs "$size" \
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

queries_short "cw12b" "cw09b.05.queries.hybrid" "30b"
queries_short "cw12b" "cw09b.05.queries.hybrid" "75b"
queries_short "cw12b" "cw09b.05.queries.hybrid" "150b"
queries_short "cw12b" "cw09b.05.queries.hybrid" "225b"
queries_short "cw12b" "cw09b.05.queries.hybrid" "300b"

queries_short "cw12b" "cw09b.06.queries.hybrid" "30b"
queries_short "cw12b" "cw09b.06.queries.hybrid" "75b"
queries_short "cw12b" "cw09b.06.queries.hybrid" "150b"
queries_short "cw12b" "cw09b.06.queries.hybrid" "225b"
queries_short "cw12b" "cw09b.06.queries.hybrid" "300b"

queries_short "cw12b" "cw09b.05.queries.exact" "30b"
queries_short "cw12b" "cw09b.05.queries.exact" "75b"
queries_short "cw12b" "cw09b.05.queries.exact" "150b"
queries_short "cw12b" "cw09b.05.queries.exact" "225b"
queries_short "cw12b" "cw09b.05.queries.exact" "300b"

queries_short "cw12b" "cw09b.06.queries.exact" "30b"
queries_short "cw12b" "cw09b.06.queries.exact" "75b"
queries_short "cw12b" "cw09b.06.queries.exact" "150b"
queries_short "cw12b" "cw09b.06.queries.exact" "225b"
queries_short "cw12b" "cw09b.06.queries.exact" "300b"
