#!/bin/bash

source setuptests

platex -ini platex.ini
uplatex -ini uplatex.ini
xelatex -ini \*xelatex.ini
xetex -ini \*xetex.ini
pdftex -ini -etex pdflatex.ini
