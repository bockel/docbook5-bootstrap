#!/bin/sh

tmpdir=`mktemp -d --tmpdir=.`
cd "$tmpdir"
phantomjs "$1" "../$2" "${2%.*}" png
for png in `ls -1 ${2%.*}*.png`
do
    optipng -o5 -quiet -preserve "$png"
    convert "$png" "${png%.*}.pdf"
    echo convert "$png" "${png%.*}.pdf"
done
gs -q -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE="../${2%.*}.pdf" -dBATCH `ls ${2%.*}*.pdf`
cd ..
rm -rf "$tmpdir"
