#!/bin/bash

function print_row {
    for (( i=1; i<=N; i++ )) do
        echo -n "${row[$i]} "
    done
    echo
}

re='^[0-9]+$' # регулярное выражение для непустой сплошной последовательности десятичных цифр
#   ^   означает начало строки, то есть перед цифрами никаких символов
# [0-9] означает любую десятичную цифру
#   +   означает, что такая цифра здесь должна быть хотя бы одна или больше
#   $   означает конец строки, то есть после цифр никаких символом

### Проверка валидности аргумента командной строки
if [[ $# != 1 ]]; then
	echo "Error: It is required to provide 1 argument, not $# arguments." >&2
	exit 1
else
	if ! [[ $1 =~ $re ]]; then
		echo "Error: Not a number: $1" >&2
		exit 2
	fi
fi
N=$1
if [[ $N == 0 ]]; then
    exit 0
fi

### Заполнение пустого ряда-очереди нулями
for ((i=1; i<=$N; i++))
do
	row[$i]=0
done

### Для удобства отсчет пациентов начинается с единицы, а не с нуля
current_patient=1


### Первый пациент (всегда на первом стуле)
row[1]=$current_patient
if [[ $N == "$current_patient" ]]; then
    print_row
    exit 0
fi
(( current_patient++ ))


### Второй пациент (всегда на последнем стуле)
row[$N]=$current_patient
if [[ $N == "$current_patient" ]]; then
    print_row
    exit 0
fi
(( current_patient++ ))


### Последующие пациенты
while [ "$current_patient" -lt $((N + 1)) ]; do
    current_max_gap_size=0
    # Перебираем промежутки и запоминаем длину наибольшего промежутка
    current_gap_left=1
    current_gap_right=2
    while [ $current_gap_left != "$N" ]; do
        # Сдвигаем итератор правой границы рассматриваемого промежутка вправо до следующего занятого места
        while [ "${row[current_gap_right]}" == 0 ]; do
            (( current_gap_right++ ))
        done
        # Обновляем максимальную длину промежутка и его левую границу, если этот промежуток больше наибольшего
        if [[ $(( current_gap_right - current_gap_left - 1 )) -gt current_max_gap_size ]]; then
            current_max_gap_size=$(( current_gap_right - current_gap_left - 1 ))
            current_max_gap_left=$current_gap_left
        fi
        ###DEBUG_OUTPUT
#        echo -n "($current_patient) CurrentGap from $current_gap_left to $current_gap_right. "
#        echo "CurrentMaxGapSize $current_max_gap_size. CurrentMaxGapLeft $current_max_gap_left."
        # Приступаем к рассматриванию следующего промежутка
        current_gap_left=$current_gap_right
        (( current_gap_right++ ))
    done
    # Теперь садим текущего пациента в середину наибольшего промежутка
    row[$((current_max_gap_left + (current_max_gap_size + 1) / 2))]=$current_patient
    (( current_patient++ ))
#    print_row
done

print_row
exit 0
