#!/bin/sh
set -x
set -e

. ./BASE_PATH

if [ -z $BASE_DIR ]; then
    echo "Error: BASE_DIR not set!"
    exit 1
fi

rm -rf $BASE_DIR/android-ndk-r7/toolchains/arm-linux-androideabi-4.6.2/prebuilt/windows_64/

cd $BASE_DIR/android-ndk-r7/build/tools/
NUM_JOBS=1 DFLAGS="-fno-section-anchors" ./build-gcc.sh --mingw  --try-64 --gmp-version=5.0.3 --mpfr-version=3.0.1 --mpc-version=0.9 --binutils-version=2.22.51 --gdb-version=7.4 $BASE_DIR/toolchain-src $BASE_DIR/android-ndk-r7 arm-linux-androideabi-4.6.2

cd $BASE_DIR/toolchain-src/gcc/gcc-4.6.2
gdc_ver=`cat gcc/d/gdc-version`
dmd_ver=`grep 'version = "v' gcc/d/dmd2/mars.c | sed -e 's/^.*"v\(.*\)".*$/\1/'` || exit 1
cd $BASE_DIR/toolchain-src/gdc
if command -v git > /dev/null; then
    hg_branch=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
    hg_revision=`git rev-parse HEAD 2> /dev/null`
    if [ "$?" -eq "0" ]; then
        # is branch useful?
        #gdc_ver="$gdc_ver - r$hg_revision:$hg_id($hg_branch)"
        gdc_ver="$gdc_ver - r$hg_revision:($hg_branch)"
    fi
fi

cd $BASE_DIR
7za a -mx9 -t7z "$BASE_DIR/result/windows64/android-gdc[dmd_ver:$hg_revision].7z" android-ndk-r7/toolchains/arm-linux-androideabi-4.6.2/prebuilt/windows_64/
