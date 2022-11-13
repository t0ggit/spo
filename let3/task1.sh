#!/bin/bash

function find_letter() {
	letter=$1
	string=$2
	str_size=${#string}
	for (( i=0; i<$str_size; i++ )); do
		if [[ $letter == ${string:$i:1} ]]; then
			return $i
		fi
	done
	return -1
}

read -r -a words <<< $@
# -r option to disable escape character '\'
# -a option to sequentially read words into array 'words' using default IFS
# "$@" is the list of all parameters

# Number of words in array 'words'
words_count=${#words[@]}

# Parameter validity check
if [[ $words_count != 2 ]]; then
	echo "Error: It is required to provide 2 strings, not $words_count strings." >&2
	exit 1
fi


a=${words[0]}
b=${words[1]}

alphabet="abcdefghijklmnopqrstuvwxyz"
#  лучше сделть маску из 26? нолей, и уже в ней менять ноль на единицу при нахождении буквы



exit 0
