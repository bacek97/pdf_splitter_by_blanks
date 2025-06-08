#!/bin/sh
# shellcheck shell=sh disable=SC3045

rm -r result_test1
mkdir -p result_test1
../../common/PDFSplitterB.sh tst_file1.pdf result_test1

res_files="$(ls result_test1/*/)"

exp_files="tst_file1.str13.pdf
tst_file1.str17.pdf
tst_file1.str3.pdf
tst_file1.str9.pdf"

if [ "$res_files" = "$exp_files" ] ;then 
  echo SUCCESS_TEST!
else 
  echo FAILED_TEST!
fi
read -n 1 -s -r -p "Press any key to continue"
