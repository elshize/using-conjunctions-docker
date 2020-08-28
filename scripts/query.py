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
    parser.add_argument(
        "--selections-dir",
        help="Selections directory",
        default="/data/michal/experiments/intersection-queries/selections",
    )
    parser.add_argument("--selections", nargs="+", default=["all.greedy.s1.25"])
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
        self.selections_dir = args.selections_dir
        self.queries_program = os.path.join(self.pisa_bin, "queries")
        self.evaluate_program = os.path.join(self.pisa_bin, "evaluate_queries")
        self.dry_run = args.dry
        self.basename = args.index_basename
        self.k = k
        self.fwd = args.fwd
        self.output_dir = args.output_dir
        self.selections = args.selections
        self.only_intersection_queries = args.only_intersection_queries

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
        selection=None,
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
        if selection is not None:
            queries = os.path.join(
                self.selections_dir,
                f"{self.run}{quantized_suffix}.{selection}.{self.k}.jl",
            )
            size = selection.split(".")[0]
            run = size if size != "all" else self.run
            pair_index = (
                f" --pair-index {self.basename}"
                f"{quantized_suffix}.{run}.simdbp.query-pairs"
            )
            selection_suffix = f".{selection}"
        output_file = os.path.join(
            os.path.join(self.output_dir, str(mode)),
            f"{self.run}.{output}{quantized_suffix}{selection_suffix}.{self.k}.json",
        )
        program = (
            self.queries_program if mode == Mode.Benchmark else self.evaluate_program
        )
        quantized_flag = " --quantized" if quantized else ""
        scorer = "quantized" if quantized else "bm25"
        documents = f" --documents {self.fwd}.doclex" if mode == Mode.Evaluate else ""
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
            f" > {output_file}"
        )


def execute_all(executor, **kwargs):
    if not executor.only_intersection_queries:
        executor.query("block_max_wand", BlockSize.FIXED, output="bmw", **kwargs)
        executor.query(
           "block_max_wand",
           BlockSize.FIXED,
           output="bmw.thresholds",
           use_thresholds=True,
           **kwargs,
        )

        executor.query("maxscore", BlockSize.FIXED, **kwargs)
        executor.query("block_max_wand", BlockSize.VARIABLE, output="vbmw", **kwargs)
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
    for selection in executor.selections:
        executor.query(
            "maxscore-inter-eager",
            BlockSize.FIXED,
            use_thresholds=True,
            selection=selection,
            **kwargs,
        )
        executor.query(
            "maxscore-inter-opt",
            BlockSize.FIXED,
            use_thresholds=True,
            selection=selection,
            **kwargs,
        )


def main(args):
    for k in args.k:
        executor = QueryExecutor(args, k)

        execute_all(executor, quantized=False, mode=Mode.Benchmark)
        execute_all(executor, quantized=False, mode=Mode.Inspect)
        execute_all(executor, quantized=False, mode=Mode.Evaluate)

        execute_all(executor, quantized=True, mode=Mode.Benchmark)
        execute_all(executor, quantized=True, mode=Mode.Inspect)
        execute_all(executor, quantized=True, mode=Mode.Evaluate)


if __name__ == "__main__":
    main(cli_args())
