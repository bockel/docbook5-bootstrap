SHAREDIR = $(HOME)/.docbook
XSL_ARTICLE = $(SHAREDIR)/html.xsl
XSL_SLIDES = $(SHAREDIR)/slides-html.xsl
RSRC_BASE = $(SHAREDIR)/html

XSLPROC = $(SHAREDIR)/dbk5proc.py
XSLARG = resource.root=$(RSRC_BASE)
XSLARG += use.extensions=1
XSLARG += css.decoration=0
EXT = entities.txt

ARTICLES := $(wildcard *.article.xml)
SLIDES := $(wildcard *.slides.xml)

all: html pdf
check: check-docbook check-slides

check-docbook: $(EXT)
	jing $(SHAREDIR)/docbook.rng $(ARTICLES)
check-slides: $(EXT)
	jing $(SHAREDIR)/docbook-slides.rng $(SLIDES)

html: outhtml html-slides html-article
html-article: $(EXT) $(ARTICLES:.xml=.html)
html-slides: $(EXT) $(SLIDES:.xml=.html)
%.article.html: %.article.xml
	$(XSLPROC) $(XSL_ARTICLE) $(<) $(@F) $(XSLARG)
%.slides.html: %.slides.xml
	$(XSLPROC) $(XSL_SLIDES) $(<) $(@F) $(XSLARG) slide.root=$(RSRC_BASE)/slides

pdf: outpdf pdf-slides pdf-article
pdf-article: $(EXT) $(ARTICLES:.xml=.pdf)
pdf-slides: $(EXT) $(SLIDES:.xml=.pdf)

%.article.pdf: %.article.html
	phantomjs $(SHAREDIR)/rasterize.js $(<) $(@)
%.slides.pdf: %.slides.html
	sh $(SHAREDIR)/slides-html2pdf.sh $(SHAREDIR)/slides-rasterize.js $(<)

$(EXT): $(SHAREDIR)/$(EXT)
	@ln -s $(SHAREDIR)/$(EXT) $(EXT)

.PHONY: clean

clean:
	@rm -f *.pdf *.html

