#!/bin/sh
set -x
set -e

. ./BASE_PATH

if [ -z $BASE_DIR ]; then
    echo "Error: BASE_DIR not set!"
    exit 1
fi

cd $BASE_DIR
mkdir toolchain-src
cd toolchain-src

git clone git://github.com/jpf91/ndk-build.git build

mkdir gmp && cd gmp
wget ftp://ftp.gmplib.org/pub/gmp-5.0.3/gmp-5.0.3.tar.bz2
cd ../

mkdir gdb && cd gdb
wget ftp://ftp.gnu.org/gnu/gdb/gdb-7.4.tar.bz2
tar xjf gdb-7.4.tar.bz2
cd ../

mkdir mpc && cd mpc
wget http://www.multiprecision.org/mpc/download/mpc-0.9.tar.gz
cd ../

mkdir mpfr && cd mpfr
wget http://www.mpfr.org/mpfr-3.0.1/mpfr-3.0.1.tar.bz2
cd ../

mkdir binutils
cd binutils/
wget http://sourceware.mirrors.tds.net/pub/sourceware.org/binutils/snapshots/binutils-2.22.51.tar.bz2
tar xjf binutils-2.22.51.tar.bz2
cd ../

mkdir gcc
cd gcc/
wget ftp://ftp.gnu.org//gnu/gcc/gcc-4.6.2/gcc-4.6.2.tar.bz2
tar xjf gcc-4.6.2.tar.bz2
cd gcc-4.6.2
patch -p1 -i $BASE_DIR/patches/gcc-android.patch
cd ../../

git clone https://jpf91@github.com/jpf91/GDC.git gdc
cd gdc
git checkout android
cd ../

cd gcc/gcc-4.6.2/
ln -s ../../../gdc/d gcc/d
./gcc/d/setup-gcc.sh
cd ../../

cd $BASE_DIR
wget http://dl.google.com/android/ndk/android-ndk-r7-linux-x86.tar.bz2
tar xjf android-ndk-r7-linux-x86.tar.bz2

cd android-ndk-r7
patch -p1 -i $BASE_DIR/patches/build-mpc.patch
cd ../

cd $BASE_DIR
cd android-ndk-r7
patch -p2 -i $BASE_DIR/patches/build-i486-host.patch
cd ../

cd $BASE_DIR
cd android-ndk-r7
patch -p1 -i $BASE_DIR/patches/build-mingw64.patch
cd ../
