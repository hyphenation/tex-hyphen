#!/bin/sh

# Mini-howto:
# 1. docker pull adnrv/texlive
# 2. docker run -it -v $(pwd):/home adnrv/texlive sh build.sh

# In Docker container from image adnrv/texlive
WORKDIR=`mktemp -d /tmp/hyphXXXXXX`
cd $WORKDIR
git clone http://github.com/hyphenation/tex-hyphen
mv -f tex-hyphen/hyph-utf8/tex/generic /usr/local/texlive/texmf-local/tex
mv -f tex-hyphen/TL/texmf-dist/tex/generic/config/language.dat /usr/local/texlive/texmf-var/tex/generic/config
# FIXME Get the real version 5 files! FIXME
mkdir /usr/local/texlive/texmf-local/tex/generic/hyphen
for grhyph4 in tex-hyphen/old/hyphen/gr?hyph4.tex; do
  grhyph5=`echo $grhyph4 | sed -e 's/^.*\///; s/4/5/'`
  mv -f $grhyph4 /usr/local/texlive/texmf-local/tex/generic/hyphen/$grhyph5
done
mv -f tex-hyphen/old/hyphen/ibyhyph.tex /usr/local/texlive/texmf-local/tex/generic/hyphen
touch /usr/local/texlive/texmf-local/tex/generic/hyphen/ruhyphen.tex
touch /usr/local/texlive/texmf-local/tex/generic/hyphen/ukrhyph.tex
# END OF FIXME
mktexlsr
fmtutil -sys --all
