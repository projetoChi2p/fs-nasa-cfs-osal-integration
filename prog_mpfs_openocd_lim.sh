#!/bin/bash

# set -o xtrace
set -e  # -e Exit immediately if a command exits with a non-zero status.


THIS_SCRIPT=${BASH_SOURCE[0]}
THIS_SCRIPT_FULLNAME=$(realpath "$THIS_SCRIPT")
THIS_SCRIPT=$(basename "${THIS_SCRIPT_FULLNAME}")
ROOT_DIR=$(dirname "$THIS_SCRIPT_FULLNAME")

cd $ROOT_DIR

GDB_INTERACTIVE=0

if [ $# -gt 2 ]; then
    echo "Use: $0 [debug] <.elf file>"
    exit -1
elif [ $# -eq 1 ]; then
    if [ "$1" == "debug" ]; then
        echo "Use: $0 [debug] <.elf file>"
        exit -1
    else
        ELF_FILE=$1
    fi
elif [ $# -eq 2 ]; then
    if [ "$1" == "debug" ]; then
        GDB_INTERACTIVE=1
        ELF_FILE=$2
    else
        echo "Use: $0 [debug] <.elf file>"
        exit -1
    fi
fi


if [ -z "$ELF_FILE" ]; then
    echo "Missing PolarFire RISC-V .elf file."
    echo "Usage $0 [debug] <.elf file>"
    exit -1
fi

if [ ! -x /usr/bin/expect ]; then
    echo "Missing expect."
    echo "Install e.g. sudo apt install expect"
    exit -3
fi


if [ -d $HOME/Microchip/SoftConsole-v2022.2-RISC-V-747/riscv-unknown-elf-gcc ]; then
    MICROCHIP_TOOLS=$HOME/Microchip
elif [ -d /opt/Microchip/SoftConsole-v2022.2-RISC-V-747/riscv-unknown-elf-gcc ]; then
    MICROCHIP_TOOLS=/opt/Microchip
else
    echo "Error: Toolchain not found."
    exit -2
fi

SC_HOME="${MICROCHIP_TOOLS}/SoftConsole-v2022.2-RISC-V-747"

OPENOCD_HOME="${SC_HOME}/openocd"
OPENOCD_EXEC=${OPENOCD_HOME}/bin/openocd
OPENOCD_SCRIPTS=${OPENOCD_HOME}/share/openocd/scripts
GDB_EXEC=${SC_HOME}/riscv-unknown-elf-gcc/bin/riscv64-unknown-elf-gdb
GDB_INIT=${SC_HOME}/gdbinit/softconsole.gdbinit


# Prepare temporary GDB script
cat <<EOT > ${THIS_SCRIPT_FULLNAME}.gdb.tmp
set architecture riscv:rv64
set pagination off
file ${ELF_FILE}
set mem inaccessible-by-default off
set \$target_riscv=1
set arch riscv:rv64
source ${GDB_INIT}
target remote localhost:3333
load ${ELF_FILE}
thread apply all set \$pc=_start
thread 1
EOT

if [ $GDB_INTERACTIVE -eq 0 ]; then

    cat <<EOT >> ${THIS_SCRIPT_FULLNAME}.gdb.tmp
detach
quit
EOT

fi


# Prepare temporary Expect interaction script
cat <<EOT > ${THIS_SCRIPT_FULLNAME}.expect.tmp
#!/usr/bin/expect

spawn telnet localhost 4444
expect "Escape character is"
send "shutdown\n"
expect "Connection closed by foreign host."
expect eof

exit 0
EOT


# Run openocd in background
${OPENOCD_EXEC} \
    --search ${OPENOCD_SCRIPTS} \
    --command "set DEVICE MPFS" \
    --file board/microsemi-riscv.cfg \
    --command "init; reset init; sleep 200" &

# Use GDB to load application
if [ $GDB_INTERACTIVE -eq 0 ]; then
    ${GDB_EXEC} --batch --command=${THIS_SCRIPT_FULLNAME}.gdb.tmp
else
    ${GDB_EXEC}         --command=${THIS_SCRIPT_FULLNAME}.gdb.tmp
fi

# Connect to openocd and terminate
/usr/bin/expect ${THIS_SCRIPT_FULLNAME}.expect.tmp

exit 0

# /home/luis/Microchip/SoftConsole-v2022.2-RISC-V-747/openocd/bin/openocd --search /home/luis/Microchip/SoftConsole-v2022.2-RISC-V-747/openocd/share/openocd/scripts/ --command "set DEVICE MPFS" --file board/microsemi-riscv.cfg --command "init; reset halt; sleep 200"

# /opt/Microchip/SoftConsole-v2022.2-RISC-V-747/openocd/bin/openocd --search /opt/Microchip/SoftConsole-v2022.2-RISC-V-747/openocd/share/openocd/scripts/ --command "set DEVICE MPFS" --file board/microsemi-riscv.cfg --command "init; reset halt; sleep 200"