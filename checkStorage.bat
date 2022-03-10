#! /bin/bash
source $(pwd)/color.sh

oldpath=("/sdcard" "/storage/44DC-1DF6/")
oldname=("Bộ nhớ trong" "Thẻ nhớ")
re='^[1-3]$'

checkFolderExist() {
	for ((i=0; i<${#oldpath[@]}; i++)) ; do
		if [[ -d ${oldpath[$i]} ]] ; then
			path+="${oldpath[$i]}"
			name+="${oldname[$i]}"
		fi
	done
}

statusOfStorage() {
	for((i=0; i<${#path[@]}; i++)) ; do
		usedPercent=$(df -h ${path[$i]} | tr " " "\n" | tail -n 10 | grep %)

		size=$(df -h ${path[$i]} | tr " " "\n" | tail -n 10 | grep G | head -n 1)

		used=$(df -h ${path[$i]} | tr " " "\n" | tail -n 10 | grep G | head -n 2 | tail -n 1)

		available=$(df -h ${path[$i]} | tr " " "\n" | tail -n 10 | grep G | tail -n 2 | tail -n 1)

		printf "${BLUE}${name[$i]}${RESET}\n"
		A "Đã sử dụng: ${used}/${size}"
		A "Còn trống: ${available}"
		renderLine
	done
}

fileListOfTheLargest() {
	A "Waiting..."
	cd /sdcard

	fullName=()
	fileSize=()

	number=1048576
	for ((i=0 ; i < 6 ; i++))
	do
	  fullName+=("$(sudo find . -type f ! -path "./Android/*" -printf "%s\t%p\n" | sort -h | tail -n $i | head -1)")
	  fileSize+=("$(sudo find . -type f ! -path "./Android/*" -printf "%s\t%p\n" | sort -h | tail -n $i | head -1 | awk '{print $1}')")
	done

	for ((i1=1 ; i1 < 6 ; i1++))
	do
	  length=(${#fileSize[$i1]} + 10 - ${#fileSize[$i1]})
	  sizeMb=`echo "scale=0;${fileSize[$i1]} / $number" | bc `
	  fileName=${fullName[$i1]:${length}}
	  echo -e "${YELLOW}Top $i1${RESET}"
	  echo -e  "${BLUE}Size: ${sizeMb}Mb${RESET}"
	  echo -e  "${GREEN}File path: $fileName${RESET}"
	  renderLine
	done
}

folderSize() {
	echo ${path[@]}
	for((i=0; i<${#path[@]}; i++)) ; do
		A "${name[$i]}"
		cd ${path[$i]}
		total=$(sudo du -h -d 1 | sort -r -h \
		| head -n +1 | sed 's/\.//' \
		| sed 's/ //')

		A "Tổng kích cỡ: ${total}"
		sudo du -h -d 1 | sort -r -h \
		| sed '1d' | head -n 10
		renderLine
	done
}

main() {
	A "Check folder exist"
	checkFolderExist
	A "(1): Kiểm tra tình trạng bộ nhớ"
	A "(2): Tìm những tập tin có dung lượng lớn"
	A "(3): Kiểm tra kích cỡ thư mục"
	Q "Chọn phương án: "
	read number

	if ! [[ $number =~ $re ]] ; then
		printf "Nhập số từ 1-3"
		exit
	fi

	case $number in
		1)
			statusOfStorage
			;;
		2)
			fileListOfTheLargest
			;;
		3)
			folderSize
			;;
		*)
			statusOfStorage
			;;
	esac
}

main
