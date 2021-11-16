#!/bin/env bash

col=$(tput col)
line=$(tput line)

BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
PURPLE="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"

#backgroundcolor
BLACKB="\033[40m"
REDB="\033[41m"
GREENB="\033[42m"
YELLOWB="\033[43m"
BLUEB="\033[44m"
PURPLEB="\033[45m"
CYANB="\033[46m"
WHITEB="\033[47m"

#bold
B="\033[1m"
BOFF="\033[22m"

#italics
I="\033[3m"
IOFF="\033[23m"

#underline
U="\033[4m"
UOFF="\033[24m"

#invert
R="\033[7m"
ROFF="\033[27m"

#reset
RESET="\033[0m"

error() {
        clear
        echo -e "${RED}error:${RESET} $1"
}

Q() {
        echo -en "$YELLOW$@$RESET"
}

A() {
        echo -e "$BLUE$@$RESET"
}

renderLine() {
for (( c=0; c<${col}; c++ )) ; do
        echo -n "="
done
}

progress() {
	printf "\033[${line};1H\033[2K"
	printf "${YELLOW}%3d%%${RESET}" ${1}
	per=$(( $1 * ( $col - 4 ) / 100 ))
        for ((index=0; index<$per; index++)) ; do
		printf "${WHITEB} ${RESET}"
	done
	if (( $1 == 100 )) ; then
		printf '\n'
	fi
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
