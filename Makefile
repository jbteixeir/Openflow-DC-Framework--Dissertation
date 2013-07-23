###########################################################
#
# Makefile for LaTeX docs
#
# $Id: 
#

.SUFFIXES:
.SUFFIXES: .ps .dvi .tex

TEXINPUTS := .:${TEXINPUTS}
BIBINPUTS := .:${TEXINPUTS}

PDFLATEX ?= pdflatex
TEX = $(wildcard *.tex)

pdf: sig-alternate.pdf

clean:
	$(RM) *.aux *.log *.bbl *.blg *~ \#*\# *.toc *.idx
	$(RM) $(patsubst %.tex, %.ps, $(wildcard *.tex))
	$(RM) $(patsubst %.tex, %.dvi, $(wildcard *.tex))
	$(RM) $(patsubst %.tex, %.pdf, $(wildcard *.tex))

distclean: clean
	$(RM) $(patsubst %.fig, %.eps, $(wildcard *.fig))
	$(RM) $(patsubst %.obj, %.eps, $(wildcard *.obj))

%.pdf: $(TEX) $(wildcard *.bib)
	$(PDFLATEX) $*
	-bibtex $*
	if [ -e $*.toc ] ; then $(PDFLATEX) $* ; fi
	if [ -e $*.bbl ] ; then $(PDFLATEX) $* ; fi
	if egrep Rerun $*.log ; then $(PDFLATEX) $* ; fi
	if egrep Rerun $*.log ; then $(PDFLATEX) $* ; fi
	if egrep Rerun $*.log ; then $(PDFLATEX) $* ; fi


toc: $(wildcard *.tex)
	@egrep -h "\\\((sub)*section|chapter)" $+ | egrep -v "^%" | \
                sed -e 's/\\chapter//;                          \
                s/\\section/    /;                              \
                s/\\subsection/         /;                      \
                s/\\subsubsection/                      /;      \
                s/\\.*{//g;s/[{}]//g' > $@
