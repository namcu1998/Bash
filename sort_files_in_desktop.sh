root="./root"

number_of_dots=100

if ! [[ -d ${root} ]] ; then #Check and init root folder
	mkdir ${root}
fi

if ! [[ -f ${root}/log.txt ]] ; then #Check and init files require
	echo "Log.txt file isn't exist"
	echo "Creating..."
	touch ${root}/log.txt
elif ! [[ -f ${root}/lastlog.txt ]] ; then
	echo "Lastlog.txt file isn't exist"
	echo "Creating..."
	touch ${root}/lastlog.txt
fi

render_line() {
	for ((c=0;c<=${number_of_dots};c++)) ; do
		echo -n "="
	done
}

mapfile -d '' list_file < <(find -maxdepth 1  ! -name "sort.sh" ! -name "sort*" ! -name "*.ini" ! -name "reverse_sort*" ! -name "root*" -print0)

if [[ ${list_file[0]} == "." && ${#list_file[@]} == 1 ]] ; then 
	echo "The desktop doesn't files or folders to sort" 
	exit 
fi

find -maxdepth 1 -type d ! -name "root*" -empty -exec rm {} -rf \; #delete all empty folders


rm ${root}/lastlog.txt  #delete lastlog.txt

for (( i=0;i<${#list_file[@]};i++ )) ; do
	if [[ ${list_file[i]} != "." ]] ; then #Check folder isn't point
	
		if [[ -d ${list_file[i]} ]] ; then #Check that is value folder or file?
			folder_date=$(date +__%m%y -r "${list_file[i]}"  | tr ' ' '\n' | head -n 2 | tail -1)
			folder_name=$(echo "${list_file[i]}" | tr '/' '\n' | tail -1)
			
			if ! [[ -d ${root}/${folder_date}/folder ]] ; then
				echo -e "the folder doesn't exist\nCreate ${root}/${folder_date}/${file_type} folder\n"
				mkdir -p ${root}/${folder_date}/folder
			fi
			
			if [[ -d ${root}/${folder_date}/folder/${folder_name} ]] ; then
				echo -e "Folder was exist in this forder\nProceeding rename..."
				getDay=$(date +%d -r "${list_file[i]}")
				finalName="${folder_name} - ${getDay}"
			else
				finalName=${folder_name}
			fi
			
			echo ${finalName}

			echo -e "\n${folder_name}\t${root}/${folder_date}/folder/${finalName}\t$(date -r "${list_file[i]}")" >> ${root}/log.txt
			echo -e "${root}/${folder_date}/folder/${finalName}" >> ${root}/lastlog.txt
			mv "${list_file[i]}" "${root}/${folder_date}/folder/${finalName}"
			render_line >> ${root}/log.txt
			
			echo -e "yes ${list_file[i]} ${folder_date}/t ${finalName}"
		else
			file_date=$(date +__%m%y -r "${list_file[i]}"  | tr ' ' '\n' | head -n 2 | tail -1)
			file_type=$(echo "${list_file[i]}" | tr '.' '\n' | tail -1)
			file_name=$(echo "${list_file[i]}" | tr '/' '\n' | tail -1)
			printf "%s\n" $(echo "${list_file[i]}" | tr '.' '\n' | tail -1)
			

			if ! [[ -d ${root}/${file_date}/${file_type} ]] ; then
				echo -e "the folder doesn't exist\nCreate ${root}/${file_date}/${file_type} folder\n"
				mkdir -p ${root}/${file_date}/${file_type}
			fi
			
			if [[ -f ${root}/${file_date}/${file_type}/${file_name} ]] ; then
				echo -e "Files was exist in this forder\nProceeding rename..."
				getDay=$(date +%d -r "${list_file[i]}")
				finalName="${file_name} - ${getDay}.${file_type}"
			else
				finalName=${file_name}
			fi
			
			echo ${finalName}
			
			exit
			
			echo -e "\n${file_name}\t${root}/${file_date}/${file_type}\t$(date -r "${list_file[i]}")" >> ${root}/log.txt
			echo -e "${root}/${file_date}/${file_type}/${file_name}" >> ${root}/lastlog.txt
			
			mv "${list_file[i]}" ${root}/${file_date}/${file_type}
			render_line >> ${root}/log.txt
			
		fi
	fi
	
done

#reverse sort
root="./root"

if ! [[ -f ${root}/lastlog.txt ]] ; then
	echo "Lastlog.txt file isn'texist"
	exit
fi

while IFS= read -r file
do
	echo "${file}"
	mv "${file}"  ~/Desktop
done < "${root}/lastlog.txt"
