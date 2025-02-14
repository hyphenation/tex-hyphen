#!/bin/sh

NAME=hyph-utf8
TMPDIR=`mktemp -d /tmp/hyphXXXXXX`
mkdir $TMPDIR/$NAME
tds_filename="$TMPDIR/$NAME/$NAME.tds.zip"
ctan_zip_filename="$TMPDIR/$NAME.zip"
tlpsrc_filename_in_main_zip="$TMPDIR/$NAME/$NAME/source/tlpsrc.zip"
tlpsrc_filename_in_tds_zip=$NAME/source/generic/$NAME/tlpsrc.zip

if [ z$1 = z--dry-run ]; then
  DRY_RUN=true
fi

echo "DRY_RUN=‘${DRY_RUN}’"

if [ ! -z "$(git status -s)" ] && [ z$DRY_RUN != ztrue ]; then
  echo 'The repository is dirty; I won’t do anything.  Please clean up first.'
  exit 42
fi

DATE=`date '+%Y.%m.%d'`
if [ z$DRY_RUN = ztrue ]; then
  release_branch=CTAN-dry-run-`date '+%FT%H_%M_%S%z'`
else
  release_branch=CTAN-$DATE
fi
if [ ! -z `git branch | grep -E "^\s*$release_branch$"` ]; then
  echo "The release branch $release_branch already exists; exiting."
  exit 43
fi

current_branch=`git branch --show-current`
git checkout -qb $release_branch

echo $DATE | sed -e 's/\./-/g' >$NAME/source/generic/$NAME/VERSION
git add $NAME/source/generic/$NAME/VERSION
git commit -qm 'Add VERSION for release to CTAN.'

ctan_root=$TMPDIR/$NAME/$NAME
mkdir $ctan_root
git_root=`realpath \`dirname $0\`/..`
cd $git_root

git archive --format=zip --prefix=hyphen-tlpsrc/ --output=$tlpsrc_filename_in_tds_zip $release_branch:TL/tlpkg/tlpsrc
git add $tlpsrc_filename_in_tds_zip
git commit -qm 'Added zip file with .tlpsrc files'

cd $NAME
zip -ryq $TMPDIR/$NAME/hyph-utf8.tds.zip .
cd ..
# git-archive can’t help me with time stamps.  Then I won’t get to use commands like
#   touch -d `date -u -f '%s' -j \`git log --format='%ct' 'HEAD^..'\` '+%FT%TZ'` <some innocent file>
# !
# git archive --format=zip --prefix= --output="$tds_filename" $release_branch:$NAME

rsync -aq $NAME/source/{generic,luatex}/$NAME/ $ctan_root/source/
mv -f $ctan_root/source/{README.md,VERSION} $ctan_root
for topdir in tex doc; do
  rsync -aq $NAME/$topdir/generic/$NAME/ $ctan_root/$topdir/
done
rm $ctan_root/tex/patterns/{quote/hyph-quote-it.tex,txt/hyph-{nb,hi,bn}.pat.txt}
echo "File?" && ls $ctan_root/source/tlpsrc.zip
rm $ctan_root/source/tlpsrc.zip
cp $tlpsrc_filename_in_tds_zip $tlpsrc_filename_in_main_zip
rm $ctan_root/source/tlpsrc.zip

if [ z$DRY_RUN != ztrue ]; then
  git push -q origin $release_branch
fi
git checkout -q $current_branch

pkgcheck --urlcheck -d $ctan_root -T $tds_filename

cd $TMPDIR/$NAME
zip -ryq $ctan_zip_filename hyph-utf8 hyph-utf8.tds.zip
cd $git_root
if [ ! -f $ctan_zip_filename ]; then
  echo "Something went wrong.  The final zip file wasn’t created."
  exit 44
fi
echo "$ctan_zip_filename ready to be shipped to CTAN, matching contents of branch $release_branch."
