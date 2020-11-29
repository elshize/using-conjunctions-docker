"""Run queries for 'intersection query' (to be named) paper."""

import argparse
import os.path
import subprocess
from enum import Enum


def cli_args():
    """Returns CLI parser."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "-k", type=int, nargs="+", help="Top-k experients to run", default=[1000]
    )
    parser.add_argument(
        "-r", "--run", help="Run name, also part of paths", required=True
    )
    parser.add_argument(
        "--queries-dir",
        help="Query directory",
        default="/data/michal/experiments/intersection-queries/queries/",
    )
    # parser.add_argument(
    #    "--selections-dir",
    #    help="Selections directory",
    #    default="/data/michal/experiments/intersection-queries/selections",
    # )
    # parser.add_argument("--selections", nargs="+", default=None)
    parser.add_argument("--pairs", nargs="+", default=["all"])
    parser.add_argument(
        "--pisa-bin",
        help="Directory containig PISA tools",
        default="/data/michal/work/inter/pisa/build/bin/",
    )
    parser.add_argument(
        "-i", "--index-basename", default="/data/michal/work/inter/cw09b/cw09b.url",
    )
    parser.add_argument(
        "--fwd", default="/data/CW09B/CW09B.url.fwd",
    )
    parser.add_argument("-o", "--output-dir", help="Output directory", required=True)
    parser.add_argument(
        "--dry-run",
        dest="dry",
        action="store_true",
        default=False,
        help="Print commands instead of executing",
    )
    parser.add_argument(
        "--only-intersection-queries",
        dest="only_intersection_queries",
        action="store_true",
        default=False,
        help="Run only the algorithms that rely on intersections",
    )
    parser.add_argument(
        "--no-intersection-queries",
        dest="no_intersection_queries",
        action="store_true",
        default=False,
        help="Run only the algorithms that DO NOT rely on intersections",
    )
    parser.add_argument(
        "--brute-force-selection",
        dest="brute_force",
        action="store_true",
        default=False,
    )
    #
    return parser.parse_args()


class BlockSize(Enum):
    FIXED = 0
    VARIABLE = 1

    def __str__(self):
        if self == BlockSize.FIXED:
            return "bmw"
        return "vbmw"


class Mode(Enum):
    Benchmark = 0
    Inspect = 1
    Evaluate = 2

    def __str__(self):
        if self == Mode.Benchmark:
            return "benchmark"
        if self == Mode.Inspect:
            return "inspect"
        return "evaluate"


class QueryExecutor:
    def __init__(self, args, k):
        self.run = args.run
        self.pisa_bin = args.pisa_bin
        self.queries_dir = args.queries_dir
        # self.selections_dir = args.selections_dir
        self.queries_program = os.path.join(self.pisa_bin, "queries")
        self.evaluate_program = os.path.join(self.pisa_bin, "evaluate_queries")
        self.dry_run = args.dry
        self.basename = args.index_basename
        self.k = k
        self.fwd = args.fwd
        self.output_dir = args.output_dir
        # self.selections = args.selections
        self.pairs = args.pairs
        self.only_intersection_queries = args.only_intersection_queries
        self.no_intersection_queries = args.no_intersection_queries
        self.brute_force = args.brute_force

    def execute(self, command):
        print(command)
        if not self.dry_run:
            subprocess.check_call(command, shell=True)

    def query(
        self,
        algorithm,
        block,
        *,
        output=None,
        quantized=False,
        use_thresholds=False,
        pairs=None,
        mode,
    ):
        if output is None:
            output = algorithm

        quantized_suffix = ".quantized" if quantized else ""
        thresholds = " --use-thresholds" if use_thresholds else ""
        inspect = " --inspect" if mode == Mode.Inspect else ""

        queries = os.path.join(self.queries_dir, f"{self.run}{quantized_suffix}.jl")
        pair_index = ""
        selection_suffix = ""
        if pairs is not None:
            pair_index = (
                f" --pair-index {self.basename}"
                f"{quantized_suffix}.{pairs}.simdbp.query-pairs"
                " --scale 1.25"  # TODO
            )
            if mode == Mode.Benchmark:
                pair_index += " --disk-resident-pairs"
            selection_suffix = f".{pairs}" if pairs != "all" else ""
        output_file = os.path.join(
            os.path.join(self.output_dir, str(mode)),
            f"{self.run}.{output}{quantized_suffix}{selection_suffix}.{self.k}.json",
        )
        program = (
            self.queries_program if mode == Mode.Benchmark else self.evaluate_program
        )
        quantized_flag = " --quantized" if quantized else ""
        threads_flag = " --threads 1" if mode != Mode.Benchmark else ""
        scorer = "quantized" if quantized else "bm25"
        documents = f" --documents {self.fwd}.doclex" if mode == Mode.Evaluate else ""
        safety = " --safe" if mode == Mode.Benchmark and use_thresholds else ""
        brute = " --brute-force-selection" if self.brute_force else ""
        self.execute(
            f"{program}"
            f" -i {self.basename}{quantized_suffix}.simdbp"
            f" -w {self.basename}.bm25{quantized_suffix}.{block}"
            f" -e block_simdbp -a {algorithm} -k {self.k} -s {scorer}"
            f" --terms {self.fwd}.termlex --stemmer porter2"
            f"{documents}{thresholds}{inspect}"
            f" -q {queries}"
            f"{pair_index}"
            f"{quantized_flag}"
            f"{threads_flag}"
            f"{safety}"
            f"{brute}"
            f" > {output_file}"
        )


def execute_all(executor, **kwargs):
    if not executor.only_intersection_queries:
        # executor.query("block_max_wand", BlockSize.FIXED, output="bmw", **kwargs)
        # executor.query(
        #   "block_max_wand",
        #   BlockSize.FIXED,
        #   output="bmw.thresholds",
        #   use_thresholds=True,
        #   **kwargs,
        # )

        executor.query("maxscore", BlockSize.FIXED, **kwargs)
        # executor.query("block_max_wand", BlockSize.VARIABLE, output="vbmw", **kwargs)
        executor.query(
            "maxscore",
            BlockSize.FIXED,
            output="maxscore.thresholds",
            use_thresholds=True,
            **kwargs,
        )
        executor.query(
            "block_max_wand",
            BlockSize.VARIABLE,
            output="vbmw.thresholds",
            use_thresholds=True,
            **kwargs,
        )
        executor.query(
            "maxscore-uni", BlockSize.FIXED, use_thresholds=True, **kwargs,
        )
    if not executor.no_intersection_queries:
        for pairs in executor.pairs:
            executor.query(
                "maxscore-inter-eager",
                BlockSize.VARIABLE,
                use_thresholds=True,
                pairs=pairs,
                **kwargs,
            )
            executor.query(
                "maxscore-inter-opt",
                BlockSize.VARIABLE,
                use_thresholds=True,
                pairs=pairs,
                **kwargs,
            )


def main(args):
    for k in args.k:
        executor = QueryExecutor(args, k)

        execute_all(executor, quantized=False, mode=Mode.Benchmark)
        # execute_all(executor, quantized=False, mode=Mode.Inspect)
        # execute_all(executor, quantized=False, mode=Mode.Evaluate)

        execute_all(executor, quantized=True, mode=Mode.Benchmark)
        # execute_all(executor, quantized=True, mode=Mode.Inspect)
        # execute_all(executor, quantized=True, mode=Mode.Evaluate)


if __name__ == "__main__":
    main(cli_args())
