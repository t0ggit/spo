#!/bin/bash

# Проверка количества аргументов
if [ $# != 1 ]; then
    echo "Error: It is required to provide one argument. Provided: $#" >&2
    exit 1
fi

# Записываем аргумент пословно в массив слов
read -r -a words <<< $1

result_string=""

global_i=0 # Глобальный индекс, чтобы определять четность символа во всей строке
# Изменяем каждое слово
for (( word_i = 0; word_i < ${#words[@]}; word_i++ )); do
    current_word=${words[word_i]}
    # В каждом слове итерируемся по каждому символу
    for (( char_i = 0; char_i < ${#current_word}; char_i++ )); do
        current_char=${current_word:char_i:1}
        current_char_ascii=$( printf "%d" "'$current_char" ) # переводим в десятичный код ASCII
        if (( $current_char_ascii >= 65 && $current_char_ascii <= 90 )); then # Заглавные буквы
            # Круговой сдвиг на единицу вперед
            result_char_ascii=$(( $current_char_ascii + 1 ))
            if [ $result_char_ascii == 91 ]; then
                result_char_ascii=65
            fi
            # Уменьшаем нечетные
            if [ $(( global_i % 2 )) == 1 ]; then
                result_char_ascii=$(( $result_char_ascii + 32 ))
            fi
            # Сохраняем результирующий символ
            octal_ascii=$( printf %o $result_char_ascii )
            result_char=$( printf %b \\$octal_ascii )
            result_string+="$result_char"
        else
        if (( $current_char_ascii >= 97 && $current_char_ascii <= 122 )); then # Строчные буквы
            # Круговой сдвиг на единицу вперед
            result_char_ascii=$(( $current_char_ascii + 1 ))
            if [ $result_char_ascii == 123 ]; then
                result_char_ascii=97
            fi
            # Увеличиваем четные
            if [ $(( global_i % 2 )) == 0 ]; then
                result_char_ascii=$(( $result_char_ascii - 32 ))
            fi
            # Сохраняем результирующий символ
            octal_ascii=$( printf %o $result_char_ascii )
            result_char=$( printf %b \\$octal_ascii )
            result_string+="$result_char"
        else
        if (( $current_char_ascii >= 48 && $current_char_ascii <= 57 )); then # Цифры
            # Вычитаем из девяти

            # Сохраняем результирующий символ
            octal_ascii=$( printf %o $result_char_ascii )
            result_char=$( printf %b \\$octal_ascii )
            result_string+="$result_char"
        else
        # Остальные символы сохраняем без изменений
        octal_ascii=$( printf %o $result_char_ascii )
        result_char=$( printf %b \\$octal_ascii )
        result_string+="$result_char"
        fi
        fi
        fi
        (( global_i++ ))
    done
    (( global_i++ ))
    result_string+=" "
done

echo $result_string
exit 0



###
# выберите текст, набранный заглавными буквами, включая или не включая цифры и неалфавитные символы,
# 1. Сдвиньте каждую букву на заданное число, но преобразованная буква должна быть буквой (круговой сдвиг),
# 2. Замените каждую цифру ее дополнением к 9, (digit - 9)
# 3. Сохраните небуквенные и нецифровые символы
# 4. Уменьшите каждую букву в нечетной позиции, увеличьте каждую букву в четной позиции (первый символ находится в позиции 0),
# 5. Переверните строку (результат).

# Пример:
# your text: "I LOVE YOU 123!!!", shift 1
# 1 + 2 + 3 - > "J MPWF ZPV 123!!!"
# 4 "J MpWf zPv 876!!!!"
# 5 "!4897 Oj OspC"
###