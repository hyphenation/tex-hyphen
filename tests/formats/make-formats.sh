#!/bin/bash

source setuptests

xetex -jobname xelatex -ini \*unicode-letters \\input latex.ltx
xetex -jobname xetex -ini \*unicode-letters \\input plain \\dump
pdftex -jobname pdflatex -ini \\pdfoutput1 \\input latex.ltx
