#!/bin/sh

tmpdir=`mktmp -d --tmpdir=.`
cd "$tmpdir"
phantomjs "$1" "$2" "$3" png
for png in `ls -1 $3*.png`
do
    optipng -o5 -quiet -preserve "$png"
    convert "$png" "${png%%.*}.pdf"
done
gs -q -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE="../${2%.*}.pdf" -dBATCH `ls $3*.pdf`
cd ..
rm -rf "$tmpdir"
