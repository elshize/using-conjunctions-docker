"""Collect intersections and perform selections for test queries."""

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
    parser.add_argument("--scaling", nargs="+", default=[1.25])
    parser.add_argument(
        "--pisa-bin",
        help="Directory containig PISA tools",
        default="/data/michal/work/inter/pisa/build/bin/",
    )
    parser.add_argument(
        "--intersect-bin",
        help="Directory containig selection tools",
        default="/home/michal/intersect/target/release",
    )
    parser.add_argument(
        "-i", "--index-basename", default="/data/michal/work/inter/cw09b/cw09b.url",
    )
    parser.add_argument(
        "--fwd", default="/data/CW09B/CW09B.url.fwd",
    )
    parser.add_argument(
        "-o",
        "--output-dir",
        help="Output directory",
        required=True,
        default="/data/michal/experiments/intersection-queries",
    )
    parser.add_argument(
        "--dry-run",
        dest="dry",
        action="store_true",
        default=False,
        help="Print commands instead of executing",
    )
    parser.add_argument(
        "--existing-pairs",
        dest="existing_pairs",
        action="store_true",
        default=False,
        help="Extract only intersections that are precomputed",
    )
    parser.add_argument("--use-pairs", default=None)
    return parser.parse_args()


class Executor:
    def __init__(self, args):
        self.run = args.run
        self.pisa_bin = args.pisa_bin
        self.intersect_bin = args.intersect_bin
        self.queries_dir = args.queries_dir
        self.selections_dir = args.selections_dir
        self.queries_program = os.path.join(self.pisa_bin, "queries")
        self.evaluate_program = os.path.join(self.pisa_bin, "evaluate_queries")
        self.dry_run = args.dry
        self.basename = args.index_basename
        self.fwd = args.fwd
        self.output_dir = args.output_dir
        self.existing_pairs = args.existing_pairs
        self.pairs = args.use_pairs

    def execute(self, command):
        print(command)
        if not self.dry_run:
            subprocess.check_call(command, shell=True)

    def intersections(self, *, quantized=False):
        quantized_suffix = ".quantized" if quantized else ""

        queries = os.path.join(self.queries_dir, f"{self.run}{quantized_suffix}.jl")
        output_pairs = f".{self.pairs}" if self.pairs is not None else ""
        output_file = os.path.join(
            os.path.join(self.output_dir, "intersections"),
            f"{self.run}{quantized_suffix}{output_pairs}.jl",
        )
        program = os.path.join(self.pisa_bin, "compute_intersection")
        scorer = "quantized" if quantized else "bm25"
        pairs = self.pairs if self.pairs is not None else self.run
        combinations = (
            "--combinations --mtc 2"
            if not self.existing_pairs
            else (
                f"--only-from {self.basename}{quantized_suffix}"
                f".{pairs}.simdbp.query-pairs"
            )
        )
        self.execute(
            f"{program} {combinations}"
            f" -i {self.basename}{quantized_suffix}.simdbp"
            f" -w {self.basename}.bm25{quantized_suffix}.bmw"
            f" -e block_simdbp -s {scorer}"
            f" --terms {self.fwd}.termlex --stemmer porter2"
            f" -q {queries}"
            f" > {output_file}"
        )

    def selections(
        self, scaling_factor, *, k, method="greedy", output=None, quantized=False,
    ):
        quantized_suffix = ".quantized" if quantized else ""

        pairs_suffix = f".{self.pairs}" if self.pairs is not None else ""
        input = os.path.join(
            os.path.join(self.output_dir, "intersections"),
            f"{self.run}{quantized_suffix}{pairs_suffix}.jl",
        )
        output_pairs = f"{self.pairs}" if self.pairs is not None else "all"
        output_file_base = os.path.join(
            os.path.join(self.output_dir, "selections"),
            f"{self.run}{quantized_suffix}.{output_pairs}.{method}.s{scaling_factor}.{k}",
        )
        program = os.path.join(self.intersect_bin, "intersect")
        self.execute(
            f"{program}"
            f" --method {method}"
            f" -k {k}"
            f" --scale {scaling_factor}"
            f" {input}"
            f" > {output_file_base}.inter.jl"
        )
        self.execute(
            f"jq -c '.query' {output_file_base}.inter.jl > {output_file_base}.jl"
        )


def main(args):
    executor = Executor(args)
    executor.intersections()
    executor.intersections(quantized=True)
    for k in args.k:
        for scaling in args.scaling:
            executor.selections(scaling, k=k)
            executor.selections(scaling, k=k, quantized=True)


if __name__ == "__main__":
    main(cli_args())
