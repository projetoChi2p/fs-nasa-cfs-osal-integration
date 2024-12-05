#!/bin/bash

set -o xtrace
set -e  # -e Exit immediately if a command exits with a non-zero status.


THIS_SCRIPT=${BASH_SOURCE[0]}
THIS_SCRIPT_FULLNAME=$(realpath "$THIS_SCRIPT")
THIS_SCRIPT=$(basename "${THIS_SCRIPT_FULLNAME}")
ROOT_DIR=$(dirname "$THIS_SCRIPT_FULLNAME")

BSPNAME=mpfs-discovery-freertos
HALNAME=polarfire_hal

#cd $ROOT_DIR/osal/src/bsp/${BSPNAME}/${HALNAME}/platform/soc_config_generator

HW_DESIGN_PFSOC_CFG_PATH="/home/work/nn-apsoc-polarfire/fs/hardware_design/pf95_disco_base_2024.1_v0.2/src/fpga_design/mss_configuration"

OUT_PATH="$ROOT_DIR/osal/src/bsp/${BSPNAME}/${HALNAME}/boards/mpfs-discovery-kit-design_v0.2"

mkdir -p "${OUT_PATH}/fpga_design/design_description"
mkdir -p "${OUT_PATH}/fpga_design/mss_configuration"

PFSOC_CFG_FROM="${HW_DESIGN_PFSOC_CFG_PATH}/MPFS_DISCOVERY_KIT_MSS.cfg"
PFSOC_CFG_TO="${OUT_PATH}/fpga_design/mss_configuration/MPFS_DISCOVERY_KIT_MSS.cfg"

PFSOC_CFG_FROM=$(realpath "$PFSOC_CFG_FROM")
PFSOC_CFG_TO=$(realpath "$PFSOC_CFG_TO")
if [ "${PFSOC_CFG_FROM}" != "${PFSOC_CFG_TO}" ] ; then
    cp "${PFSOC_CFG_FROM}" "${PFSOC_CFG_TO}"
fi

PFSOC_XML_FROM="${HW_DESIGN_PFSOC_CFG_PATH}/MPFS_DISCOVERY_KIT_MSS_mss_cfg.xml"
PFSOC_XML_TO="${OUT_PATH}/fpga_design/design_description/MPFS_DISCOVERY_KIT_MSS_mss_cfg.xml"

PFSOC_XML_FROM=$(realpath "$PFSOC_XML_FROM")
PFSOC_XML_TO=$(realpath "$PFSOC_XML_TO")
if [ "${PFSOC_XML_FROM}" != "${PFSOC_XML_TO}" ] ; then
    cp "${PFSOC_XML_FROM}" "${PFSOC_XML_TO}"
fi

rm -rf "${OUT_PATH}/fpga_design_config"

python3 $ROOT_DIR/osal/src/bsp/${BSPNAME}/${HALNAME}/platform/soc_config_generator/mpfs_configuration_generator.py \
    "${PFSOC_XML_TO}" \
    "${OUT_PATH}"
