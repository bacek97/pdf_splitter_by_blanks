#!/bin/false
# shellcheck shell=sh

request_try_scan_again() {
	# local fail_text="echo $1 | iconv -f cp1251 -t utf-8"
  zenity --question --title="$MSG_INLINE_TRY_SCAN_AGAIN_TITLE" --ok-label="$MSG_INLINE_TRY_SCAN_AGAIN_OK" --cancel-label="$MSG_INLINE_TRY_SCAN_AGAIN_CANCEL" --text="$1"
}

choose_folder() {
  zenity --file-selection --directory --title="$MSG_INLINE_CHOOSE_FOLDER" | iconv -f utf-8 -t cp1251
}

set_template() {
  zenity --entry --title="$MSG_INLINE_SET_TMPL_NAME" --text="$MSG_INLINE_SET_TMPL_NAME" --entry-text "$FILENAME_EVERY_FILE" | iconv -f utf-8 -t cp1251
}

is_reversed() {
  # local napges_odd="$1"
  zenity --question --title="$1 $MSG_INLINE_PLS_REVERSE_TITLE" --ok-label="$MSG_INLINE_PLS_REVERSE_OK" --cancel-label="$MSG_INLINE_PLS_REVERSE_CANCEL" --text="$MSG_INLINE_PLS_REVERSE_TEXT"
}

count_pages_check_equal() {
  # local napges_odd="$1"
  # local napges_even="$2"
  [ "$1" -ne "$2" ] && 
    zenity --question --title="$1 != $2" --ok-label="$1 != $2" --cancel-label="X" --text="OK"
}

