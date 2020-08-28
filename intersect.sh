#!/usr/bin/env bash

cd $WORK
git clone https://github.com/elshize/intersect.git
cd intersect
cargo build --release
