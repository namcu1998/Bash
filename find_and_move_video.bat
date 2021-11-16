#!/bin/bash
storageMemoryStick="/storage/44DC-1DF6"

folderScan[0]="/sdcard/Download"
folderScan[1]="/sdcard/DCIM/Camera"

DirectoryPath=("video")

echo "check if the directory exists"
for ((i=0 ; i < ${#DirectoryPath[@]} ; i++));
do
    if [ -d "${storageMemoryStick}/${DirectoryPath[$i]}" ];
    then
        echo "directory ${DirectoryPath[$i]} exist"
    else
        echo "directory ${DirectoryPath[$i]} not exist"
        sudo mkdir ${storageMemoryStick}/${DirectoryPath[$i]}
    fi
    sleep 1
done

echo "find and move to derectory memory stick"
for ((i1=0 ; i1 < ${#folderScan[@]} ; i1++));
do
    if [ -d "${folderScan[$i1]}" ];
    then                                                              cd ${folderScan[$i1]}                                         echo "scanning image in folder ${folderScan[$i1]}"
        for ((i2=0 ; i2 < ${#DirectoryPath[@]} ; i2++));
        do                                                                sudo find -name "*.mp4" -exec mv {} ${storageMemoryStick}/${DirectoryPath[$i2]} \;
        done
    fi
    sleep 1
done
