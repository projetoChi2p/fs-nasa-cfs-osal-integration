#!/bin/bash

THIS_SCRIPT=${BASH_SOURCE[0]}
THIS_SCRIPT_FULLNAME=$(realpath "$THIS_SCRIPT")
THIS_SCRIPT=$(basename "${THIS_SCRIPT_FULLNAME}")
ROOT_DIR=$(dirname "$THIS_SCRIPT_FULLNAME")

PATH_TOOLCHAIN_FILE="../tests_defs/toolchain-nucleo-f767-freertos.cmake"
BUILD_DIR="build_osal-tests-nucleo-f767-freertos"

cd ${ROOT_DIR}

if [ $# -gt 2 ]; then
    echo "Use: $0 [clean] [<target-prog>]"
    exit -1
elif [ $# -eq 1 ]; then
    if [ "$1" == "clean" ]; then
        rm -rf ${BUILD_DIR}
    else
        TARGET_PROG=$1
    fi
elif [ $# -eq 2 ]; then
    if [ "$1" == "clean" ]; then
        rm -rf ${BUILD_DIR}
        TARGET_PROG=$2
    else
        echo "Use: $0 [clean] [<target-prog>]"
        exit -1
    fi
fi

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

# Set Make verbose
export VERBOSE=1

cmake \
    -DENABLE_UNIT_TESTS=true \
    -DCMAKE_TOOLCHAIN_FILE=${PATH_TOOLCHAIN_FILE} \
    -DOSAL_CONFIG_DEBUG_PERMISSIVE_MODE=TRUE \
    -DOSAL_CONFIG_DEBUG_PRINTF=true \
    ../osal

make \
    ${TARGET_PROG}
