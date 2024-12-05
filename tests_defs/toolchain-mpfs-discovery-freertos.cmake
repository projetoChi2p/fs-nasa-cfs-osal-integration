
set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)


set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR riscv)
set(CMAKE_CROSSCOMPILING 1)

add_compile_options(
    # -Werror                     # Treat warnings as errors (code should be clean)
)

add_definitions(-DMPFS_DISCOVERY_KIT)

set(MPFS_HARDWARE_DESIGN "mpfs-discovery-kit-design_v0.2")

set(GCCPREFIX   "riscv64-unknown-elf-")

message("+++ Home '$ENV{HOME}'.")

#   "/home/work/toolchain_riscv/rv64/riscv-gnu-toolchain-12.2.0-2023-08-18/bin/" built with float
#   "/opt/Microchip/SoftConsole-v2022.2-RISC-V-747/riscv-unknown-elf-gcc/bin/"
#   "$ENV{HOME}/Microchip/SoftConsole-v2022.2-RISC-V-747/riscv-unknown-elf-gcc/bin/"
#   "/home/work/toolchain_riscv/riscv-gnu-toolchain-14.2.0-2024.11.22-riscv64i-medlow/bin/"
find_program(CMAKE_C_COMPILER
  NAMES ${GCCPREFIX}gcc
  HINTS
    "/home/work/toolchain_riscv/riscv-gnu-toolchain-14.2.0-2024.11.22-riscv64i-medlow/bin/"
    "/opt/riscv-gnu-toolchain-14.2.0-2024.11.22-riscv64i-medlow/bin/"
  DOC "Find GNU GCC Toolchain"
  REQUIRED
)



GET_FILENAME_COMPONENT(GCCPATH      "${CMAKE_C_COMPILER}"                 DIRECTORY)
string(APPEND GCCPATH "/")

message("+++ Using GCC from '${GCCPATH}'.")

set(CMAKE_VERBOSE_MAKEFILE true)

set(CMAKE_C_COMPILER            "${GCCPATH}${GCCPREFIX}gcc")
set(CMAKE_CXX_COMPILER          "${GCCPATH}${GCCPREFIX}g++")
set(CMAKE_AS                    "${GCCPATH}${GCCPREFIX}as")
set(CMAKE_ASM_COMPILER          "${GCCPATH}${GCCPREFIX}gcc")
set(CMAKE_OBJCOPY               "${GCCPATH}${GCCPREFIX}objcopy")
set(CMAKE_OBJDUMP               "${GCCPATH}${GCCPREFIX}objdump")
set(CMAKE_SIZE                  "${GCCPATH}${GCCPREFIX}size")
set(CMAKE_AR                    "${GCCPATH}${GCCPREFIX}ar")


GET_FILENAME_COMPONENT(MY_MISSION_DEFS_DIR "${CMAKE_CURRENT_LIST_FILE}"     DIRECTORY)
GET_FILENAME_COMPONENT(TOP_PROJECT_DIR     "${MY_MISSION_DEFS_DIR}/../"     REALPATH )
GET_FILENAME_COMPONENT(THIRDPARTY_DIR      "${TOP_PROJECT_DIR}/third-party" REALPATH )
GET_FILENAME_COMPONENT(OSAL_SOURCE_DIR     "${TOP_PROJECT_DIR}/osal"        REALPATH )
GET_FILENAME_COMPONENT(PSP_SOURCE_DIR      "${TOP_PROJECT_DIR}/psp"         REALPATH )
GET_FILENAME_COMPONENT(CFE_SOURCE_DIR      "${TOP_PROJECT_DIR}/cfe"         REALPATH )

set(OSAL_FREERTOS_INC_DIR          "${THIRDPARTY_DIR}/freertos-v10.5.1/include")
set(OSAL_FREERTOS_SRC_DIR          "${THIRDPARTY_DIR}/freertos-v10.5.1")
set(OSAL_FREERTOS_PLUS_FAT_SRC_DIR "${THIRDPARTY_DIR}/freertos-plus-fat-2024-01-25-dev")

message("+++ Using MY_MISSION_DEFS_DIR '${MY_MISSION_DEFS_DIR}'.")
message("+++ Using TOP_PROJECT_DIR '${TOP_PROJECT_DIR}'.")
message("+++ Using THIRDPARTY_DIR '${THIRDPARTY_DIR}'.")
message("+++ Inside toolchain cmake ${CMAKE_CURRENT_LIST_FILE}.")
message("+++ Using OSAL_FREERTOS_INC_DIR '${OSAL_FREERTOS_INC_DIR}'.")
message("+++ Using OSAL_FREERTOS_SRC_DIR '${OSAL_FREERTOS_SRC_DIR}'.")
message("+++ Using OSAL_SOURCE_DIR '${OSAL_SOURCE_DIR}'.")

set(THIRD_PARTY_DIR "${CMAKE_SOURCE_DIR}/third-party")
set(FREERTOS_DIR "${THIRD_PARTY_DIR}/freertos")

# FreeRTOS
include_directories(
    ${FREERTOS_DIR}/portable/GCC/RISC-V
    ${FREERTOS_DIR}/portable/GCC/RISC-V/chip_specific_extensions/RISCV_MTIME_CLINT_no_extensions
    ${FREERTOS_DIR}/include
)

# FreeRTOS + FAT
include_directories(
    ${OSAL_FREERTOS_PLUS_FAT_SRC_DIR}
    ${OSAL_FREERTOS_PLUS_FAT_SRC_DIR}/include
)

# OSAL
include_directories(${OSAL_SOURCE_DIR}/src/os/shared/inc)
include_directories(${OSAL_SOURCE_DIR}/src/os/freertos/inc)

set(CFE_SYSTEM_PSPNAME      "mpfs-discovery-freertos")
set(OSAL_SYSTEM_BSPTYPE     "mpfs-discovery-freertos")
set(OSAL_SYSTEM_OSTYPE      "freertos")

set(LINKER_SCRIPT "${OSAL_SOURCE_DIR}/src/bsp/${OSAL_SYSTEM_BSPTYPE}/polarfire_hal/boards/${MPFS_HARDWARE_DESIGN}/platform_config/lim-release/linker/mpfs-lim.ld")


# CMake default are:
# - Release: -O3
# - RelWithDebInfo: -O2
# - Debug: -g
# GCC default are:
# -O0

set(CMAKE_C_FLAGS_RELEASE          "          -O1 -DNDEBUG"    CACHE STRING "Overriden by OSAL/cFS toolchain defs." FORCE)
set(CMAKE_ASM_FLAGS_RELEASE        "          -O1 -DNDEBUG"    CACHE STRING "Overriden by OSAL/cFS toolchain defs." FORCE)
set(CMAKE_C_FLAGS_RELWITHDEBINFO   "-g3 -ggdb -O1 -DNDEBUG"    CACHE STRING "Overriden by OSAL/cFS toolchain defs." FORCE)
set(CMAKE_ASM_FLAGS_RELWITHDEBINFO "-g3 -ggdb -O1 -DNDEBUG"    CACHE STRING "Overriden by OSAL/cFS toolchain defs." FORCE)
set(CMAKE_C_FLAGS_DEBUG            "-g3 -ggdb -O0 -DDEBUG"     CACHE STRING "Overriden by OSAL/cFS toolchain defs." FORCE)
set(CMAKE_ASM_FLAGS_DEBUG          "-g3 -ggdb -O0 -DDEBUG"     CACHE STRING "Overriden by OSAL/cFS toolchain defs." FORCE)



# FBV 2024-11-27 At this point in build flow CMake's CMAKE_CXX_COMPILER_VERSION 
# is not ready, so we are recovering it ourselves.
#
#.../SoftConsole-v2022.2-RISC-V-747/riscv-unknown-elf-gcc/bin/riscv64-unknown-elf-gcc --version
# riscv64-unknown-elf-gcc (xPack GNU RISC-V Embedded GCC (Microsemi SoftConsole build), 64-bit) 8.3.0
#
# gcc --version
# gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0
#
# .../arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-gcc --version
# arm-none-eabi-gcc (Arm GNU Toolchain 12.2.Rel1 (Build arm-12.24)) 12.2.1 20221205
#
# .../ncc-1.0.4-gcc/bin/riscv-gaisler-elf-gcc --version
# riscv-gaisler-elf-gcc (ncc-v1.0.4) 10.2.0
#
# .../riscv-gnu-toolchain-12.2.0-2023-08-18-riscv32-multilib/bin/riscv32-unknown-elf-gcc --version
# riscv32-unknown-elf-gcc (g2ee5e430018) 12.2.0
#
# .../riscv-gnu-toolchain-14.2.0-2024.11.22-riscv64i-medlow/bin/riscv64-unknown-elf-gcc --version
# riscv64-unknown-elf-gcc (g04696df096) 14.2.0
#
execute_process(
	COMMAND ${CMAKE_C_COMPILER} --version
	OUTPUT_VARIABLE GCC_VERSION_RAW
)
string(REGEX MATCH "^[^\n]*gcc[^\n]+\n" GCC_VERSION_TEMP "${GCC_VERSION_RAW}")
string(STRIP "${GCC_VERSION_TEMP}" GCC_VERSION_TEMP)
string(APPEND GCC_VERSION_TEMP " ") # just to simply regex 
if ( GCC_VERSION_TEMP MATCHES "^.*gcc.* ([0-9]+\.[0-9]+\.[0-9]+) .*" )
    string(REGEX MATCH " ([0-9]+\.[0-9]+\.[0-9]+) " GCC_VERSION_TEMP "${GCC_VERSION_TEMP}")
    string(STRIP "${GCC_VERSION_TEMP}" GCC_VERSION_TEMP)
else()
    message(FATAL_ERROR "ERROR. Could not identify compiler version: ${GCC_VERSION_RAW}")
endif()

# FBV 2024-11-27 GCC may require extensions explictly.
if (GCC_VERSION_TEMP VERSION_GREATER 12)
    set(RISCV_ARCH "rv64ima_zicsr_zifencei")
else()
    set(RISCV_ARCH "rv64ima")
endif()

set(RISCV_ABI "lp64")


# https://gcc.gnu.org/onlinedocs/gcc/RISC-V-Options.html
# FBV 2024-11-27 Compiling for DDR may require -mcmodel=medany, otherwise warnings/errors about relocation
add_compile_options(-march=${RISCV_ARCH} -mabi=${RISCV_ABI} -msmall-data-limit=8) # 64 bit stuff
add_compile_options(-mcmodel=medlow)                                 # Memory model: how sparse memory addresses can be
add_compile_options(-mstrict-align)                                  # Memory access alignment
#add_compile_options(-mtune=size)                                     # Perhaps avoid unaligned access
add_compile_options(-mno-save-restore)                               # Prologue and epilogue code
add_compile_options(-fmessage-length=0)                              # No-wrap/Long compiler error messages
add_compile_options(-fsigned-char)                                   # C/C++ char is signed
add_compile_options(-ffunction-sections -fdata-sections)             # Place functions and data in own section

#add_compile_options(-fno-rtti)                                       # No C++ run-time type information
#add_compile_options(-fno-exceptions)                                 # No C/C++ language exceptions handling


# When using LIM
#set(CMAKE_C_FLAGS "-march=rv64imac -mabi=lp64 -O0 -mcmodel=medlow -msmall-data-limit=8 -mstrict-align -mno-save-restore -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -g3")
# When using DDR
#set(CMAKE_C_FLAGS "-march=rv64imac -mabi=lp64 -O0 -mcmodel=medany -msmall-data-limit=8 -mstrict-align -mno-save-restore -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -g3")

add_link_options(-march=${RISCV_ARCH} -mabi=${RISCV_ABI})
add_link_options(-T ${LINKER_SCRIPT})
add_link_options(-nostartfiles -Wl,--gc-sections)
add_link_options(--specs=nano.specs)
add_link_options(--specs=nosys.specs)
add_link_options(-Wl,-Map=link.map) # Note: the same map file is being used for all programs! You may need to build a single target to get the correct map.

#set(CMAKE_EXE_LINKER_FLAGS "-T ${LINKER_SCRIPT} -nostartfiles -Wl,--gc-sections -Wl,-Map=link.map --specs=nano.specs --specs=nosys.specs") 
#set(CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS} -x assembler-with-cpp -DportasmHANDLE_INTERRUPT=handle_m_ext_interrupt")


set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM   NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY   NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE   NEVER)

include_directories(${OSAL_SOURCE_DIR}/src/bsp/shared-freertos/vendor)

# FreeRTOS BSP vendored code
include_directories(
    ${OSAL_FREERTOS_SRC_DIR}/portable/GCC/RISC-V
    ${OSAL_FREERTOS_SRC_DIR}/portable/GCC/RISC-V/chip_specific_extensions/RISCV_MTIME_CLINT_no_extensions
    ${OSAL_FREERTOS_SRC_DIR}/include
)

include_directories(
    ${OSAL_SOURCE_DIR}/src/bsp/${OSAL_SYSTEM_BSPTYPE}/polarfire_hal/platform
    ${OSAL_SOURCE_DIR}/src/bsp/${OSAL_SYSTEM_BSPTYPE}/polarfire_hal/boards/${MPFS_HARDWARE_DESIGN}/
    ${OSAL_SOURCE_DIR}/src/bsp/${OSAL_SYSTEM_BSPTYPE}/polarfire_hal/boards/${MPFS_HARDWARE_DESIGN}/platform_config/lim-release
)
    
# Include FreeRTOSConfig.h
include_directories(${OSAL_SOURCE_DIR}/../tests_defs/)



#[[
set(COMPILER_LINKER_OPTION_PREFIX "-Wl,")
set(START_WHOLE_ARCHIVE "--whole-archive")
set(STOP_WHOLE_ARCHIVE  "--no-whole-archive")
set(START_WHOLE_ARCHIVE "${COMPILER_LINKER_OPTION_PREFIX}${START_WHOLE_ARCHIVE}")
set(STOP_WHOLE_ARCHIVE "${COMPILER_LINKER_OPTION_PREFIX}${STOP_WHOLE_ARCHIVE}")
]]
