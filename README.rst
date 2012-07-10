
Install Dependencies
====================

```
yum install docbook5-* libxml libxslt
```

OPTIONAL: Install OFFO hyphenation patterns for ``fop`` (only used for PDF generation)
http://offo.sourceforge.net/hyphenation/index.html

Creating DocBooks
=================

Write the docbook as a *.dbk* file in *doc/*

For book types, write an *index.xml* file that uses xincludes to point to other
docbook files

```
make articles
```
Make .html and .pdf files for each *doc/\*.dbk* file


