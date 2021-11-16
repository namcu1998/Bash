#!/bin/bash
echo "delete text.txt (y/n) ?"
read input
if [ $input == "y" ]
then
rm text.txt -rf
fi

pinOld=0

while command
do
 number=1000
  nam=$(sudo cat /sys/class/thermal/thermal_zone0/temp)
  pin=$(sudo cat /sys/class/power_supply/battery/device/power_supply/battery/capacity)
  nam1=`expr $nam / $number`
  time=$(date)

 numberPin=100

if [ $pin != $pinOld ]
then
  pinOld=("$pin")
  echo "$nam1°C pin $pin % $time" >> text.txt
fi

if [ $pin == $numberPin ]
then
    exit
fi
sleep 1
done
