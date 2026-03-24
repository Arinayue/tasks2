#СПРАВКА
show_help() {
    echo "Использование: $0 [директория] [суффикс] [лимит_размера] [выходной_файл]"
    echo
    echo "Скрипт ищет исполняемые файлы с заданным суффиксом,"
    echo "размер которых не превышает указанный лимит."
    echo
    echo "Параметры:"
    echo "  директория       — папка с файлами"
    echo "  суффикс          — например .sh"
    echo "  лимит_размера — например 512"
    echo "  выходной_файл    — файл для записи результата"
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

dir=$1
suffix=$2
limit=$3
outfile=$4

if [[ -z "$dir" ]]; then
    read -p "Введите директорию: " dir
fi

if [[ -z "$suffix" ]]; then
    read -p "Введите суффикс (например .sh): " suffix
fi

if [[ -z "$limit" ]]; then
    read -p "Введите размер лимита: " limit
fi

if [[ -z "$outfile" ]]; then
    read -p "Введите имя выходного файла: " outfile
fi

#ПРОВЕРКИ
if [[ ! -d "$dir" ]]; then
    echo "Ошибка: директория не найдена"
    show_help
    exit 1
fi

if ! [[ "$limit" =~ ^[0-9]+$ ]]; then
    echo "Ошибка: лимит должен быть числом"
    show_help
    exit 1
fi

#ОЧИСТКА ФАЙЛА
> "$outfile"

#ОСНОВНОЙ КОД
for file in "$dir"/*; do
    echo "Проверяем: $file"
    if [[ -f "$file" ]]; then
        name=$(basename "$file")
        echo "  имя: $name"
        if [[ "$name" == *"$suffix" ]]; then
            echo "  суффикс ок"
            size=$(stat -c%s "$file")
            echo "  размер: $size"
            if (( size <= limit )); then
                echo "  ПОДХОДИТ!"
                echo "$name $size" >> "$outfile"
            else
                echo "  не кратен"
            fi
        else
            echo "  суффикс не совпал"
        fi
    fi
done
echo "Готово: результат записан в $outfile"
#for file in "$dir"/*; do
#    echo "Проверяем: $file"
#    if [[ -f "$file" ]]; then
#        name=$(basename "$file")
#        echo "  имя: $name"
#        if [[ "$name" == *"$suffix" ]]; then
#            echo "  суффикс ок"
#            if [[ -x "$file" ]]; then
#                echo "  исполняемый"
#                size=$(stat -c%s "$file")
#                echo "  размер: $size"
#                if (( size <= limit )); then
#                    echo "  ПОДХОДИТ!"
#                    echo "$name $size" >> "$outfile"
#                else
#                    echo "  не кратен"
#                fi
#            else
#                echo "  не исполняемый"
#            fi
#        else
#            echo "  суффикс не совпал"
#        fi
#    fi
#done