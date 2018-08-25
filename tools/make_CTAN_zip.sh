#!/bin/sh

NAME=hyph-utf8
TMPDIR=`mktemp -d /tmp/hyphXXXXXX`
filename="$TMPDIR/$NAME.zip"

pushd `dirname $0`/..
git archive --format=zip --prefix=$NAME/ --output="$filename" master:$NAME
echo "$filename ready to be shipped to CTAN."
popd
