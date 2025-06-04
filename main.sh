#!/bin/sh
PATH_LOCALES="${0%/*}/locales"
. "${0%/*}/locales/LC_MESSAGES.sh"
. "${0%/*}/repos_win_soft/sources.sh"
. "${0%/*}/modules/gui-zenity.sh"
. "${0%/*}/modules/qpdf.sh"
. "${0%/*}/modules/naps2.sh"

(
printf "0\n# %s\n" "${MSG_PIPE_CHOOSE_FOLDER}" &&
CHOOSED_FOLDER=$(choose_folder) &&

printf "1\n# %s\n" "${MSG_PIPE_SET_TMPL_NAME}" && 
ARG_T=$(set_template) &&

printf "2\n# %s\n" "${MSG_PIPE_SCAN_FRONT_SIDE}" &&
scan_document "${CHOOSED_FOLDER}/${FILENAME_ODD}" &&

printf "3\n# %s\n" "${MSG_PIPE_PLS_REVERSE_TITLE}" &&
is_reversed &&

printf "4\n# %s\n" "${MSG_PIPE_SCAN_BACK_SIDE}" &&
scan_document "${CHOOSED_FOLDER}/${FILENAME_EVEN}" &&

printf "5\n# %s\n" "${MSG_PIPE_COLLATING}" &&
collate_pdfs "${CHOOSED_FOLDER}/${FILENAME_ODD}" "${CHOOSED_FOLDER}/${FILENAME_EVEN}" "${CHOOSED_FOLDER}/${FILENAME_COLLATE}" &&

"${0%/*}/PDFSplitterB.sh" "${CHOOSED_FOLDER}/${FILENAME_COLLATE}" "${CHOOSED_FOLDER}" --t "${ARG_T}" --em blanks &&  # "[Name][part]<DATE><TIME>.str#.pdf"

echo "99" && sleep 10
) | ./modules/gui-progress-zenity.sh

