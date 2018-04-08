#/bin/sh

# Compare dictionary with original libthai source
#
# It takes libthai dict source dir as the argument, then scans all dicts
# under that dir and try hyphenating them, and finally compares the
# results with current source.
#
# For each dict, the new source is created as *.new, and the diffs as *.diff.
#
# Usage diff-dicts.sh {libthai-dict-src-dir}

if [ $# -ne 1 ]; then
  echo "Usage: diff-dicts.sh {libthai-dict-src-dir}"
  exit 1
fi

DICTS=`echo tdict-*.txt`
DIR=$1

for d in ${DICTS}; do

  cat > odict.tex << EOT
\\documentclass{article}
\\usepackage[thai]{babel}
\\usepackage[utf8x]{inputenc}

\\begin{document}
EOT

  sed -e 's/.*/\\showhyphens{&}/' ${DIR}/$d >> odict.tex

  cat >> odict.tex << EOT
\\end{document}
EOT

  NEWDICT=$d.new
  pdflatex odict.tex \
    | iconv -f tis-620 -t utf-8 | grep '^\[\]' | cut -d' ' -f3 > ${NEWDICT}

  diff -u $d ${NEWDICT} > $d.diff

  rm odict.tex odict.aux odict.log
done

