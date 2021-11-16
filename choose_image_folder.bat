#!/bin/bash

#-not -path "./Android/*"
                                                              cd /storage/44DC-1DF6/Pictures/

sudo find . -type d | tee ~/data.txt > /dev/null

length=`wc -l ~/data.txt | awk '{print $1}'`

#echo $length

path=()

for((i=1;i<$length;i++))
do

numberOfImages=`sudo find "$(cat ~/data.txt | tail -$i | head -n 1)" -type f -name "*.jpg"`

#echo `cat ~/data.txt | tail -$i | head -n 1`

#echo ${#numberOfImages}

if((${#numberOfImages} > 0)); then

path+=("$(cat ~/data.txt | tail -$i | head -n 1)")

#echo "have image in folder"

fi

done

select os in ${path[@]}
do
 echo "$os" > ~/config.txt
 exit
done
