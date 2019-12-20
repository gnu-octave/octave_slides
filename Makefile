TEX_FILES=handout setup slides

ROOT_DIR=$(shell pwd)

# Directories with files to be cleaned later
LIBREOFFICE_DIR=${ROOT_DIR}/res/libreoffice
LIBREOFFICE_SRC=$(wildcard $(LIBREOFFICE_DIR)/*.odg)
LIBREOFFICE_SVG=$(wildcard $(LIBREOFFICE_DIR)/*.svg)
LIBREOFFICE_PDF=$(subst .odg,.pdf,$(LIBREOFFICE_SRC))

NOTEBOOK_DIR=${ROOT_DIR}/hands_on
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

all: tex ${NOTEBOOK_DIR}.zip

tex: clean-tex libreoffice
	$(foreach TEX_FILE,$(TEX_FILES),      \
	  $(call MAKE_TEX_FILES, $(TEX_FILE)) \
	)

libreoffice: clean-$(notdir ${LIBREOFFICE_DIR})
	cd ${LIBREOFFICE_DIR} && libreoffice --convert-to pdf *.odg
	cd ${LIBREOFFICE_DIR} \
	&& libreoffice --convert-to svg  octave_c_cpp_fortran_*.odg

$(notdir ${NOTEBOOK_DIR}).zip: clean-$(notdir ${NOTEBOOK_DIR})
	$(RM) ${NOTEBOOK_DIR}.zip
	cd ${NOTEBOOK_DIR} && jupyter nbconvert --to html *.ipynb
	mkdir  -p ${NOTEBOOK_DIR}/html
	mv     -t ${NOTEBOOK_DIR}/html ${NOTEBOOK_HTML}
	zip -q -r ${NOTEBOOK_DIR}.zip  $(notdir ${NOTEBOOK_DIR})
	$(RM) -R  ${NOTEBOOK_DIR}/html


clean: clean-tex                          \
       clean-$(notdir ${NOTEBOOK_DIR})    \
       clean-$(notdir ${LIBREOFFICE_DIR})

clean-tex:
	$(foreach TEX_FILE,$(TEX_FILES), \
	  find . -maxdepth 1             \
	    -iname "$(TEX_FILE)*"        \
	    -not -name "*.tex"           \
	    -not -name "*.bib"           \
	    -not -name "$(TEX_FILE).pdf" \
	    -exec $(RM) {} \;            \
	  ; )

clean-$(notdir ${NOTEBOOK_DIR}):
	find ${NOTEBOOK_DIR} -maxdepth 1         \
	  \( -iname "*.exe" -o -iname "*.oct" \) \
	  -exec $(RM) {} \;
	find ${NOTEBOOK_DIR} -type d -iname ".ipynb_checkpoints" \
	  -exec $(RM) -R {} \;

clean-$(notdir ${LIBREOFFICE_DIR}):
	$(RM) ${LIBREOFFICE_PDF} ${LIBREOFFICE_SVG}
