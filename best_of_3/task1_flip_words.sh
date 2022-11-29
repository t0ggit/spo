#!/bin/bash

read -r -a words <<< $@
# -r option to disable escape character '\'
# -a option to sequentially read words into array 'words' using default IFS
# "$@" is the list of all parameters

# Number of words in array 'words'
words_count=${#words[@]}

# Printing words in reversed order
for ((i=$words_count-1; i >= 0; i--)); do
	echo -n "${words[$i]}"
	# -n option to disable \n appending

	# Printing the separator between words except the last one
	if [[ $i != 0 ]]; then
		echo -n " "
	fi
done

echo # \n
exit 0