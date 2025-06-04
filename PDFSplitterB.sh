#!/bin/sh
# shellcheck shell=sh disable=SC2166
# ./PDFSplitterB.sh "$ARG_SOURCE" "${ARG_DESTINATION}" --t "" --em=blanks --bc "1"
# ./PDFSplitterB.sh "C:\pdf_splitter_by_blanks_sheet\test_files\inp.pdf" "." --t "<TIME>\<TIME>[Name][part].str#.pdf"

# ARG_DESTINATION="C:\pdf_splitter_by_blanks_sheet\test_files/"

PATH_LOCALES="${0%/*}/locales"
. "${0%/*}/locales/LC_MESSAGES.sh"
. "${0%/*}/repos_win_soft/sources.sh"
. "${0%/*}/modules/gui-zenity.sh"
. "${0%/*}/modules/qpdf.sh"

TIMESTAMP="$(date  +%s)"
NPAGES="NULL"
CURRENT_DOC="NULL"
ARG_BC=2
BLANK_COUNT=0
CURRENT_PAGE_IN_NEW_DOC=1
CURRENT_PAGE_IN_OLD_DOC=1
COUNT_DOCS=0
IS_BLANK_PAGE="NULL"

set -x

ARG_SOURCE="$1"
ARG_DESTINATION="$2"
ARG_T="$4"

printf "6\n# %s\n" "${MSG_PIPE_CALC_NPAGES}" &&
NPAGES="$(get_npages "$ARG_SOURCE")" &&

while [ "$CURRENT_PAGE_IN_OLD_DOC" -le "$NPAGES" ]; do
	percent=$(( ((CURRENT_PAGE_IN_OLD_DOC * 100) / NPAGES ) - 1 ))
	printf "${MSG_PIPE_ANALYZE}" "$percent" "$percent" "$CURRENT_PAGE_IN_OLD_DOC" "$NPAGES" "$COUNT_DOCS" &&

	extract_page "$ARG_SOURCE" "${CURRENT_PAGE_IN_OLD_DOC}" "${ARG_DESTINATION}/${FILENAME_TMP_PAGE}" &&
	IS_BLANK_PAGE="$(is_blank_page "${ARG_DESTINATION}/${FILENAME_TMP_PAGE}")"
	if [ "$IS_BLANK_PAGE" = "true"  ] ;then
		BLANK_COUNT=$((BLANK_COUNT + 1))
	else
		BLANK_COUNT=0
	fi

	if [ $CURRENT_PAGE_IN_NEW_DOC -eq 1 -a "$IS_BLANK_PAGE" = "false" ] ||
	   [ $CURRENT_PAGE_IN_OLD_DOC -eq 1 -a "$IS_BLANK_PAGE" = "true"  ] ;then
		COUNT_DOCS=$((COUNT_DOCS + 1))
		CURRENT_DOC="$(generate_new_name "$ARG_T" "$CURRENT_PAGE_IN_OLD_DOC" "$CURRENT_PAGE_IN_NEW_DOC" "$COUNT_DOCS" "$ARG_SOURCE" "$TIMESTAMP" )"
		create_folder "$ARG_T" "$TIMESTAMP" "$ARG_DESTINATION"
		create_new_doc "$ARG_DESTINATION" "$CURRENT_DOC" "$FILENAME_TMP_PAGE"
	elif [ $CURRENT_PAGE_IN_NEW_DOC -ne 1 ] ;then
		add_page_to_doc "$ARG_DESTINATION" "$CURRENT_DOC" "$FILENAME_TMP_PAGE"
	fi
	CURRENT_PAGE_IN_NEW_DOC=$((CURRENT_PAGE_IN_NEW_DOC + 1))

	if [ $BLANK_COUNT -eq $ARG_BC ] ;then
	  remove_blank_pages "$ARG_DESTINATION" "$CURRENT_DOC" "$ARG_BC"
	  BLANK_COUNT=0
		CURRENT_PAGE_IN_NEW_DOC=1
	fi

	CURRENT_PAGE_IN_OLD_DOC=$((CURRENT_PAGE_IN_OLD_DOC + 1))
	sleep 1
done
