#!/bin/false
# shellcheck shell=sh

choose_folder() {
  echo "Введите путь к папке: "
	read -r folder
	if [ -d "$folder" ]; then
	  echo "Выбрано: $folder"
	else
	  echo "Ошибка: папка не существует!"
	  exit 0
	fi
}

# if [ "$?" -ne 0 ] ; then
#         zenity --error \
#           --text="Update canceled."
# fi