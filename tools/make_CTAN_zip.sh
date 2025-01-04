#!/bin/sh

NAME=hyph-utf8
TMPDIR=`mktemp -d /tmp/hyphXXXXXX`
mkdir $TMPDIR/$NAME
tds_filename="$TMPDIR/$NAME/$NAME.tds.zip"
tlpsrc_filename="$TMPDIR/$NAME.tlpsrc.zip"

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

current_branch=`git branch --show-current`
git checkout -b $release_branch

echo $DATE | sed -e 's/\./-/g' >$NAME/VERSION
git add $NAME/VERSION
git commit -m 'Add VERSION for release to CTAN.'
git push
git checkout $current_branch

cd `dirname $0`/..
git archive --format=zip --prefix=$NAME/ --output="$tds_filename" $release_branch:$NAME
ctan_root=$TMPDIR/$NAME/$NAME
mkdir $ctan_root
# Need to be in root directory.  FIXME!
for topdir in tex doc source; do
  rsync -avP $NAME/$topdir/{generic,luatex}/$NAME/ $ctan_root/$topdir/
  rsync -avP $NAME/{README,VERSION} $ctan_root
done
TMPDIR2=`mktemp -d /tmp/hyphXXXXXX`
unzip -d $TMPDIR2 $tds_filename
pkgcheck -d $TMPDIR2/$NAME
rm -rf $TMPDIR2
echo "$tds_filename ready to be shipped to CTAN, matching contents of branch $release_branch."
