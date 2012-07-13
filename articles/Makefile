SHAREDIR = ../share/xslt20/xslt/base
DBK_HTML = $(SHAREDIR)/html/docbook.xsl
DBK_FO = $(SHAREDIR)/fo/docbook.xsl

XSLPROC = ../xslt2proc
OUTPATH = out/
OUT_PDF = $(OUTPATH)pdf
OUT_HTML = $(OUTPATH)html

FILES := $(wildcard *.dbk)

outpath:
	@mkdir -p $(OUTPATH)
outpdf:
	@mkdir -p $(OUT_PDF)
outhtml:
	@mkdir -p $(OUT_HTML)

all: html pdf
check:
	xmllint --stream --xinclude --noout --relaxng ../share/docbook.rng $(FILES)

%.html: %.dbk
	$(XSLPROC) $(DBK_HTML) $(<) $(OUT_HTML)/$(@F)
%.pdf: %.fo
	fop -l en_US $(OUT_PDF)/$(<F) -pdf $(OUT_PDF)/$(@F)
	rm -f $(OUT_PDF)/$(<F)
%.fo: %.dbk
	$(XSLPROC) $(DBK_FO) $(<) $(OUT_PDF)/$(@F)

html: outhtml $(FILES:.dbk=.html)
pdf: outpdf $(FILES:.dbk=.pdf)

.PHONY: clean all

clean:
	rm -rf $(OUTPATH)

