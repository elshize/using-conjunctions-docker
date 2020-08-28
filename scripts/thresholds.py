"""Collect intersections and perform selections for test queries."""

import argparse
import os.path
import subprocess
import json
import sys


def cli_args():
    """Returns CLI parser."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "-k",
        type=int,
        nargs="+",
        help="Top-k experients to run",
        default=[10, 100, 1000, 10000],
    )
    parser.add_argument("-q", "--queries", required=True)
    parser.add_argument(
        "--pisa-bin", help="Directory containig PISA tools", required=True
    )
    parser.add_argument("-i", "--index-basename", required=True)
    parser.add_argument("--pairs", required=True)
    parser.add_argument("--triples", required=True)
    return parser.parse_args()


class Executor:
    def __init__(self, args):
        self.args = args

    def execute(self, command):
        print(command)
        return subprocess.check_output(command, shell=True).decode("utf8")

    def exact_threshold(self, k, *, quantized):
        quantized_suffix = ".quantized" if quantized else ""
        quantized_flag = "--quantized" if quantized else ""
        scorer = "quantized" if quantized else "bm25"
        program = os.path.join(self.args.pisa_bin, "thresholds")
        return self.execute(
            f"{program} {quantized_flag}"
            f" -i {self.args.index_basename}{quantized_suffix}.simdbp"
            f" -w {self.args.index_basename}.bm25{quantized_suffix}.bmw"
            f" -e block_simdbp -s {scorer}"
            f" --terms {self.args.index_basename}.termlex --stemmer porter2"
            f" -q {self.args.queries}.jl"
            f" -k {k}"
        )

    def kth_threshold(self, k, *, quantized):
        quantized_suffix = ".quantized" if quantized else ""
        quantized_flag = "--quantized" if quantized else ""
        scorer = "quantized" if quantized else "bm25"
        program = os.path.join(self.args.pisa_bin, "kth_threshold")
        return self.execute(
            f"{program} {quantized_flag}"
            f" -i {self.args.index_basename}{quantized_suffix}.simdbp"
            f" -w {self.args.index_basename}.bm25{quantized_suffix}.bmw"
            f" -e block_simdbp -s {scorer}"
            f" --terms {self.args.index_basename}.termlex --stemmer porter2"
            f" -q {self.args.queries}.jl"
            f" -k {k}"
            f" --pairs {self.args.pairs}"
            f" --triples {self.args.triples}"
        )


def resolve_thresholds(executor, ks, *, quantized, method):
    num_queries = None
    thresholds = dict()
    quantized_suffix = ".quantized" if quantized else ""
    for k in ks:
        if method == "qk3":
            output = executor.kth_threshold(k, quantized=quantized)
        elif method == "exact":
            output = executor.exact_threshold(k, quantized=quantized)
        else:
            raise ValueError(f"Unknown threshold estimation method: {method}")
        k_thresholds = [float(t) for t in output.split()]
        if num_queries is not None and num_queries != len(k_thresholds):
            print(
                "Expected {} queries but got {}".format(
                    num_queries, len(k_thresholds)
                ),
                file=sys.stderr,
            )
            sys.exit(1)
        num_queries = len(k_thresholds)
        thresholds[k] = k_thresholds
    with open(f"{executor.args.queries}.jl", "r") as f:
        queries = [json.loads(q) for q in f]
    if len(queries) != num_queries:
        print(
            "Expected {} queries but got {}".format(
                num_queries, len(queries)
            ),
            file=sys.stderr,
        )
        sys.exit(1)
    with open(f"{executor.args.queries}.{method}{quantized_suffix}.jl", "w") as f:
        for idx, query in enumerate(queries):
            query["thresholds"] = []
            for k in ks:
                query["thresholds"].append({"k": k, "score": thresholds[k][idx]})
            print(json.dumps(query), file=f)



def main(args):
    executor = Executor(args)
    resolve_thresholds(executor, args.k, quantized=False, method="qk3")
    resolve_thresholds(executor, args.k, quantized=True, method="qk3")
    resolve_thresholds(executor, args.k, quantized=False, method="exact")
    resolve_thresholds(executor, args.k, quantized=True, method="exact")


if __name__ == "__main__":
    main(cli_args())
