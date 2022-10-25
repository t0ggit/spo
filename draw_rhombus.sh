#!/bin/bash

re='^[0-9]+$' # regular expression of a non-empty contiguous string of digits
#   ^   means the beginning of string
# [0-9] means the 'digits' category of characters
#   +   means there is one or more characters
#   $   means the end of string

# Parameter validity check
if [[ $# != 1 ]]; then
	echo "Error: It is required to provide only 1 argument, not $# arguments." >&2
	exit 1
else
	if ! [[ $1 =~ $re ]]; then
		echo "Error: Not a number: $1" >&2
		exit 2
	fi
fi

size=$1
placeholder=" " # 'gap'-symbol
symbol="* " # 'filler'-symbol
let "indent=$size-1" # maximum indentation/offset

# Printing of the upper half of the rhombus
for ((i=$indent; i >= 0; i--)); do
	# Printing the indentation of the current line
	for ((k=0; k < $i; k++)); do 
		echo -n "$placeholder"
	done
	
	# Printing symbols of the current line
	let "width=$size - $i"
	for ((j=0; j < $width; j++)); do
		echo -n "$symbol"
	done	
	echo '' # to next line
done

# Printing of the lower half of the rhombus
for ((i=1; i <= $indent; i++)); do
	# Printing the indentation of the current line
	for ((k=0; k < $i; k++)); do
		echo -n "$placeholder"
	done

	# Printing symbols of the current line
	let "width=$size - $i"
	for ((j=0; j < $width; j++)); do
		echo -n "$symbol"
	done
	echo '' # to next line
done

exit 0
