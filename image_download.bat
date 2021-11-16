#!/bin/env bash
source ~/color.sh

_n_o_i=0

getInformation() {
  Q 'Enter url: '
  read url
  checkUrl '$url'
  printf "${PURPLE}Get information${RESET}\n"
  wget -O html $url &> /dev/null
  noi=($(cat html | grep quickload | tr '&' '\n' | sed -e '1~2d' -e 's/quickload=//g' -e 's/ //g'))
  printf "${GREEN}Number of image: %d${RESET}\n" ${noi}
  if (( ${noi} % 30 == 0 )) ; then
    nop=$(( ${noi} / 30 ))
  else
    nop=$(( ${noi} / 30 + 1 ))
  fi
  printf "${GREEN}Number of page: %d${RESET}\n" ${nop}
  checkFolderExist
  downloadImage "${url}" ${nop} ${noi}
}

checkFolderExist() {
if [ -d "/sdcard/anh" ]; then
  cd /sdcard/anh
else
  mkdir /sdcard/anh && cd $_
fi
}

downloadImage() {
  local _url=$1
  local _nop=$2
  local _noi=$3
  
  for (( i=1; i<=${_nop}; i++ )) ; do
    content=()
    id=()
    fileType=()
    dataSever=()
    number=0
#    printf "${_url}&page=${i}\n" 
    wget -O html "${_url}&page=${i}" &> /dev/null
    cat html | grep data-user-id > data.txt
#    printf "%d\n" ${}
    
    numberOfLine=$(wc -l data.txt | awk '{print $1}')
#	printf ${numberOfLine}
    for (( a=1; a<=$numberOfLine + 1; a++ ))
    do
     dataSever+=("$(cat data.txt | tail -${number} | head -n 1 | tr " " "\n" | grep . | tail -2 | head -n 1 | tr "\"" "\n" | grep . | tail -1 | head -n 1)")
     
     fileType+=("$(cat data.txt | tail -${number} | head -n 1 | tr " " "\n" | grep . | tail -3 | head -n 1 | tr "\"" "\n" | grep . | tail -1 | head -n 1)")
     
     id+=("$(cat data.txt | tail -${number} | head -n 1 | tr " " "\n" | grep . | tail -4 | head -n 1 | tr "\"" "\n" | grep . | tail -1 | head -n 1)")
          
      number=$(($number + 1))
    done
#    echo ${id[@]}
#    echo ${#dataSever[@]}
#    echo ${#fileType[@]}
#    echo $number
    
    for (( b=0; b<${#id[@]}; b++ )) ; do
      #curl "https://initiate.alphacoders.com/download/wallpaper/${id[$b]}/${dataSever[$b]}/${fileType[$b]}/" > ${id[$b]}.${fileType[$b]}
			_n_o_i=$(( _n_o_i + 1 ))
			per=$(( _n_o_i * 100 / _noi ))
#			printf "Noi: %d | Per: %d%% | Nop: %d\n" \
#			${_n_o_i} \
#			${per} \
#			${i}
			progress ${per}
      wget -O ${id[$b]}.${fileType[$b]} "https://initiate.alphacoders.com/download/wallpaper/${id[$b]}/${dataSever[$b]}/${fileType[$b]}/" &> /dev/null
    done
  done
}

getInformation




