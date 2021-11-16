#!/usr/bin/env bash

source $(pwd)/color.sh

checkSongExist() {
	cd /sdcard/Music
	Q "Enter song name: "
	read  songName
	checkInput "$songName" checkSongExist

	mapfile -d '' nameArray < <(find . -type f -iname "*$songName*" -print0)
#	echo ${#nameArray}
        if [ ${#nameArray} -gt 0 ]
        then
                error 'Song exist'

		for ((a=0; a<${#nameArray[@]}; a++)) ; do
			A "${nameArray[$a]}"
			renderLine
		done
		Q "Continue(y/n): "
		read answer
		checkInput "$answer" checkSongExist
		if [[ $answer == "y" ]] ; then
			chooseMusicFolder
		else
			checkSongExist
		fi
        else
                renderLine
                chooseMusicFolder
        fi
}

downloadSong() {
	Q "Enter url: "
	read url
	checkInput "$url" downloadSong
	checkUrl "$url" downloadSong
	A "Download song from $url"
	youtube-dl --ignore-errors --format bestaudio --extract-audio --audio-format mp3 --audio-quality 160K --output "%(title)s.%(ext)s" $url
	clear
	checkSongExist
}

checkInteger() {
	re='^[0-9]+$'

	if ! [[ $1 =~ $re ]] ; then
		error 'Not a number'
		$3
	elif (( $number < 0 || $number > $2 )) ; then
                error 'hmm again'
                $3
	fi
}

checkInput() {
	if [[ $1 == '' ]] ; then
		error 'Enter text'
		$2
	elif [[ ${1:0:1} == *.* ]] ; then
		error 'Special characters'
		$2
	fi
}

checkUrl() {
	regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'

	if [[ $1 =~ $regex ]]
	then
		return 0
	else
		error 'Link not valid'
		$2
	fi
}

chooseMusicFolder() {
	A  "1: Choose folder Music"
	A "2: New folder"
	A "3: back"
	Q "Select the number to choose: "
	read number
	checkInput "$number" chooseMusicFolder
	checkInteger $number 3 chooseMusicFolder
	if (( $number == 1 )) ; then
#		echo "chosse 1"
		mapfile -d '' array < <(find -type d ! -path "*/\.*" -print0)

		for (( i=1; i<${#array[@]}; i++ )) ; do
				A "$i: ${array[$i]}"
		done

		Q "Chosse folder: "
		read n
		checkInput "$n" chooseMusicFolder
		checkInteger $n ${#array[@]} chooseMusicFolder
		A "you are choose folder ${array[$n]:2}"
		cd ${array[$n]:2}
		A $(pwd)
		renderLine
		downloadSong
	elif (( $number == 2)) ; then
#		echo "chosse 2"
		Q "Enter folder name: "
		read folderName
		checkInput "$folderName" chooseMusicFolder
		isExist=$(find -type d -name $folderName)
		if (( ${#isExist} > 0 )) ; then
			error 'Folder exist'
			chooseMusicFolder
		else
			A "Created folder"
			mkdir $folderName
			cd $folderName
			A $(pwd)
			renderLine
			downloadSong
		fi
	else
		clear
		checkSongExist
	fi
}

checkSongExist

