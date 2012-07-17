SHAREDIR = $(HOME)/.docbook
DBK_HTML = $(SHAREDIR)/xslt20/xslt/base/html/docbook.xsl
DBK_FO = $(SHAREDIR)/xslt20/xslt/base/fo/docbook.xsl
RSRC_BASE = $(SHAREDIR)/resources

XSLPROC = $(SHAREDIR)/xslt2proc
XSLARG = resource.root=$(RSRC_BASE)/base/
OUTPATH = out/
OUT_PDF = $(OUTPATH)pdf
OUT_HTML = $(OUTPATH)html

FILES := $(wildcard *.xml)

outpath:
	@mkdir -p $(OUTPATH)
outpdf:
	@mkdir -p $(OUT_PDF)
outhtml:
	@mkdir -p $(OUT_HTML)

all: html pdf
check: $(SHAREDIR)/docbook.rng
	jing $(SHAREDIR)/docbook.rng $(FILES)

$(SHAREDIR)/docbook.rng: $(SHAREDIR)/xslt20/schemas/docbook.rnc
	@trang $(SHAREDIR)/xslt20/schemas/docbook.rnc $(SHAREDIR)/docbook.rng

%.html: %.xml
	$(XSLPROC) $(DBK_HTML) $(<) $(OUT_HTML)/$(@F) $(XSLARG)
%.pdf: %.fo
	fop $(OUT_PDF)/$(<F) -pdf $(OUT_PDF)/$(@F)
	rm -f $(OUT_PDF)/$(<F)
%.fo: %.xml
	$(XSLPROC) $(DBK_FO) $(<) $(OUT_PDF)/$(@F) $(XSLARG)

html: outhtml $(FILES:.xml=.html)
pdf: outpdf $(FILES:.xml=.pdf)

.PHONY: clean all

clean:
	rm -rf $(OUTPATH)

