#!/bin/bash
#su -c /system/bin/input keyevent 3

cd /storage/44DC-1DF6/Pictures

config=`cat ~/config.txt`

cd ${config}

mapfile -d '' array < <(sudo find \( -name "*.jpg" -o -name "*.png" \) -print0)

length=$((${#array[@]} - 1))

number=$(shuf -i 0-${length} -n 1)

echo "Number of images: ${#array[@]}"

echo "index of image: $number"

echo "set file ${array[$number]} do wallpaper"

    termux-wallpaper -f "${array[$number]}"
#    termux-notification --content "${array[$number]}"
