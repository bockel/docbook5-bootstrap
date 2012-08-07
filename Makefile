SHAREDIR = $(HOME)/.docbook
XSL_ARTICLE = $(SHAREDIR)/html.xsl
XSL_SLIDES = $(SHAREDIR)/slides-html.xsl
RSRC_BASE = $(SHAREDIR)/html
CSSTHEME = $(RSRC_BASE)/articles/themes/theme.default.css
CSSFILE = "custom.css"

XSLPROC = $(SHAREDIR)/dbk5proc.py
XSLARG = resource.root=$(RSRC_BASE)
XSLARG += use.extensions=1
XSLARG += css.decoration=0
EXT = entities.txt

ARTICLES := $(wildcard *.article.xml)
SLIDES := $(wildcard *.slides.xml)

all: html pdf
check: check-docbook check-slides
css: $(CSSFILE)

check-docbook: $(EXT)
	jing $(SHAREDIR)/docbook.rng $(ARTICLES)
check-slides: $(EXT)
	jing $(SHAREDIR)/docbook-slides.rng $(SLIDES)

html: html-slides html-article
html-article: $(EXT) $(ARTICLES:.xml=.html)
html-slides: $(EXT) $(SLIDES:.xml=.html)
%.article.html: %.article.xml $(CSSFILE)
	$(XSLPROC) $(XSL_ARTICLE) $(<) $(@F) $(XSLARG) custom.css.source=$(CSSFILE)
%.slides.html: %.slides.xml
	$(XSLPROC) $(XSL_SLIDES) $(<) $(@F) $(XSLARG) slide.root=$(RSRC_BASE)/slides

pdf: pdf-slides pdf-article
pdf-article: $(EXT) $(ARTICLES:.xml=.pdf)
pdf-slides: $(EXT) $(SLIDES:.xml=.pdf)

%.article.pdf: %.article.html
	phantomjs $(SHAREDIR)/rasterize.js $(<) $(@)
%.slides.pdf: %.slides.html
	sh $(SHAREDIR)/slides-html2pdf.sh $(SHAREDIR)/slides-rasterize.js $(<)

$(EXT): $(SHAREDIR)/$(EXT)
	@ln -s $(SHAREDIR)/$(EXT) $(EXT)

$(CSSFILE):
	@echo "<style>" > $(CSSFILE)
	@csscombine -m $(CSSTHEME) >> $(CSSFILE) 2> /dev/null
	@echo "</style>" >> $(CSSFILE)

.PHONY: clean

clean:
	@rm -f *.pdf *.html $(CSSFILE)

