#!/bin/false
# shellcheck shell=sh disable=SC3043

scan_document() {
	set -x
	# local output_pdf="$1"
	local success_scanned="1"
	local naps_returned_text
	while [ "$success_scanned" -ne 0 ] ;do
	  naps_returned_text="$(naps2.console -o "$1" )" 
	  success_scanned="$?"
          naps_returned_text="$(echo "$naps_returned_text" | iconv -f "${CHCP:-65001}" )"
	  echo "$naps_returned_text" 1>&2
	  if [ "$success_scanned" != "0" ] ;then
	  	request_try_scan_again "$naps_returned_text"
	  	[ "$?" -ne 0 ] && return 12
	  fi
	done
  set +x
}
