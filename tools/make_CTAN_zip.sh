#!/bin/sh

TMPDIR=`mktemp -d /tmp/hyphXXXXXX`
cd $TMPDIR
# make sure to use 
#     use-commit-times = yes
# in ~/.subversion/config
svn co svn://tug.org/texhyphen/trunk/hyph-utf8
find . -name .svn -exec rm -rf {} \;
cd hyph-utf8
ln -s doc/generic/hyph-utf8/README .
zip -ry ../hyph-utf8.zip *
cd ..
rm -rf hyph-utf8
echo "$TMPDIR/hyph-utf8.zip ready to be shipped to CTAN."
