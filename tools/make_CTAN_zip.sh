#!/bin/sh

NAME=hyph-utf8
TMPDIR=`mktemp -d /tmp/hyphXXXXXX`
filename="$TMPDIR/$NAME.zip"

if [ ! -z "$(git status -s)" ]; then
  echo 'The repository is dirty; I won’t do anything.  Please clean up first.'
  exit 42
fi

DATE=`date '+%Y.%m.%d'`
release_branch=CTAN-$DATE
if [ ! -z `git branch | grep -E "^\s*$release_branch$"` ]; then
  echo "The release branch $release_branch already exists; exiting."
  exit 43
fi
git checkout -b $release_branch

echo $DATE | sed -e 's/\./-/g' >$NAME/VERSION
git add $NAME/VERSION
git commit -m 'Add VERSION for release to CTAN.'
git push
git checkout master

cd `dirname $0`/..
git archive --format=zip --prefix=$NAME/ --output="$filename" $release_branch:$NAME
TMPDIR2=`mktemp -d /tmp/hyphXXXXXX`
unzip -d $TMPDIR2 $filename
pkgcheck -d $TMPDIR2/$NAME
rm -rf $TMPDIR2
echo "$filename ready to be shipped to CTAN, matching contents of branch $release_branch."
