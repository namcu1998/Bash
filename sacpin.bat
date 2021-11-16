#!/bin/env bash

_battery_path=/sys/class/power_supply/battery

batteryCurrent=$(sudo cat "${_battery_path}/capacity")

for (( i=batteryCurrent; i <= 100; i++ )) ; do
	sudo echo $i | sudo tee "${_battery_path}/capacity" &> /dev/null
done
