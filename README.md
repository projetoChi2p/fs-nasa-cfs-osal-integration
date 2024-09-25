# fs-nasa-cfs-osal-integration
NASA OSAL bundle for integration and unit tests

This repository aims in a minimal bundle of NASA cFS components required for executing OSAL's integration and unit tests.

It works similar to the NASA cFS sample mission bundle (https://github.com/nasa/cFS), but excluding applications, libraries and cFS executive components required to a complete mission.

# Setup

    sudo apt install make git cmake gcc clang gcc-arm-none-eabi openocd
    git submodule init
    git submodule update

# Build
The unit tests build process is simplified by the scripts, to have more information about it, check the oficial cFS documentation.

    ./build-tests-osal-nucleo-f767-freertos.sh

# Run
To get the board ID

    udevadm info -q property -p $(udevadm info -q path -n /dev/ttyACM0) | grep ID_SERIAL

To program the NUCLEO-F767ZI

    openocd -s /usr/share/openocd/scripts/  --file board/stm32f7discovery.cfg --command "hla_serial ID_SERIAL_SHORT; program path/to/program.elf verify reset exit"
