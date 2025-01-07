#!/bin/sh

NAME=hyph-utf8
TMPDIR=`mktemp -d /tmp/hyphXXXXXX`
mkdir $TMPDIR/$NAME
tds_filename="$TMPDIR/$NAME/$NAME.tds.zip"
ctan_zip_filename="$TMPDIR/$NAME/$NAME.zip"
tlpsrc_filename_in_main_zip="$TMPDIR/$NAME/$NAME/source/tlpsrc.zip"
tlpsrc_filename_in_tds_zip=$NAME/source/generic/$NAME/tlpsrc.zip

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

echo $DATE | sed -e 's/\./-/g' >$NAME/source/generic/$NAME/VERSION
git add $NAME/source/generic/$NAME/VERSION
git commit -m 'Add VERSION for release to CTAN.'

ctan_root=$TMPDIR/$NAME/$NAME
mkdir $ctan_root
git_root=`realpath \`dirname $0\`/..`
cd $git_root
echo "git_root = $git_root"
# rsync -aq $NAME/source/generic/$NAME/{README.md,VERSION} $ctan_root/

git archive --format=zip --prefix=hyphen-tlpsrc/ --output=$tlpsrc_filename_in_tds_zip $release_branch:TL/tlpkg/tlpsrc
git add $tlpsrc_filename_in_tds_zip
git commit -m 'Added zip file with .tlpsrc files'

TMPDIR3=`mktemp -d /tmp/hyphXXXXXX`
cd hyph-utf8
echo "TMPDIR3 = $TMPDIR3"
rsync -avq . $TMPDIR3
cd $TMPDIR3
zip -ryq hyph-utf8.tds.zip .
mv -f hyph-utf8.tds.zip $TMPDIR/$NAME
cd $git_root
# git-archive can’t help me with time stamps.  Then I won’t get to use commands like
#   touch -d `date -u -f '%s' -j \`git log --format='%ct' 'HEAD^..'\` '+%FT%TZ'` <some innocent file>
# !
# git archive --format=zip --prefix= --output="$tds_filename" $release_branch:$NAME

rsync -aq $NAME/source/{generic,luatex}/$NAME/ $ctan_root/source/
echo 'CTAN root:'
ls -R $ctan_root
echo 'Moving README.md ...'
mv -f $ctan_root/source/README.md $ctan_root/..
echo '... moved.'
for topdir in tex doc; do
  rsync -aq $NAME/$topdir/generic/$NAME/ $ctan_root/$topdir/
done
rm $ctan_root/tex/patterns/{quote/hyph-quote-it.tex,txt/hyph-{nb,hi,bn}.pat.txt}
cp $tlpsrc_filename_in_tds_zip $tlpsrc_filename_in_main_zip

git push origin $release_branch
git checkout $current_branch

TMPDIR2=`mktemp -d /tmp/hyphXXXXXX`
pkgcheck -d $ctan_root -T $tds_filename
# rm -rf $TMPDIR2

pushd $TMPDIR/$NAME
zip -ryq ../hyph-utf8.zip README.md hyph-utf8 hyph-utf8.tds.zip
popd
echo "$TMPDIR/$NAME.zip ready to be shipped to CTAN, matching contents of branch $release_branch."
