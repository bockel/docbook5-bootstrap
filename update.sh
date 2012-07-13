#!/bin/sh
CPATH=`pwd`
git submodule update --init
git submodule foreach git checkout master
git submodule foreach git pull

cd share
DB_RNC="xslt2/schemas/docbook.rnc"
if [ -f "$DB_RNC" ]; then
    trang "$DB_RNC" docbook.rng
fi

cd xslt20
ant
cd "$CPATH"
