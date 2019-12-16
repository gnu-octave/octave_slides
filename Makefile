SLIDES=slides

# Files
TARGET=$(SLIDES).pdf
TEX_FILE=$(SLIDES).tex
BIB_FILE=$(SLIDES).bib

LIBREOFFICE_DIR=res/libreoffice
LIBREOFFICE_SRC=$(wildcard $(LIBREOFFICE_DIR)/*.odg)
LIBREOFFICE_PDF=$(subst .odg,.pdf,$(LIBREOFFICE_SRC))

NOTEBOOK_DIR=jupyter
NOTEBOOK_SRC=$(wildcard $(NOTEBOOK_DIR)/*.ipynb)
NOTEBOOK_HTML=$(subst .ipynb,.html,$(NOTEBOOK_SRC))

# Commands
BIBER=biber   $(SLIDES)     > /dev/null
INDEX=texindy $(SLIDES).idx > /dev/null
GLOSSARIES=makeglossaries $(SLIDES) > /dev/null
PDFLATEX=pdflatex -interaction=batchmode
PDFLATEX_FAST= $(PDFLATEX) -draftmode $(TEX_FILE) > /dev/null
PDFLATEX_FINAL=$(PDFLATEX) -synctex=1 $(TEX_FILE) > /dev/null

all: clean libreoffice notebooks
	$(PDFLATEX_FAST)
	$(PDFLATEX_FAST)
	$(BIBER)
	$(PDFLATEX_FAST)
	$(PDFLATEX_FINAL)

libreoffice:
	cd ${LIBREOFFICE_DIR} && libreoffice --convert-to pdf *.odg

notebooks:
	cd ${NOTEBOOK_DIR} && jupyter nbconvert --to html *.ipynb

clean:
	find . -iname "$(SLIDES)*" \
	  -not -name "*.tex" \
	  -not -name "*.bib" \
	  -not -name "$(TARGET)" \
	  -exec $(RM) {} \;
	rm ${LIBREOFFICE_PDF} ${NOTEBOOK_HTML}
