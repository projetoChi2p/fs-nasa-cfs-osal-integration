#!/bin/bash

THIS_SCRIPT=${BASH_SOURCE[0]}
THIS_SCRIPT_FULLNAME=$(realpath "$THIS_SCRIPT")
THIS_SCRIPT=$(basename "${THIS_SCRIPT_FULLNAME}")
ROOT_DIR=$(dirname "$THIS_SCRIPT_FULLNAME")

PATH_TOOLCHAIN_FILE="../tests_defs/toolchain-rp2350-riscv-freertos.cmake"
BUILD_DIR="build_osal-rp2350-riscv-freertos"

cd ${ROOT_DIR}

if [ $# -gt 1 ]; then
    echo "Use: $0 [clean]"
    exit -1
elif [ $# -eq 1 ]; then
    if [ "$1" == "clean" ]; then
        rm -rf ${BUILD_DIR}
    else
        echo "Use: $0 [clean]"
        exit -1
    fi
fi

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

# CMake valid build types are: Debug, Release, RelWithDebInfo and MinSizeRel
# See ...defs/toolchain-${SIMULATION}.cmake for occasional overrides on CMAKE_FLAGS_*
BUILDTYPE=Debug
# BUILDTYPE=Release

# Set Make verbose
export VERBOSE=1

cmake \
    -DCMAKE_BUILD_TYPE=${BUILDTYPE} \
    -DCMAKE_TOOLCHAIN_FILE=${PATH_TOOLCHAIN_FILE} \
    -DOSAL_CONFIG_DEBUG_PRINTF=true \
    ../osal

make