#!/bin/bash

# Проверка валидности аргументов
if [[ $# != 2 ]]; then
    echo "Error: It is required to provide 2 arguments (number, --mode[--code/--decode]). $# arguments provided." >&2
    exit 1
else
    decimal_number_regex='^[0-9]+$' # # регулярное выражение для непустой сплошной последовательности десятичных цифр
    if ! [[ $1 =~ $decimal_number_regex ]]; then
        echo "Error: Not a number: $1" >&2
        exit 2
    fi
    if ! [[ $2 == "--code" || $2 == "--decode" ]]; then
            echo "Error: Incorrect flag: $2 . Use '--code' or '--decode'." >&2
            exit 3
    fi
    binary_number_regex='^[0-1]+$' # # регулярное выражение для непустой сплошной последовательности двоичных цифр
    if [[ $2 == "--decode" && ! ( $1 =~ $binary_number_regex ) ]]; then
            echo "Error: Incorrect binary number for decoding: $1" >&2
            exit 4
    fi
fi

# Считываем цифры вводного числа в массив по одной и считаем длину массива
while read -n 1 digit; do
    digits+=($digit)
done <<< "$1"
input_num_length=${#digits[@]}


case "$2" in
--code)
    for (( i = 0; i < input_num_length; i++ )); do
        # Берем десятичную цифру и переводим ее в двоичное представление с помощью калькулятора bc
        current_decimal_digit=$((${digits[$i]}))
        binary_num_from_digit=$(echo "obase=2; $current_decimal_digit" | bc) # d

        # Считываем отдельные биты двоичного представления десятичной цифры в массив и считаем его длину
        while read -n 1 bit; do
            binary_digits+=($bit)
        done <<< "$binary_num_from_digit"
        binary_num_from_digit_length=${#binary_digits[@]} # k

        # Записываем нули и единицу
        for (( j = 0; j < $(( $binary_num_from_digit_length - 1 )); j++ )); do
            echo -n "0"
        done
        echo -n "1"
        # Записываем биты десятичной цифры в прямом порядке, крайний правый бит это младший значащий
        echo -n "$binary_num_from_digit"

        # Очищаем локальные переменные перед переходом на следующую итерацию цикла
        unset current_decimal_digit binary_num_from_digit binary_num_from_digit_length bit binary_digits
    done
    echo # \n
    ;; # выход из switch-case`а


--decode)
    for (( i = 0; i < $input_num_length; )); do
        bit_count=1 # Счетчик значащих битов текущей десятичной цифры
        while (( ${digits[$i]} == "0" )); do
            (( bit_count++ ))
            (( i++ )) # проходим нули
        done
        (( i++ )) # проходим единицу

        # Считываем двоичное представление десятичной цифры числа
        for (( j = 0; j < bit_count; j++ )); do
            current_decimal_digit_bits=$current_decimal_digit_bits${digits[$i]}
            (( i++ ))
        done
        
        # С помощью все того же калькулятора bc переводим в десятичную форму
        decimal_digit=$(echo "ibase=2; $(( $current_decimal_digit_bits ))" | bc)
        echo -n "$decimal_digit"

        unset decimal_digit current_decimal_digit_bits
    done
    echo # \n
    ;; # выход из switch-case`а
esac

exit 0

###
# С данным процессом исходная строка «10111213» становится: «11101111110110110111» 
# в результате объединения 11 10 11 11 11 0110 11 0111.
###