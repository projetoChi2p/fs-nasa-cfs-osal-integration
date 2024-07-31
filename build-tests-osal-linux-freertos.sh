PATH_TOOLCHAIN_FILE="../obdh_v0_defs/toolchain-i386-freertos-linux.cmake"
BUILD_DIR="build_osal-tests-linux-freertos"


rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}
cd ${BUILD_DIR}


cmake \
    -DENABLE_UNIT_TESTS=true \
    -DCMAKE_TOOLCHAIN_FILE=${PATH_TOOLCHAIN_FILE} \
    -DOSAL_CONFIG_DEBUG_PERMISSIVE_MODE=TRUE \
    -DOSAL_CONFIG_DEBUG_PRINTF=true \
    ../osal

make -j 6
    