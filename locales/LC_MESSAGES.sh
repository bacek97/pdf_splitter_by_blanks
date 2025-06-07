#!/bin/false
# shellcheck shell=sh source=../PDFSplitterB.sh
eval "$(locale)"
FALLBACK_LOCALE="ru_RU.UTF-8"
CHCP=${CHCP:-65001}
LC_MESSAGES="${LC_MESSAGES:-${FALLBACK_LOCALE}}"
PATH_LOCALES="${0%/*}/locales"
[ "$PATH_LOCALES/${LC_MESSAGES%.*}.${LC_MESSAGES##*.}" -ne "$PATH_LOCALES/${LC_MESSAGES%.*}.UTF-8" ] && grep -v -e "MSG_PIPE_" "$PATH_LOCALES/${LC_MESSAGES%.*}.UTF-8" | iconv -t "${LC_MESSAGES##*.}" > "$PATH_LOCALES/${LC_MESSAGES%.*}.${LC_MESSAGES##*.}"
.                      "$PATH_LOCALES/${FALLBACK_LOCALE}"
.                      "$PATH_LOCALES/${LC_MESSAGES%.*}.UTF-8"               # ru_RU.UTF-8
.                      "$PATH_LOCALES/${LC_MESSAGES%.*}.${LC_MESSAGES##*.}"  # ru_RU.CP1251
