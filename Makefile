SLIDES=slides
BIBLIO=mybib

# Files
TARGET=$(SLIDES).pdf
TEX_FILE=$(SLIDES).tex
BIB_FILE=$(SLIDES).bib

# Commands
BIBER=biber   $(SLIDES)     > /dev/null
INDEX=texindy $(SLIDES).idx > /dev/null
GLOSSARIES=makeglossaries $(SLIDES) > /dev/null
PDFLATEX=pdflatex -interaction=batchmode
PDFLATEX_FAST= $(PDFLATEX) -draftmode $(TEX_FILE) > /dev/null
PDFLATEX_FINAL=$(PDFLATEX) -synctex=1 $(TEX_FILE) > /dev/null

slides: clean libreoffice jupyter_notebooks
	$(PDFLATEX_FAST)
	$(PDFLATEX_FAST)
	$(BIBER)
	#$(GLOSSARIES)
	#$(INDEX)
	$(PDFLATEX_FAST)
	#$(GLOSSARIES)
	#$(INDEX)
	$(PDFLATEX_FINAL)

libreoffice:
	cd res/libreoffice && libreoffice --convert-to pdf *.odg

jupyter_notebooks:
	cd jupyter && jupyter nbconvert --to html *.ipynb

clean:
	find . -iname "$(SLIDES)*" \
	  -not -name "*.tex" \
	  -not -name "*.bib" \
	  -not -name "$(TARGET)" \
	  -exec $(RM) {} \;
