DBK_HTML = /usr/share/sgml/docbook/xsl-ns-stylesheets/html/docbook.xsl
DBK_FO = /usr/share/sgml/docbook/xsl-ns-stylesheets/fo/docbook.xsl

DPATH = doc/
IMG_PATH = img/
OUTPATH = out/
OUT_PDF = $(OUTPATH)pdf
OUT_HTML = $(OUTPATH)html
TMPXML = $(OUTPATH)tmp.xml

FILES := $(wildcard $(DPATH)*.dbk)

outpath:
	@mkdir -p $(OUTPATH)
outpdf:
	@mkdir -p $(OUT_PDF)
outhtml:
	@mkdir -p $(OUT_HTML)
outhtmlm:
	@mkdir -p $(OUT_HTMLM)


articles: articles_html articles_pdf
book: book_html book_pdf


%.html: %.dbk
	xsltproc -xinclude -o $(OUT_HTML)/$(@F) $(DBK_HTML) $(<)
%.pdf: %.fo
	fop -l en_US $(OUT_PDF)/$(<F) -pdf $(OUT_PDF)/$(@F)
	rm -f $(OUT_PDF)/$(<F)
%.fo: %.dbk
	xsltproc -xinclude -o $(OUT_PDF)/$(@F) $(DBK_FO) $(<)

articles_html: outhtml $(FILES:.dbk=.html)
book_html: outhtml $(DPATH)index.dbk
	xsltproc -xinclude -o $(OUT_HTML)/book.html $(DBK_HTML) $(DPATH)index.dbk

articles_pdf: outpdf $(FILES:.dbk=.pdf)
book_pdf: outpdf $(OUT_PDF)/book.fo
	fop -l en-US $(OUT_PDF)/book.fo -pdf $(OUT_PDF)/book.pdf
	rm -f $(OUT_PDF)/book.fo

.PHONY: clean

clean:
	rm -rf $(OUTPATH)

