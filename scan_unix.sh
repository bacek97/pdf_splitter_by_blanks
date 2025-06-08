#!/bin/sh

# https://github.com/search?q=pdf+splitter+blank&type=repositories

PATH_LOCALES="${0%/*}/common/locales"
PATH_WIN_SOFT="${0%/*}/common/win_soft"
. "${0%/*}/common/locales/LC_MESSAGES.sh"
. "${0%/*}/common/win_soft/sources.sh"
. "${0%/*}/common/wrappers/gui-zenity.sh"
. "${0%/*}/common/wrappers/qpdf.sh"
. "${0%/*}/common/wrappers/naps2.sh"

(
printf "0\n# %s\n" "${MSG_PIPE_CHOOSE_FOLDER}" &&
CHOOSED_FOLDER=$(choose_folder) &&
CHOOSED_FOLDER="$(echo "$CHOOSED_FOLDER" | iconv -f utf-8 -t cp1251)" &&

printf "1\n# %s\n" "${MSG_PIPE_SET_TMPL_NAME}" && 
ARG_T=$(set_template) &&
ARG_T="$(echo "$ARG_T" | iconv -f utf-8 -t cp1251)" &&

printf "2\n# %s\n" "${MSG_PIPE_SCAN_FRONT_SIDE}" &&
scan_document "${CHOOSED_FOLDER}/${FILENAME_ODD}" &&

printf "3\n# %s\n" "${MSG_PIPE_PLS_REVERSE_TITLE}" &&
is_reversed "$(get_npages "${CHOOSED_FOLDER}/${FILENAME_ODD}")" &&

printf "4\n# %s\n" "${MSG_PIPE_SCAN_BACK_SIDE}" &&
scan_document "${CHOOSED_FOLDER}/${FILENAME_EVEN}" &&

NPAGES_ODD="$(get_npages "${CHOOSED_FOLDER}/${FILENAME_ODD}")"
NPAGES_EVEN="$(get_npages "${CHOOSED_FOLDER}/${FILENAME_EVEN}")"

count_pages_check_equal "$NPAGES_ODD" "$NPAGES_EVEN" &&

printf "5\n# %s\n" "${MSG_PIPE_COLLATING}" &&
collate_pdfs "${CHOOSED_FOLDER}/${FILENAME_ODD}" "${CHOOSED_FOLDER}/${FILENAME_EVEN}" "${CHOOSED_FOLDER}/${FILENAME_COLLATE}" &&

"${0%/*}/common/PDFSplitterB.sh" "${CHOOSED_FOLDER}/${FILENAME_COLLATE}" "${CHOOSED_FOLDER}" --t "${ARG_T}" --em blanks &&  # "[Name][part]<DATE><TIME>.str#.pdf"

clean "${CHOOSED_FOLDER}/${FILENAME_ODD}" "${CHOOSED_FOLDER}/${FILENAME_EVEN}" "${CHOOSED_FOLDER}/${FILENAME_COLLATE}"

) | "${0%/*}/common/wrappers/gui-progress-zenity.sh"

