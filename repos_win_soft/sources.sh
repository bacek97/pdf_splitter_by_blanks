#!/bin/sh
# git add locales modules main* PDFSplitterB.sh txxxt_* repos_win_soft/sources.sh repos_win_soft/win_soft.tar.xz
OLD_FLAGS="$-" && set +x

PATH_REPOS="${0%/*}/repos_win_soft"
USING=""
# https://frippery.org/files/busybox/busybox.exe
# busybox_sh.exe sh

# https://www.coolutils.com/ru/PDFSplitterX
PATH="$PATH:C:\Program Files\CoolUtils\PDF Splitter X" 
# "C:\Program Files\CoolUtils\PDF Splitter X\PDFSplitterX64.exe" "source.pdf" "destination_folder" -em blanks

# https://github.com/cyanfish/naps2/releases/download/v8.1.4/naps2-8.1.4-win-x64.zip
PATH="$PATH:${PATH_REPOS}/naps2-8.1.4-win-x64/App" &&
USING="${USING}Usung: $(naps2.console --version 2>&1 | head -n1)\n"
# NAPS2.Console 8.1.4+fa9d96cf9133ce1793928be0d239ec6dc1b88521

# https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_free-2.02-win-setup.exe
PATH="$PATH:${PATH_REPOS}/pdftk-v2.02" &&
USING="${USING}Usung: $(pdftk --version 2>&1 | head -n2 | tail -n1)\n"
# pdftk 2.02 a Handy Tool for Manipulating PDF Documents

# https://github.com/qpdf/qpdf/releases/download/v12.2.0/qpdf-12.2.0-mingw64.exe
PATH="$PATH:${PATH_REPOS}/qpdf-v12.2.0" &&
USING="${USING}Usung: $(qpdf.exe --version 2>&1 | head -n1)\n"
# qpdf version 12.2.0

# https://github.com/ncruces/zenity/releases/download/v0.10.14/zenity_win64.zip
PATH="$PATH:${PATH_REPOS}/" &&
USING="${USING}Usung: $(zenity.exe --version 2>&1 | head -n1)\n"
# zenity v0.10.14 windows/amd64

printf "${USING}"

case "$OLD_FLAGS" in
  *x*) set -x ;;
esac