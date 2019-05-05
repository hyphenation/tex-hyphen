#!/bin/bash

source setuptests

eptex -ini \*platex.ini
euptex -ini \*uplatex.ini
xelatex -ini \*xelatex.ini
xetex -ini \*xetex.ini
pdftex -ini -etex pdflatex.ini
pdftex -ini \*pdfetex.ini
eptex -ini \*eptex.ini
