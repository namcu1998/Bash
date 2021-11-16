#! /bin/bash
source $(pwd)/color.sh

usedPercent=$(df -h /sdcard | tr " " "\n" | tail -n 10 | grep %)

size=$(df -h /sdcard | tr " " "\n" | tail -n 10 | grep G | head -n 1)

used=$(df -h /sdcard | tr " " "\n" | tail -n 10 | grep G | head -n 2 | tail -n 1)

available=$(df -h /sdcard | tr " " "\n" | tail -n 10 | grep G | tail -n 2 | tail -n 1)

echo -e " ____________________________________________________________"
echo -e "|\t\t \t   Bộ nhớ trong \t \t \t|"
echo -e "|\t\tused% \t size \t used \t available\t\t|"
echo -e "| \t\t $usedPercent \t $size \t $used \t    $available\t\t\t|"
echo -e "|____________________________________________________________|"

usedPercent1=$(df -h /storage/44DC-1DF6/ | tr " " "\n" | tail -n 10 | grep %)

size1=$(df -h /storage/44DC-1DF6/ | tr " " "\n" | tail -n 10 | grep G | head -n 1)

used1=$(df -h /storage/44DC-1DF6/ | tr " " "\n" | tail -n 10 | grep G | head -n 2 | tail -n 1)

available1=$(df -h /storage/44DC-1DF6/ | tr " " "\n" | tail -n 10 | grep G | tail -n 2 | tail -n 1)

echo -e " ____________________________________________________________"
echo -e "|\t\t \t     Thẻ nhớ \t \t \t \t|"
echo -e "| \t\t used% \t size \t used \t available\t\t|"
echo -e "| \t\t  $usedPercent1 \t $size1 \t $used1 \t    $available1\t\t\t|"
echo -e "|____________________________________________________________|"

echo -e "\t    List file have size biggest in sdcard"

cd /sdcard

fullName=()
fileSize=()

number=1048576
for ((i=0 ; i < 6 ; i++))
do
  fullName+=("$(sudo find . -type f -printf "%s\t%p\n" | sort -h | tail -n $i | head -1)")
  fileSize+=("$(sudo find . -type f -printf "%s\t%p\n" | sort -h | tail -n $i | head -1 | awk '{print $1}')")
done

for ((i1=1 ; i1 < 6 ; i1++))
do
  length=(${#fileSize[$i1]} + 10 - ${#fileSize[$i1]})
  sizeMb=`echo "scale=0;${fileSize[$i1]} / $number" | bc `
  fileName=${fullName[$i1]:${length}}
  echo -e "\t\t\t    Top $i1"
  echo -e "\t\t\tSize: \t ${sizeMb}Mb"
  echo -e "File path \t $fileName"
  echo -e "\t____________________________________________"
done

echo -e "\t\t\tinformation storage"
cd /sdcard
du -h -d 1 | sort -r -h | head -n 5
echo -e "\t\t\tinformation-sdcard"
cd /storage/44DC-1DF6
sudo du -h -d 1 | sort -r -h | head -n 5

echo "Enter to exit"
read exit
exit
