#!/bin/env bash
source $(pwd)/color.sh

clear

_noc=1000

_time=${1:-1}

_battery_path=/sys/class/power_supply/battery
_thermal_path=/sys/devices/virtual/thermal

colorName() {
    local _name=$@
    printf "%s" ${_name}
}

colorValueUP() {
    local _max_value=$1
    local _value=$2
    local _unit=$3

    if (( $(echo "${_value} >= ${_max_value}" | bc -l ) )) ; then
        echo -en "${_value}${_unit}"
    else
        echo -en "${_value}${_unit}"
    fi
}

colorValueDOWN() {
     local _max_value=$1
     local _value=$2
     local _unit=$3

     if (( $(echo "${_value} >= ${_max_value}" | bc -l )
)) ; then
        echo -en "${_value}${_unit}"
     else
        echo -en "${_value}${_unit}"
      fi
}

while [[ true ]]
do
	_cpu_temp=$(sudo cat ${_thermal_path}/thermal_zone7/temp)
	_battery_capacity=$(sudo cat ${_battery_path}/capacity)
	_battery_temp=$(sudo cat ${_battery_path}/temp)
	_battery_voltage=$(sudo cat ${_battery_path}/voltage_now)
    _battery_current=$(sudo cat ${_battery_path}/current_now)
    _current=$(( _battery_current / _noc ))

    _b_t=$(( _battery_temp / 10 ))

    _total_ram=$(free -h | sed 's/  //g' | tail -n 2 | head -1 | tr ' ' '\n' | sed '1d' | sed '1,2!d' | head -1)

    _used_ram=$(free -h | sed 's/  //g' | tail -n 2 | head -1 | tr ' ' '\n' | sed '1d' | sed '1,2!d' | sed '1d')

    _voltage=$( echo "scale=3;${_battery_voltage} / 1000000" | bc )

    _gpu_load=$( sudo cat /sys/devices/soc/5000000.qcom,kgsl-3d0/devfreq/5000000.qcom,kgsl-3d0/gpu_load)

    cpu_now=($(sudo head -n1 /proc/stat))
    cpu_sum="${cpu_now[@]:1}"
    #echo $cpu_sum
    cpu_sum=$((${cpu_sum// /+}))
    cpu_delta=$((cpu_sum - cpu_last_sum))
    cpu_idle=$((cpu_now[4]- cpu_last[4]))
    cpu_used=$((cpu_delta - cpu_idle))
    cpu_usage=$((100 * cpu_used / cpu_delta))
    cpu_last=("${cpu_now[@]}")
    cpu_last_sum=$cpu_sum

    printf "\033[1;1H\033[2K%s %s | %s %s | %s %s | %s %s" \
    $(colorName "A:") \
    $(colorValueUP 1000 ${_current} "mA") \
    $(colorName "V:") \
    $(colorValueDOWN "3.6" ${_voltage} "V") \
    $(colorName "BT:") \
    $(colorValueUP 40 ${_b_t} "°C") \
    $(colorName "GPU:") \
    $(colorValueUP 50 ${_gpu_load} "%")
    printf "\033[2;1H\033[2K%s %s | %s %s | %s %s | %s %s" \
    $(colorName "RAM:") \
    $(colorName "${_used_ram}/${_total_ram}") \
    $(colorName "CPU:") \
    $(colorValueUP 50 ${cpu_usage} "%") \
    $(colorName "T:") \
    $(colorValueUP 40 ${_cpu_temp} "°C") \
    $(colorName "PIN:") \
    $(colorValueDOWN 50 ${_battery_capacity} "%")
    sleep ${_time}
done
