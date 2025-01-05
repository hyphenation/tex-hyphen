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
git push origin $release_branch

ctan_root=$TMPDIR/$NAME/$NAME
mkdir $ctan_root
cd `dirname $0`/..
rsync -aq $NAME/{README.md,VERSION} $ctan_root/
git checkout $current_branch

git archive --format=zip --prefix=$NAME/ --output="$tds_filename" $release_branch:$NAME

rsync -aq $NAME/source/{generic,luatex}/$NAME/ $ctan_root/source/
for topdir in tex doc; do
  rsync -aq $NAME/$topdir/generic/$NAME/ $ctan_root/$topdir/
done
rm $ctan_root/tex/patterns/{quote/hyph-quote-it.tex,txt/hyph-{nb,hi,bn}.pat.txt}

git archive --format=zip --prefix=hyphen-tlpsrc/ --output=$TMPDIR/$NAME/$NAME/source/tlpsrc.zip $release_branch:TL/tlpkg/tlpsrc

TMPDIR2=`mktemp -d /tmp/hyphXXXXXX`
echo "CTAN-compliant directories:"
pkgcheck -d $ctan_root
unzip -q -d $TMPDIR2 $tds_filename
echo "TDS zip:"
pkgcheck -d $TMPDIR2/$NAME
rm -rf $TMPDIR2

pushd $TMPDIR/$NAME
zip -ryq hyph-utf8.zip hyph-utf8 hyph-utf8.tds.zip
popd
echo "$TMPDIR/$NAME/$NAME.zip ready to be shipped to CTAN, matching contents of branch $release_branch."
