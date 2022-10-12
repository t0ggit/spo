#!/bin/bash
size=$1
placeholder=" "
symbol="*"
let "indent=$size/2"
echo "      Size: $size"
echo "Max_Indent: $indent"
echo "Your RHOMBUS, please:"

for ((i=$indent; i >= 0; i--))
do
	for ((k=0; k < $i; k++)) 
	do 
		echo -n "$placeholder"
	done
	
	let "width=$size - 2*$i"
	if (($width < 1))
	then
		width=$width+1
	fi
	for ((j=0; j < $width; j++))
	do
		echo -n "$symbol"
	done	
	echo ''	
done

for ((i=1; i < $indent+1; i++))
do
	for ((k=0; k < $i; k++))
	do
		echo -n "$placeholder"
	done
	let "width=$size - 2*$i"
	if (($width < 1))
	then
		width=$width+1
	fi
	for ((j=0; j < $width; j++))
	do
		echo -n "$symbol"
	done
	echo ''
done

exit 0

