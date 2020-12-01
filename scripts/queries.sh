BIN="$WORK/pisa/build/bin"

set -x
mkdir -p "$DATA/benchmark"
mkdir -p "$DATA/inspect"
mkdir -p "$DATA/evaluate"
mkdir -p "$DATA/intersections"

function queries_no_intersections {
    coll=$1
    run=$2
    base="$WORK/$coll/$coll.url"
    python3 /scripts/query.py \
        -k 1000 \
        -r "$run" \
        --queries-dir "$DATA/queries" \
        --pisa-bin "$BIN" \
        --index-basename "$base" \
        --fwd "$base" \
        --output-dir "$DATA" \
        --no-intersection-queries
}

queries_no_intersections "cw09b" "cw09b.05.queries.hybrid"
queries_no_intersections "cw09b" "cw09b.06.queries.hybrid"
queries_no_intersections "cw12b" "cw12b.05.queries.hybrid"
queries_no_intersections "cw12b" "cw12b.06.queries.hybrid"

queries_no_intersections "cw09b" "cw09b.05.queries.exact"
queries_no_intersections "cw09b" "cw09b.06.queries.exact"
queries_no_intersections "cw12b" "cw12b.05.queries.exact"
queries_no_intersections "cw12b" "cw12b.06.queries.exact"

function queries {
    coll=$1
    run=$2
    flags=$3
    base="$WORK/$coll/$coll.url"
    python3 /scripts/query.py \
        -k 1000 \
        -r "$run" \
        --queries-dir "$DATA/queries" \
        --pisa-bin "$BIN" \
        --index-basename "$base" \
        --fwd "$base" \
        --output-dir "$DATA" \
        $flags --only-intersection-queries
}

queries "cw09b" "cw09b.05.queries.hybrid" ""
queries "cw09b" "cw09b.06.queries.hybrid" ""
queries "cw12b" "cw12b.05.queries.hybrid" ""
queries "cw12b" "cw12b.06.queries.hybrid" ""

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
queries "cw09b" "cw09b.05.queries.hybrid-no-ssd" "--no-ssd"
queries "cw09b" "cw09b.06.queries.hybrid-no-ssd" "--no-ssd"
queries "cw12b" "cw12b.05.queries.hybrid-no-ssd" "--no-ssd"
queries "cw12b" "cw12b.06.queries.hybrid-no-ssd" "--no-ssd"

queries "cw09b" "cw09b.05.queries.exact" ""
queries "cw09b" "cw09b.06.queries.exact" ""
queries "cw12b" "cw12b.05.queries.exact" ""
queries "cw12b" "cw12b.06.queries.exact" ""

function queries_short {
    coll=$1
    run=$2
    base="$WORK/$coll/$coll.url"
    jq 'select(.term_ids|length < 6)' -c "$DATA/queries/$run.jl" > "$DATA/queries/$run-short.jl"
    cp "$DATA/queries/$run-short.jl" "$DATA/queries/$run-short.quantized.jl"
    cp "$DATA/queries/$run-short.jl" "$DATA/queries/$run-short-brute-force.jl"
    cp "$DATA/queries/$run-short.jl" "$DATA/queries/$run-short-brute-force.quantized.jl"
    python3 /scripts/query.py \
        -k 1000 \
        -r "$run-short-brute-force" \
        --queries-dir "$DATA/queries" \
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

queries_short "cw09b" "cw09b.05.queries.hybrid"
queries_short "cw09b" "cw09b.06.queries.hybrid"
queries_short "cw09b" "cw09b.05.queries.exact"
queries_short "cw09b" "cw09b.06.queries.exact"
queries_short "cw12b" "cw12b.05.queries.hybrid"
queries_short "cw12b" "cw12b.06.queries.hybrid"
queries_short "cw12b" "cw12b.05.queries.exact"
queries_short "cw12b" "cw12b.06.queries.exact"
