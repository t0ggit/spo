#!/bin/bash


# Проверка валидности аргумента
if [[ $# != 1 ]]; then
    echo "Error: It is required to provide 1 argument. Provided: $#" >&2
    exit 1
else
    decimal_number_regex='^[0-9]+$' # регулярное выражение для непустой последовательности десятичных цифр
    if ! [[ $1 =~ $decimal_number_regex ]]; then
        echo "Error: Not a number: $1" >&2
        exit 2
    fi
fi

# Копируем введённое число в переменную
number=$1

# Определяем наименьшую цифру в числе (игнорируя ноль, так как его не поставить в начало)
minimal_digit=9
for (( i = 0; i < ${#number}; i++ )); do
    if [ ${number:i:1} != 0 ]; then
        if [ ${number:i:1} -lt $minimal_digit ]; then
            minimal_digit=${number:i:1}
        fi
    fi
done

# Определяем индекс самой левой минимальной цифры
for (( i = 0; i < ${#number}; i++ )); do
    if [ ${number:i:1} == $minimal_digit ]; then
        minimal_digit_index=$i
        break
    fi
done

# Выводим результат в требуемом формате, одновременно переставляя цифру
echo -n "[$minimal_digit" # Ставим выбранную минимальную цифру в самое начало числа
for (( i = 0; i < ${#number}; i++ )); do
    # Дописываем к ней все оставшиеся, игнорируя ту, что стоит на выбранном индексе минимальной цифры
    if [ $i != $minimal_digit_index ]; then
        echo -n "${number:i:1}"
    fi
done
# Выводим исходный индекс минимальной цифры и индекс, в который она была перемещена (который всегда ноль)
echo -n ", $minimal_digit_index, 0]"

echo # \n
exit 0

#####
#  Task 3
#  У вас есть положительное число n, состоящее из цифр.
#  Вы можете сделать не более одной операции: выбрав индекс цифры в числе,
#  удалить эту цифру под этим индексом и вставить ее обратно в другое или в то же место в числе,
#  чтобы найти наименьшее число, которое вы можете получить.
#  Задача:
#  Вернуть массив, с помощью:
#  - наименьшее число, которое вы получили
#  - индекс i взятой вами цифры d, i как можно меньше
#  - индекс j (как можно меньше), куда вы вставляете эту цифру d, чтобы получить наименьшее число.
#  Пример:
#  smallest(261235) --> [126235, 2, 0] or (126235, 2, 0) or "126235, 2, 0"
#  126235 — это наименьшее число, которое можно получить, взяв 1 в индексе 2 и поместив его в индекс 0.
#####