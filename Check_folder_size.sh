#!/bin/bash

WIDTH=$(tput cols)
HEIGHT=$(tput lines)
regex="[0-9]+[G]"

renderLine() {
    for (( l=0; l<$WIDTH; l++ )) ; do
        printf "-"
    done
    echo -e "\n"
}

main() {
	echo -n "Enter to path: "
	read path
	
	if [[ -z $path ]] ; then
		echo "error"
		bash d://nam.sh
	fi
	
	cd "$path"
	echo $(pwd)
	echo -e "\033[33mWaiting...\033[0m"

	ls -d */ > e://list_foler.txt

	current_heigth=0
	
	while read line ; do
		folder_name=$(echo $line | tr -d '/')
		data=$(du -sh "$folder_name" 2> /dev/null)
		folder_size=$(echo $data | tr ' ' '\n' | head -n 1)

		if [[ $folder_size =~ $regex ]] ; then
			printf "\033[32mFolder name: %s\nFolder size: %s\033[0m\n" \
			"${folder_name}" \
			${folder_size}
			renderLine
		fi
	done < e://list_foler.txt
	
	echo "Enter to close"
	read
}

main

