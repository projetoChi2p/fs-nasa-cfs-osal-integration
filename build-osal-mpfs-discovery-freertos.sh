#!/bin/bash

PATH_TOOLCHAIN_FILE="../tests_defs/toolchain-mpfs-discovery-freertos.cmake"
BUILD_DIR="build_osal-mpfs-discovery-freertos"

if [ $# -gt 1 ]; then
    echo "Use: $0 [clean]"
    exit -1
elif [ $# -eq 1 ]; then
    if [ "$1" == "clean" ]; then

        rm -rf ${BUILD_DIR}
        mkdir ${BUILD_DIR}
        cd ${BUILD_DIR}

    else
        echo "Use: $0 [clean]"
        exit -1
    fi
fi

cmake \
    -DCMAKE_TOOLCHAIN_FILE=${PATH_TOOLCHAIN_FILE} \
    -DOSAL_CONFIG_DEBUG_PRINTF=true \
    ../osal

make
