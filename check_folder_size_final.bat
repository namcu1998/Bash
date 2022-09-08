#! bin/env bash

WIDTH=$(tput cols)
nnHEIGHT=$(tput lines)
regex="[0-9]+[G]"
path=/c

renderLine() {
    for (( l=0; l<$WIDTH; l++ )) ; do
        printf "-"
    done
    echo -e "\n"
}

check_number() {
	local _number=$1
	number_regex="^[0-9]"
	
	if [[ $_number =~ $number_regex ]] ; then
		return
	fi
	
	main
}

scan_disk() {
	echo "Scaning disk"
	df > disk.txt

	list_disk_path=("/c")

	while read line ; do

		string_split=$(echo $line | tr " " "\n" | tail -1)
		if [[ $string_split == 'on' || $string_split == '/' ]] ; then continue; fi
		list_disk_path+=($string_split)

	done < disk.txt

	clear

	for ((i=0 ; i<${#list_disk_path[@]} ; i++)) ; do
		printf "%d: %s\n" $i  ${list_disk_path[$i]}
	done

	read -p "Choose disk: " index

	path=${list_disk_path[$index]}
}

check_folder_size(){
	local path=$1

	if ! [[ -d $path ]] ; then
		echo -e "\033[31mPath not exist\033[0m"
		
		return
	fi
	
	cd "$path"
	echo $(pwd)
	echo -e "\033[33mWaiting...\033[0m"

	ls -d */ > ${path}/list_foler.txt

	current_heigth=0
	
	clear
	
	while read line ; do
		folder_name=$(echo $line | tr -d '/')
		if [[ $folder_name == "Windows" ]] ; then continue; fi
		data=$(du -sh "$folder_name" 2> /dev/null)
		folder_size=$(echo $data | tr ' ' '\n' | head -n 1)

		if [[ $folder_size =~ $regex ]] ; then
			printf "\033[32mFolder name: %s\nFolder size: %s\033[0m\n" \
			"${folder_name}" \
			${folder_size}
			renderLine
		fi
	done < ${path}/list_foler.txt
	
	echo "Enter to close"
	read

    
}

main() {
	echo -e "1: Chọn phân vùng\n"
	echo -e "2: Nhập đường dẫn\n"
	
	read -p "Chọn thao tác: " result
	
	check_number $result
	
	if (( $result == 1 )) ; then
	
		scan_disk
		check_folder_size $path
		return
	fi
	
	read -p "Nhập đường dẫn: " p
	
	check_folder_size $p
}

main
