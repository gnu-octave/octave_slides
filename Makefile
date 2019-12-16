SLIDES=slides setup

# Directories with files to be cleaned later
LIBREOFFICE_DIR=res/libreoffice
LIBREOFFICE_SRC=$(wildcard $(LIBREOFFICE_DIR)/*.odg)
LIBREOFFICE_PDF=$(subst .odg,.pdf,$(LIBREOFFICE_SRC))

NOTEBOOK_DIR=jupyter
NOTEBOOK_SRC=$(wildcard $(NOTEBOOK_DIR)/*.ipynb)
NOTEBOOK_HTML=$(subst .ipynb,.html,$(NOTEBOOK_SRC))

# Commands and functions for LaTeX Beamer slides
BIBER=biber $(1) > /dev/null
PDFLATEX=pdflatex -interaction=batchmode
PDFLATEX_FAST= $(PDFLATEX) -draftmode $(1) > /dev/null
PDFLATEX_FINAL=$(PDFLATEX) -synctex=1 $(1) > /dev/null
MAKE_SLIDES=$(call PDFLATEX_FAST,$(1)) && \
	$(call PDFLATEX_FAST,$(1)) && \
	$(call BIBER,$(1)) && \
	$(call PDFLATEX_FAST,$(1)) && \
	$(call PDFLATEX_FINAL,$(1)) \
	;

all: clean libreoffice notebooks
	$(foreach SLIDE,$(SLIDES), \
	  $(call MAKE_SLIDES, $(SLIDE)) \
	)

libreoffice:
	cd ${LIBREOFFICE_DIR} && libreoffice --convert-to pdf *.odg

notebooks:
	cd ${NOTEBOOK_DIR} && jupyter nbconvert --to html *.ipynb

clean:
	$(foreach SLIDE,$(SLIDES), \
	  find . -iname "$(SLIDE)*" \
	    -not -name "*.tex" \
	    -not -name "*.bib" \
	    -not -name "$(SLIDE).pdf" \
	    -exec $(RM) {} \; \
	  ; )
	rm -f ${LIBREOFFICE_PDF} ${NOTEBOOK_HTML}
