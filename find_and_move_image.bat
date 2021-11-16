#!/bin/env bash

source $(pwd)/color.sh

C="/sdcard"
D="/storage/44DC-1DF6"
mif="${D}/Pictures/mobile_image"
cif="${D}/Pictures/computer_image"
wif="${D}/Pictures/watch_image"
size=(
	"-size -1024k"
	"-size +1024k -size -2048k"
	"-size +2048k -size -5120k"
	"-size +5120k -size -10240k"
	"-size +10240k"
)

mainImageFolder=(
	"anhchatluongthap"
	"anhthuong"
	"anhdep"
	"anhsieudep"
	"anhsieusieudep"
)

imageFolder=(
	"${C}/.folder_center/mobile_image"
	"${C}/.folder_center/computer_image"
	"${C}/.folder_center/watch_image"
)

cd ${C}

A "Check folder exist"

if ! [[ -d $mif ]] ; then
	error "$mif not exist"
	A "Create folder $mif"
	sudo mkdir $mif
	A "Done"
fi

if ! [[ -d $cif ]] ; then
	error "$cif not exist"
    A "Create folder $cif"
    sudo mkdir $cif
    A "Done"
fi

if ! [[ -d $wif ]] ; then
	error "$wif not exist"
    A "Create folder $wif"
    sudo mkdir $wif
    A "Done"
fi

sleep 1

for ((b=0 ; b < ${#mainImageFolder[@]} ; b++));
do
	renderLine

	if [ -d "${mif}/${mainImageFolder[$b]}" ];
	then
		A "${mif}/${mainImageFolder[$b]} exist"
	else
		error "${mif}/${mainImageFolder[$b]} not exist"
		A "create folder ${mainImageFolder[$b]}"
		sudo mkdir ${mif}/${mainImageFolder[$b]}
	fi

	if [ -d "${cif}/${mainImageFolder[$b]}" ];
	then
		A "${cif}/${mainImageFolder[$b]} exist"
	else
		error "${cif}/${mainImageFolder[$b]} not exist"
		A "create folder ${mainImageFolder[$b]}"
		sudo mkdir ${cif}/${mainImageFolder[$b]}
	fi

	if [ -d "${wif}/${mainImageFolder[$b]}" ];
	then
		A "${wif}/${mainImageFolder[$b]} exist"
	else
		error "${wif}/${mainImageFolder[$b]} not exist"
		A "create folder ${mainImageFolder[$b]}"
		sudo mkdir ${wif}/${mainImageFolder[$b]}
	fi
done

renderLine

A "Sort image"

sizeLength=${#size[@]}

printf "Path: %s" $(pwd)

for ((i=0 ; i < ${#imageFolder[@]} ; i++));
do
  for ((a=0 ; a < $sizeLength ; a++))
  do
	nof=$(( nof + 1 ))
	per=$(( ( $nof ) * 100 / ( ${#imageFolder[@]} * $sizeLength )))
        progress $per
	if (( $i == 0 )) ; then
		sudo find ${imageFolder[$i]} -type f \( -name "*.jpg*" -o -name "*.jpeg*" -o -name "*.png" \) ${size[$a]} -exec mv {} ${mif}/${mainImageFolder[$a]} \;
	else
		sudo find ${imageFolder[$i]} -type f \( -name "*.jpg" -o -name "*.jpeg*" -o -name "*.png" \) ${size[$a]} -exec mv {} ${cif}/${mainImageFolder[$a]} \;
	  fi
  done
done
