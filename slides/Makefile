SHAREDIR = $(HOME)/.docbook
DBK_HTML = $(SHAREDIR)/xslt20/xslt/slides/html/plain.xsl
DBK_FO = $(SHAREDIR)/xslt20/xslt/slides/fo/plain.xsl
RSRC_BASE = $(SHAREDIR)/resources

XSLPROC = $(SHAREDIR)/dbk5proc
XSLARG = resource.root=$(RSRC_BASE)/base/
XSLARG += resource.slide=$(RSRC_BASE)/slides/
OUTPATH = out/
OUT_PDF = $(OUTPATH)pdf
OUT_HTML = $(OUTPATH)html
EXT = entities.txt

FILES := $(wildcard *.xml)

outpath:
	@mkdir -p $(OUTPATH)
outpdf:
	@mkdir -p $(OUT_PDF)
	@ln -fs ../../img $(OUT_PDF)
outhtml:
	@mkdir -p $(OUT_HTML)
	@ln -fs ../../img $(OUT_HTML)

all: html pdf
check: $(SHAREDIR)/slides-full.rng $(EXT)
	jing $(SHAREDIR)/slides-full.rng $(FILES)

%.html: %.xml $(EXT)
	$(XSLPROC) $(DBK_HTML) $(<) $(OUT_HTML)/$(@F) $(XSLARG)
%.pdf: %.fo
	fop -l en_US $(OUT_PDF)/$(<F) -pdf $(OUT_PDF)/$(@F)
	rm -f $(OUT_PDF)/$(<F)
%.fo: %.xml $(EXT)
	$(XSLPROC) $(DBK_FO) $(<) $(OUT_PDF)/$(@F) $(XSLARG)

html: outhtml index.xml $(EXT)
	$(XSLPROC) $(DBK_HTML) index.xml $(OUT_HTML)/slides.html $(XSLARG)

pdf: outpdf index.fo
	fop -l en-US $(OUT_PDF)/index.fo -pdf $(OUT_PDF)/slides.pdf
	@rm -f index.fo

$(EXT): $(SHAREDIR)/$(EXT)
	@ln -s $(SHAREDIR)/$(EXT) $(EXT)

.PHONY: clean all

clean:
	rm -rf $(OUTPATH)
	rm -rf $(EXT)

