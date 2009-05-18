#!/bin/sh

TMPDIR=`mktemp -d /tmp/hyphXXXXXX`
cd $TMPDIR
svn co svn://tug.org/texhyphen/tags/CTAN/hyph-utf8
find . -name .svn -exec rm -rf {} \;
zip -ry hyph-utf8.zip hyph-utf8
rm -rf hyph-utf8
echo "$TMPDIR/hyph-utf8.zip ready to be shipped to CTAN."
