#!/bin/bash

source setuptests

xelatex -ini \*xelatex.ini
xetex -ini \*xetex.ini
pdftex -ini pdflatex.ini
