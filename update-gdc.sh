#!/bin/sh
set -x
set -e

. ./BASE_PATH

if [ -z $BASE_DIR ]; then
    echo "Error: BASE_DIR not set!"
    exit 1
fi

cd $BASE_DIR/toolchain-src/gdc
hg pull -u

cd ../gcc/gcc-4.6.2/
./gcc/d/setup-gcc.sh --update
cd ../../
