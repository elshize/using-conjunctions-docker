#!/usr/bin/env bash

cd $WORK
git clone https://github.com/pisa-engine/pisa.git
cd pisa && mkdir build && cd build
git checkout conjunctions-for-disjunctions
cmake ..
make -j2
cp bin/* /usr/local/bin/
