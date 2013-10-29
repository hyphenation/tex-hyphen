#/bin/sh

cat > hyphtest.tex << EOT
\\documentclass{article}
\\usepackage[thai]{babel}
\\usepackage[utf8x]{inputenc}

\\begin{document}
EOT

sed -e 's/-//g; s/.*/\\showhyphens{&}/' thai.dic >> hyphtest.tex

cat >> hyphtest.tex << EOT
\\end{document}
EOT

pdflatex hyphtest.tex \
  | grep '^\[\]' | cut -d' ' -f3 | iconv -f tis-620 -t utf-8 > hyphres.dic

diff -u thai.dic hyphres.dic > hyph.diff

ERRS=`grep '^+[^+]' hyph.diff | wc -l | cut -d' ' -f1`
if test ${ERRS} -ne 0; then
  echo "${ERRS} words are not correctly hyphenated. Check hyph.diff for the list."
  exit 1
fi

exit 0

