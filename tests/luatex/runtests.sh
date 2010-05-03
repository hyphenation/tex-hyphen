#!/bin/sh

TEXINPUTS=".:../../hyph-utf8/tex//:$TEXINPUTS"
export TEXINPUTS

set -e

# this will actually output the formats here
fmtutil --byfmt luatex --fmtdir ..
fmtutil --byfmt lualatex --fmtdir ..

for f in *.tex; do
    case $f in
        latex-*) lualatex $f
            ;;
        plain-*) luatex $f
            ;;
    esac
done

echo ""
echo "Formats and test files compiled successfully."
echo "You should check the logs of the test files."
