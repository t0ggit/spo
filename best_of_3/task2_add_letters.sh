#!/bin/bash

# Если не поступило аргументов, выводим ответ
if [ $# == 0 ]; then
    echo "z"
    exit 0
fi

result_decimal_sum=0

# Для каждого аргумента производим проверку и, преобразуя букву в число, добавляем его.
for argument in $*; do
    if [ ${#argument} != 1 ]; then
        echo "Error: It is required to provide single letter(s). Provided: $argument" >&2
        exit 1
    fi
    lowercase_letter_regex='[a-z]'
    if ! [[ $argument =~ $lowercase_letter_regex ]]; then
        echo "Error: It is required to provide lowercase letter(s). Provided: $argument" >&2
        exit 2
    fi
    letter_char=$argument
    letter_num_in_ascii=$( printf "%d" "'$letter_char" )
    letter_num=$(( $letter_num_in_ascii - 96 ))
    result_decimal_sum=$(( $result_decimal_sum + $letter_num ))
done

# Предусматриваем переполнение
result_decimal_sum=$(( $result_decimal_sum % 26 ))
if [ $result_decimal_sum == 0 ]; then
    result_decimal_sum=26
fi

# Переводим в ASCII
result_decimal_sum_in_ascii=$(( $result_decimal_sum + 96 ))
# Конвертируем в восьмеричную систему счисления
result_octal_sum_in_ascii=$( printf %o $result_decimal_sum_in_ascii )
# %b интерпретирует все управляющие символы в строке, то есть \141 (восьмеричный код ASCII) превратится в букву
result_sum_char=$( printf %b \\$result_octal_sum_in_ascii ) # printf %b \141 ==> a

echo $result_sum_char
exit 0



#    Task № 2
#    Описание:
#    Ваша задача состоит в том, чтобы сложить буквы и получить третью.
#    Функции передается переменное количество аргументов,
#    каждый из которых представляет собой букву для добавления.
#
#    Описание:
#    -Буквы всегда будут строчными.
#    -Буквы могут переполняться (см. предпоследний пример описания)
#    -Если буквы не указаны, функция должна вернуть 'z'
#
#    Примеры:
#    addLetters('a', 'b', 'c') = 'f'
#    addLetters('z') = 'z'
#    addLetters('z', 'a') = 'a'
#    addLetters('y', 'c', 'b') = 'd' // переполнение
#    addLetters() = 'z'
