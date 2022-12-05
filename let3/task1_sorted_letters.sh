#!/bin/bash


# Проверка валидности аргументов
if [ $# != 2 ]; then
    echo "Error: It is required to provide two arguments. Provided: $#." >&2
    exit 1
else
    lowercase_letters_regex='^[a-z]+$' # регулярное выражение для непустой последовательности строчных латинских букв
    if ! [[ $1 =~ $lowercase_letters_regex ]]; then
        echo "Error: Incorrect 1st string: $1" >&2
        exit 2
    fi
    if ! [[ $2 =~ $lowercase_letters_regex ]]; then
        echo "Error: Incorrect 2nd string: $2" >&2
        exit 3
    fi
fi

# Записываем строки и алфавит
str_a=$1
str_b=$2
alphabet="abcdefghijklmnopqrstuvwxyz"

# Создаем маску алфавита и заполняем её нолями
for (( i = 0; i < ${#alphabet}; i++ )); do
    alphabet_mask[$i]=0
done

# Проходимся по первой строке и отмечаем появления букв на маске
for (( i = 0; i < ${#str_a}; i++ )); do
    current_letter=${str_a:i:1}
    # Переводим букву в ее порядковый номер в алфавите (где буква 'a' имеет индекс 0)
    current_letter_index=$(( $( printf "%d" "'$current_letter" ) - 97 ))
    alphabet_mask[$current_letter_index]=1
    unset current_letter current_letter_index
done

# Проходимся по второй строке и отмечаем появления букв на маске
for (( i = 0; i < ${#str_b}; i++ )); do
    current_letter=${str_b:i:1}
    # Переводим букву в ее порядковый номер в алфавите (где буква 'a' имеет индекс 0)
    current_letter_index=$(( $( printf "%d" "'$current_letter" ) - 97 ))
    alphabet_mask[$current_letter_index]=1
    unset current_letter current_letter_index
done

# Теперь проходимся по заполненной маске и в прямом порядке выводим буквы алфавита
for (( i = 0; i < ${#alphabet}; i++ )); do
    if [ ${alphabet_mask[i]} == 1 ]; then
        echo -n ${alphabet:i:1}
    fi
done

echo # \n
exit 0


#####
#  Task 1
#  Возьмите 2 строки s1 и s2, включающие только буквы от a до z.
#  Нужно вернуть новую отсортированную строку, максимальной длинны,
#  содержащую различные буквы - каждая из которых берется только один раз - из строк s1 или s2.
#  a = "xyaabbbccccdefww"
#  b = "xxxxyyyyabklmopq"
#  longest(a, b) -> "abcdefklmopqwxy"
#  a = "abcdefghijklmnopqrstuvwxyz"
#  longest(a, a) -> "abcdefghijklmnopqrstuvwxyz"
#####