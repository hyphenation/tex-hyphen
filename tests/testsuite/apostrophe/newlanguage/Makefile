RM=rm -f

test: xetex.fmt test-apostrophe.tex
	xetex test-apostrophe.tex

xetex.fmt:
	export TEXINPUTS=./texmf//: ; xetex -ini \*xetex.ini

clean:
	$(RM) xetex.fmt xetex.log
