#! /bin/env bash

WORKING_DIR=$(pwd)
WORKING_DIR_INPUT="/d/Form/Service Form"

upperText() {
    echo $1 | tr [:lower:] [:upper:]
}

[[ ! -d ${WORKING_DIR} ]] && exit

typeOfService=("Maintenance" "Calibration" "Maintenance & Calibration")

for ((i = 0; i < ${#typeOfService[@]}; i++)); do
    echo -e "${i}: ${typeOfService[i]}\n"
done

read -p "Choose type of service: " tos
read -p "Type customer name: " cn
read -p "Type date (today default): " d

! (( ${d} )) && d=$(date +%Y%m%d)

upperText "${typeOfService[tos]} - ${cn} - ${d}"
folderName=$?

echo $folderName

echo "${WORKING_DIR}/${folderName}"


