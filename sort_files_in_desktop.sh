root="./root"

number_of_dots=100

if ! [[ -d ${root} ]] ; then
	mkdir ${root}
fi

render_line() {
	for ((c=0;c<=${number_of_dots};c++)) ; do
		echo -n "="
	done
}

mapfile -d '' list_file < <(find -maxdepth 1 -type f ! -name "sort.sh" -print0)

for ((i=0;i<${#list_file[@]};i++)) ; do
	file_date=$(date +__%m%y -r "${list_file[i]}"  | tr ' ' '\n' | head -n 2 | tail -1)
	file_type=$(echo "${list_file[i]}" | tr '.' '\n' | tail -1)
	file_name=$(echo "${list_file[i]}" | tr '/' '\n' | tail -1)
	printf "%s\n" $(echo "${list_file[i]}" | tr '.' '\n' | tail -1)

	if ! [[ -d ${root}/${file_date}/${file_type} ]] ; then
		echo -e "the folder doesn't exist\nCreate ${root}/${file_date}/${file_type} folder\n"
		mkdir -p ${root}/${file_date}/${file_type}
	fi
	
	echo -e "\n${file_name}\t${root}/${file_date}/${file_type}\t$(date -r "${list_file[i]}")" >> ${root}/log.txt
	
	mv "${list_file[i]}" ${root}/${file_date}/${file_type}
	render_line >> ${root}/log.txt
done
