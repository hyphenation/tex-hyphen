#!/bin/bash

source setuptests

platex -ini platex.ini
xelatex -ini \*xelatex.ini
xetex -ini \*xetex.ini
pdftex -ini -etex pdflatex.ini
