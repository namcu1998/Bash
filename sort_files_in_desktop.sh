root="./root"

number_of_dots=100

currentDate=$(date +%Y%m%d)
nameLog="20230404 - log.txt" #${currentDate}

if ! [[ -d ${root} ]] ; then #Check and init root folder
	mkdir ${root}
elif ! [[ -d ${root}/LogHistory ]] ; then
	echo "LogHistory folder isn't exist"
	echo "Creating..."
	mkdir ${root}/LogHistory 
fi

if ! [[ -f ${root}/log.txt ]] ; then #Check and init files require
	echo "Log.txt file isn't exist"
	echo "Creating..."
	touch ${root}/log.txt
fi

render_line() {
	for ((c=0;c<=${number_of_dots};c++)) ; do
		echo -n "="
	done
}

find -maxdepth 1 -type d ! -name "root*" -empty -delete #delete all empty folders

mapfile -d '' list_file < <(find -maxdepth 1  \
! -name "causation.sh" ! -name "*.ini" ! -name "reverse_causation.sh" \
! -name "root*" ! -name "Server*" ! -name "flask_admin*" \
-print0)

if [[ ${list_file[0]} == "." && ${#list_file[@]} == 1 ]] ; then 
	echo "The desktop doesn't files or folders to sort" 
	exit 
fi

if ! [[ -f ${root}/LogHistory/${nameLog} ]] ; then #Check and init DayLog
	echo "${nameLog}  file isn't exist"
	echo "Creating..."
	touch "${root}/LogHistory/${nameLog}"
fi

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
				echo -e "\n${folder_name} was exist in ${root}/${folder_date}/folder forder\nProceeding rename..." >> ${root}/log.txt
				getDay=$(date +%d -r "${list_file[i]}")
				finalName="${folder_name} - ${getDay}"
			else
				finalName=${folder_name}
			fi
			
			echo ${finalName}

			echo -e "\n${folder_name}\t${root}/${folder_date}/folder/${finalName}\t$(date -r "${list_file[i]}")" >> ${root}/log.txt
			echo -e "${root}/${folder_date}/folder/${finalName}" >> "${root}/LogHistory/${nameLog}"
			mv "${list_file[i]}" "${root}/${folder_date}/folder/${finalName}"
			render_line >> ${root}/log.txt
			
			echo -e "yes ${list_file[i]} ${folder_date}/t ${finalName}"
		else
			file_date=$(date +__%m%y -r "${list_file[i]}"  | tr ' ' '\n' | head -n 2 | tail -1)
			file_type=$(echo "${list_file[i]}" | tr '.' '\n' | tail -1)
			file_name=$(echo "${list_file[i]}" | tr '/' '\n' | tail -1)
			len_Name=$((${#file_name} - ${#file_type} - 1))
			onlyName=${file_name::len_Name}
			
			if ! [[ -d ${root}/${file_date}/${file_type} ]] ; then
				echo -e "the folder doesn't exist\nCreate ${root}/${file_date}/${file_type} folder\n"
				mkdir -p ${root}/${file_date}/${file_type}
			fi
			
			if [[ -f ${root}/${file_date}/${file_type}/${file_name} ]] ; then
				echo -e "\n${file_name} was exist in path => ${root}/${file_date}/${file_type}\nProceeding rename..." >> ${root}/log.txt
				getDay=$(date +%d -r "${list_file[i]}")
				finalName="${onlyName} - ${getDay}.${file_type}"
				echo -e "\nNew name: ${finalName}\n">> ${root}/log.txt
			else
				finalName=${file_name}
			fi
			
			echo -e "\n${finalName}\t${root}/${file_date}/${file_type}\t$(date -r "${list_file[i]}")" >> ${root}/log.txt
			echo -e "${root}/${file_date}/${file_type}/${finalName}" >> "${root}/LogHistory/${nameLog}"
			
			mv "${list_file[i]}" "${root}/${file_date}/${file_type}/${finalName}"
			render_line >> ${root}/log.txt
			
		fi
	fi
	
done

#reverse sort
root="./root"

mapfile -d "" array < <(find ${root}/LogHistory -type f -name "*.txt" -print0)

for (( i=0;i<${#array[@]};i++ )) ; do
		year=${array[$i]:18:4}
		month=${array[$i]:22:2}
		day=${array[$i]:24:2}
		echo -e "${i}: ${day} - ${month} - ${year}"
done

read -p "Chose date to reverse_causation:" result

echo -e "\nProceed reverse_causation on ${array[${result}]}\n"

while IFS= read -r file
do
	echo "${file}"
	mv "${file}"  ~/Desktop
done < "${array[${result}]}"
