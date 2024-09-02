PATH_TOOLCHAIN_FILE="../tests_defs/toolchain-i386-freertos-linux.cmake"
BUILD_DIR="build_osal-linux-freertos"


rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}
cd ${BUILD_DIR}


cmake \
    -DCMAKE_TOOLCHAIN_FILE=${PATH_TOOLCHAIN_FILE} \
    -DOSAL_CONFIG_DEBUG_PRINTF=true \
    ../osal

make
    