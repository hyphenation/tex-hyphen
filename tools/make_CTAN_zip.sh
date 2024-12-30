#!/bin/sh

NAME=hyph-utf8
TMPDIR=`mktemp -d /tmp/hyphXXXXXX`
filename="$TMPDIR/$NAME.zip"

git checkout HEAD -- TL # TODO Remove!
if [ ! -z "$(git status -s)" ]; then
  echo 'The repository is dirty; I won’t do anything.  Please clean up first.'
  exit 42
fi
oldwd=`pwd`
cd `dirname $0`/..
git archive --format=zip --prefix=$NAME/ --output="$filename" master:$NAME
echo "$filename ready to be shipped to CTAN."
cd $oldwd
