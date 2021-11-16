#!/bin/env bash

source $(pwd)/color.sh

inPath="/sdcard/Download"
outPath="/sdcard/.folder_center"

cd $inPath

mi=()
ci=()

printf "${GREEN}Find zip file${RESET}\n"

mapfile -d '' lzf < <(sudo find -type f -iname "*Vì ai*" -print0)
mapfile -d '' lf < <(sudo find -type d -name "*Vì ai*" -print0)

if (( ${#lzf[@]} > 0 && ${#lf[@]} == 0 )) ; then
	for (( z=0; z<${#lzf[@]}; z++ )) ; do
        	unzip "${lzf[$z]}"
	done
fi

echo -e "${YELLOW}Check folder exist$RESET"
if ! [[ -d ${outPath} ]] ; then
		error "Folder ${outPath} not exist"
		mkdir ${outPath}
fi

if ! [[ -d ${outPath}/mobile_image ]] ; then
        error "Folder mobile_image not exist"
        mkdir ${outPath}/mobile_image
fi

if ! [[ -d ${outPath}/computer_image ]] ; then
        error "Folder computer_image not exist"
        mkdir ${outPath}/computer_image
fi

if ! [[ -d ${outPath}/watch_image ]] ; then
		error "Folder watch_image not exist"
		mkdir ${outPath}/watch_image
fi

filterImage() {
  h=$(echo ${1} | tr 'x' '\n' | head -1)
	v=$(echo ${1} | tr 'x' '\n' | tail -n 1 | head -1)
#	echo $h
#	echo $v
	if (( $h > $v )) ; then
#		echo "pc"
		ci+=("$1")
		mv "${2}" ${outPath}/computer_image
	elif (( $h < $v )) ; then
		mi+=("$1")
#		echo "mobile"
		mv "${2}" ${outPath}/mobile_image
	else
#		echo 'watch'
		
	fi
}

mapfile -d '' array < <(find . -type f \
! -path "./Zalo/*" \( -name "*.jpg" -o \
-name "*.png" -o -name "*.jpeg" \)  -print0)

echo -e "${YELLOW}Get resolution of image${RESET}"

for ((i=0; i<${#array[@]}; i++)) ; do
	per=$(( ($i+1) * 100 / ${#array[@]} ))
	progress $per
#	echo ${array[$i]}
	name=`file -b "${array[$i]}" | tr ',' '\n' \
 	| head -1 | tr ' ' '\n' | head -1`
#	echo "============="
#	echo -e $name
#	file "${array[$i]}" -b
	if [[ $name == "JPEG" ]] ; then
#		echo "JPEG"
		ra=$(file "${array[$i]}" | tr ',' '\n'\
		| tail -n 2 | head -1 | sed 's/ //g')
		filterImage $ra "${array[$i]}"
#		echo $ra
	else
#		echo "PNG"
		rb=$(file "${array[$i]}"  | tr ',' '\n' \
		| tail -n 3 | head -1 | sed 's/ //g')
		filterImage $rb "${array[$i]}"
#		echo $rb
	fi
done

printf "Delete empty folder"

find -type d -empty -delete

printf "Delete zip file"

find -type f -name "*.zip" -delete

termux-notification --content "Sort image complete"
