#!/bin/false
# shellcheck shell=sh disable=SC3043
substitute_DATE_TIME() {
  local destination_path_folder="$1"
  local timestamp="$2"
  convert_DATE_format() {
    local fmt="${1:-yyyymmdd}"  # Формат по умолчанию
    echo "$fmt" | sed -e 's/yyyy/%Y/g' -e 's/yy/%y/g' -e 's/dd/%d/g' \
                      -e 's/mmm/%b/g'  -e 's/mm/%m/g'
  }
  convert_TIME_format() {
      local fmt="${1:-hhmmss}"  # Формат по умолчанию
      echo "$fmt" | sed -e 's/hh/%H/g' -e 's/mm/%M/g' -e 's/ss/%S/g'
  }
  replace() {
    local tag="$1"
    while echo "$destination_path_folder" | grep -q "<${tag}\(:[^>]*\)\?>"; do
      local format=""
      local full_match
      full_match=$(echo "$destination_path_folder" | grep -o "<${tag}\(:[^>]*\)\?>" | head -1)
      if echo "$full_match" | grep -q ":"; then
        format=$(echo "$full_match" | cut -d: -f2 | tr -d '>')
      fi
      current_value="$(date "+$("convert_${tag}_format" "$format")" -d "@$timestamp" )"
      destination_path_folder=$(echo "$destination_path_folder" | sed "s~$full_match~$current_value~")
    done
  }
  replace "DATE"
  replace "TIME"
  echo "$destination_path_folder"
}

get_path_basename_ext() {
    local s="$1"
    # local what_return="${2:-}"
    local path="${s%/*}"
    local filename="${s##*/}"
    local basename="${filename%.*}"
    local ext=".${filename##*.}"
    local result
    case "${2:-}" in
        "path")     result="$path" ;;
        "basename") result="$basename" ;;
        "ext")      result="$ext" ;;
        "filename") result="$filename" ;;
        *)          result=$(printf '%s\n' "$path" "$basename" "$ext" "$filename") ;;
    esac
    echo "$result"
}
# set -- $(get_path_basename_ext "/path/to/file.txt")

substitute_t() {
	local arg_t="$1"
	# local current_page_in_old_doc="$2"
	# local arg_source="$3"
  # local timestamp="$4"

  substitute_t_Name() {
		# local arg_t="$1"
		# local arg_source="$2"
  	local basename
    basename="$(get_path_basename_ext "$2" "basename")"
	  echo "${1}" | sed -e "s/\[Name\]/${basename}/g" 
    # echo "${1//\[Name\]/${basename}}"
  }

  substitute_t_part() {
	  echo "${1}" | sed -e "s/\[part\]//g" 
  }

  substitute_t_page() {
		# local arg_t="$1"
		# local current_page_in_old_doc="$2"
	  echo "${1}" | sed -e "s/#/${2}/g" 
  } 

  arg_t=$(substitute_DATE_TIME "$arg_t" "$4" )
  arg_t="$(substitute_t_page "$arg_t" "$2")"
  arg_t="$(substitute_t_Name "$arg_t" "$3")"
  arg_t="$(substitute_t_part "$arg_t" )"
  echo "$arg_t"
}
# substitute_t "[Name][part].str#.pdf" "12" "C:\pdf_splitter_by_blanks_sheet\test_files/inp.pdf"

create_folder() {
  # local arg_t="$1"
  local timestamp="$2"
  # local arg_destination="$3"
  local folder
  folder="$(get_path_basename_ext "$1" "path" )"
  folder="$(substitute_DATE_TIME "$folder" "$2" )"
  mkdir -p "${3}/${folder}"
}


generate_new_name() {
	# local arg_t="$1"
	# local current_page_in_old_doc="$2"
	# local current_page_in_new_doc="$3"
	# local count_docs="$4"
	# local arg_source="$5"
	# local timestamp="$6"
	substitute_t "$1" "$2" "$5" "$6"
	# echo "document_${2}.pdf"
}

get_npages() {
  # local file_pdf="$1"
  qpdf --show-npages "$1"
}

extract_page() {
	# local input_pdf="$1"
	# local current_page="$2"
	# local output_pdf="$3"
	qpdf --empty --pages "$1" --range="$2" -- "$3"
	# извлечь страницу
	# проверить страницу
	# увеличить счётчик
	# добавить страницу в документ
	# удалить страницу
}

create_new_doc() {
	# local arg_destination="$1"
	# local current_doc="$2"
	# local filename_tmp_page="$3"
  mv "$1/$3" "$1/$2"
}
delete_tmp_doc() {
	# local arg_destination="$1"
	# local current_doc="$2"
	# local filename_tmp_page="$3"
  rm "$1/$3"
}

add_page_to_doc() {
	# local arg_destination="$1"
	# local current_doc="$2"
	# local filename_tmp_page="$3"
	qpdf --empty --pages "$1/$2" "$1/$3" -- "$1/merged.pdf"
	mv "$1/merged.pdf" "$1/$2"
  rm "$1/$3"
}

is_blank_page() {
  # local file_pdf="$1"
  local is_blank="false"
  local filesize
  filesize=$( ls -l "$1" | awk '{print $5}')
  [ "$filesize" -le 200000 ] && is_blank="true"
  echo $is_blank
}

remove_blank_pages() {
	# set -x
	# local arg_destination="$1"
	# local current_doc="$2"
	# local arg_bc="$3"
  local last_page
  last_page="$(( $(get_npages "$1/$2") - $3 ))"
  if [ $last_page -eq 0 ] ;then
    rm "$1/$2"
  else
	  qpdf "$1/$2" --pages . --range=1-$last_page -- "$1/output_trimmed.pdf"
  	mv "$1/output_trimmed.pdf" "$1/$2"
  fi
	# pdftk "$1/$2" cat 1-end-3 output "$1/output_trimmed.pdf"
	# set +x
}

collate_pdfs() {
  # local odd="$1"
  # local even="$2"
  # local merged="$3"
  # local range="$4"
  qpdf --collate --empty --pages "$1" --range=1-z "$2" --range=z-1 -- "$3"  # --range=z-1	
}


