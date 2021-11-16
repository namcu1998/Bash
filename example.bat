#! /bin/bash
count=0
for (( d=1; d<=137; d++ ))
do 


  content=()
  id=()
  fileType=()
  dataSever=()
  
  number=1


  curl "https://wall.alphacoders.com/search.php?search=fate+stay+night&page=${d}" | grep data-user-id > data.txt
  
  numberOfLine=$(wc -l data.txt | awk '{print $1}')


  for (( a=1; a<=$numberOfLine + 1; a++ ))
  do
   dataSever+=("$(cat data.txt | tail -${number} | head -n 1 | tr " " "\n" | grep . | tail -2 | head -n 1 | tr "\"" "\n" | grep . | tail -1 | head -n 1)")
   
   fileType+=("$(cat data.txt | tail -${number} | head -n 1 | tr " " "\n" | grep . | tail -3 | head -n 1 | tr "\"" "\n" | grep . | tail -1 | head -n 1)")
   
   id+=("$(cat data.txt | tail -${number} | head -n 1 | tr " " "\n" | grep . | tail -4 | head -n 1 | tr "\"" "\n" | grep . | tail -1 | head -n 1)")
        
    number=$(($number + 1))
  done


    echo ${id[@]}
    echo ${dataSever[@]}
    echo ${#id[@]}
    echo ${fileType[@]}
    echo $number




 if [ -d "/sdcard/anh" ]; then
  echo "next"
else
  mkdir /sdcard/anh && cd $_
fi
    
    for (( b=1; b<=${#id[@]}; b++ ))
    do  
    count=$(($count + 1))
    echo -e "number of page: ${d}"
    echo -e "number of image: ${count}"
      curl "https://initiate.alphacoders.com/download/wallpaper/${id[$b]}/${dataSever[$b]}/${fileType[$b]}/" > ${id[$b]}.${fileType[$b]}
    done

done;





