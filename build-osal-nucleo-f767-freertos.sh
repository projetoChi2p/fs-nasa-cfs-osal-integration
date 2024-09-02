PATH_TOOLCHAIN_FILE="../tests_defs/toolchain-nucleo-f767-freertos.cmake"
BUILD_DIR="build_osal-nucleo-f767-freertos"


rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}
cd ${BUILD_DIR}


cmake \
    -DCMAKE_TOOLCHAIN_FILE=${PATH_TOOLCHAIN_FILE} \
    -DOSAL_CONFIG_DEBUG_PRINTF=true \
    ../osal

make