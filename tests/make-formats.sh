#!/bin/sh

source setuptests

xetex  -jobname=xelatex  -ini \*unicode-letters \\input latex.ltx
xetex  -jobname=xetex    -ini \*unicode-letters \\input plain \\dump
pdftex -jobname=pdflatex -ini \\pdfoutput1 \\input latex.ltx
# TODO: this might need to be fixed?
ptex   -jobname=platex   -ini -progname=platex platex.ini
