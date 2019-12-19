TEX_FILES=handout setup slides

# Directories with files to be cleaned later
LIBREOFFICE_DIR=res/libreoffice
LIBREOFFICE_SRC=$(wildcard $(LIBREOFFICE_DIR)/*.odg)
LIBREOFFICE_PDF=$(subst .odg,.pdf,$(LIBREOFFICE_SRC))

NOTEBOOK_DIR=hands_on
NOTEBOOK_SRC=$(wildcard $(NOTEBOOK_DIR)/*.ipynb)
NOTEBOOK_HTML=$(subst .ipynb,.html,$(NOTEBOOK_SRC))

# Commands and functions for LaTeX Beamer slides
BIBER=biber $(1) > /dev/null
PDFLATEX=pdflatex -interaction=batchmode
PDFLATEX_FAST= $(PDFLATEX) -draftmode $(1) > /dev/null
PDFLATEX_FINAL=$(PDFLATEX) -synctex=1 $(1) > /dev/null
MAKE_TEX_FILES=$(call PDFLATEX_FAST,$(1)) && \
	$(call PDFLATEX_FAST,$(1)) && \
	$(call BIBER,$(1)) && \
	$(call PDFLATEX_FAST,$(1)) && \
	$(call PDFLATEX_FINAL,$(1)) \
	;

all: clean libreoffice
	$(foreach TEX_FILE,$(TEX_FILES), \
	  $(call MAKE_TEX_FILES, $(TEX_FILE)) \
	)

libreoffice:
	cd ${LIBREOFFICE_DIR} && libreoffice --convert-to pdf *.odg

export-notebooks:
	mkdir -p export
	cd ${NOTEBOOK_DIR} && jupyter nbconvert --to html *.ipynb
	mv -t export ${NOTEBOOK_HTML}

clean: clean-tex
	rm -f ${LIBREOFFICE_PDF}

clean-all: clean
	rm -Rf export

clean-tex:
	$(foreach TEX_FILE,$(TEX_FILES), \
	  find . -maxdepth 1 \
	    -iname "$(TEX_FILE)*" \
	    -not -name "*.tex" \
	    -not -name "*.bib" \
	    -not -name "$(TEX_FILE).pdf" \
	    -exec $(RM) {} \; \
	  ; )
