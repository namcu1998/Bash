#! /bin/bash

curl -s https://api.covid19api.com/live/country/viet-nam/status/confirmed > data.json

length=`cat data.json | jq 'length'`

yesterday=()

key=("Confirmed" "Deaths" "Recovered" "Active" "Date")

for (( d=0; d<${#key[@]}; d++ ))
do
  yesterday+=("$(cat data.json | jq ".[length - 2]."\"${key[$d]}"\"")")
  today+=("$(cat data.json | jq ".[length - 1]."\"${key[$d]}"\"")")
done

formatDate=($(echo ${yesterday[4]:1:-11} | tr "-" "\n"))
formatDate1=($(echo ${today[4]:1:-11} | tr "-" "\n"))

nguoiNhiem=$((${today[0]}-${yesterday[0]}))

echo -e "\tThống kê số liệu người nhiễm covid"
echo -e "Ngày: ${formatDate[2]}-${formatDate[1]}-${formatDate[0]}"
echo -e "Tổng số ca nhiễm: ${yesterday[0]}"
echo -e "Bình phục: ${yesterday[2]}"
echo -e "Chết: ${yesterday[1]}"
echo -e "Đang nhiễm: ${yesterday[3]}"

echo -e "\t------------------------------------------"
echo -e "Ngày: ${formatDate1[2]}-${formatDate1[1]}-${formatDate1[0]}"
echo -e "Tổng số ca nhiễm: ${today[0]}"
echo -e "Bình phục: ${today[2]}"
echo -e "Chết: ${today[1]}"
echo -e "Đang nhiễm: ${today[3]}"

echo -e "Số người nhiễm hôm nay: ${nguoiNhiem}"

echo -e "\t\tEnter to exit"
read nam
