#!/bin/bash

# Проверка количества аргументов
if [ $# != 1 ]; then
    echo "Error: It is required to provide one argument. Provided: $#." >&2
    exit 1
fi

# Исходная фраза
phrase=$1
# Преобразованная фраза (но еще не перевернутая)
passphrase=""

# Посимвольно итерируемся по исходной фразе
for (( char_i = 0; char_i < ${#phrase}; char_i++ )); do
    current_char=${phrase:char_i:1}
    current_char_ascii=$( printf "%d" "'$current_char" ) # переводим в десятичный код ASCII
    if (( current_char_ascii >= 65 && current_char_ascii <= 90 )); then # Заглавные буквы
        # Круговой сдвиг на единицу вперед
        result_char_ascii=$(( current_char_ascii + 1 ))
        if [ $result_char_ascii == 91 ]; then
            result_char_ascii=65
        fi
        # Уменьшаем нечетные
        if [ $(( char_i % 2 )) == 1 ]; then
            result_char_ascii=$(( result_char_ascii + 32 ))
        fi
        # Сохраняем результирующий символ
        octal_ascii=$( printf %o $result_char_ascii )
        result_char=$( printf %b \\$octal_ascii )
        passphrase+="$result_char"
        # Очищаем локальные переменные, чтобы исключить их использование вне текущей итерации цикла
        unset result_char_ascii octal_ascii result_char
    else
        if (( current_char_ascii >= 97 && current_char_ascii <= 122 )); then # Строчные буквы
            # Круговой сдвиг на единицу вперед
            result_char_ascii=$(( current_char_ascii + 1 ))
            if [ $result_char_ascii == 123 ]; then
                result_char_ascii=97
            fi
            # Увеличиваем четные
            if [ $(( char_i % 2 )) == 0 ]; then
                result_char_ascii=$(( result_char_ascii - 32 ))
            fi
            # Сохраняем результирующий символ
            octal_ascii=$( printf %o $result_char_ascii )
            result_char=$( printf %b \\$octal_ascii )
            passphrase+="$result_char"
            # Очищаем локальные переменные, чтобы исключить их использование вне текущей итерации цикла
            unset result_char_ascii octal_ascii result_char
        else
            if (( current_char_ascii >= 48 && current_char_ascii <= 57 )); then # Цифры
                # Вычитаем из девяти и записываем в passphrase
                passphrase+="$(( 9 - current_char ))"
            else
                # Остальные символы сохраняем без изменений
                passphrase+="$current_char"
            fi
        fi
    fi
done

# Теперь по аналогии с первой задачей, переворачиваем порядок слов в фразе
read -r -a words <<< "$passphrase"
for (( i=${#words[@]}-1; i >= 0; i-- )); do
	echo -n "${words[$i]}"
	if [[ $i != 0 ]]; then
		echo -n " "
	fi
done
echo

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