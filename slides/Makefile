SHAREDIR = $(HOME)/.docbook
DBK_HTML = $(SHAREDIR)/xslt20/xslt/slides/html/plain.xsl
DBK_FO = $(SHAREDIR)/xslt20/xslt/slides/fo/plain.xsl

XSLPROC = $(SHAREDIR)/xslt2proc
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
check: $(SHAREDIR)/slides-full.rng
	xmllint --stream --xinclude --noout --relaxng $(SHAREDIR)/slides-full.rng $(FILES)

%.html: %.dbk
	$(XSLPROC) $(DBK_HTML) $(<) $(OUT_HTML)/$(@F)
%.pdf: %.fo
	fop -l en_US $(OUT_PDF)/$(<F) -pdf $(OUT_PDF)/$(@F)
	rm -f $(OUT_PDF)/$(<F)
%.fo: %.dbk
	$(XSLPROC) $(DBK_FO) $(<) $(OUT_PDF)/$(@F)

html: outhtml index.dbk
	$(XSLPROC) $(DBK_HTML) index.dbk $(OUT_HTML)/slides.html

pdf: outpdf index.fo
	fop -l en-US $(OUT_PDF)/index.fo -pdf $(OUT_PDF)/slides.pdf
	@rm -f index.fo

.PHONY: clean all

clean:
	rm -rf $(OUTPATH)

