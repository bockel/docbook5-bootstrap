SHAREDIR = $(HOME)/.docbook
DBK_HTML = $(SHAREDIR)/html.xsl
DBK_FO = $(SHAREDIR)/xslt/fo/docbook.xsl
RSRC_BASE = $(SHAREDIR)/resources

XSLPROC = $(SHAREDIR)/dbk5proc.py
XSLARG = resource.root=$(RSRC_BASE)
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
check: $(SHAREDIR)/docbook.rng $(EXT)
	jing $(SHAREDIR)/docbook.rng $(FILES)

%.html: %.xml $(EXT)
	$(XSLPROC) $(DBK_HTML) $(<) $(OUT_HTML)/$(@F) $(XSLARG)
%.pdf: %.fo
	fop $(OUT_PDF)/$(<F) -pdf $(OUT_PDF)/$(@F)
	rm -f $(OUT_PDF)/$(<F)
%.fo: %.xml $(EXT)
	$(XSLPROC) $(DBK_FO) $(<) $(OUT_PDF)/$(@F) $(XSLARG)

html: outhtml $(FILES:.xml=.html)
pdf: outpdf $(FILES:.xml=.pdf)

$(EXT): $(SHAREDIR)/$(EXT)
	@ln -s $(SHAREDIR)/$(EXT) $(EXT)

.PHONY: clean all

clean:
	rm -rf $(OUTPATH)
	rm -rf $(EXT)

