.. _fop: http://xmlgraphics.apache.org/fop/
.. _jing: http://code.google.com/p/jing-trang/
.. _trang: https://code.google.com/p/jing-trang/
.. _docbook: http://docbook.org
.. _DocBook5: http://www.docbook.org/specs/docbook-5.0-spec-cd-03.html
.. _`Apache 2.0 License`: http://www.apache.org/licenses/LICENSE-2.0
.. _libxml: http://xmlsoft.org/
.. _libxslt: http://xmlsoft.org/XSLT/
.. _phantomjs: http://phantomjs.org/
.. _python: http://python.org/
.. _lxml: http://lxml.de/
.. _cssutils: https://bitbucket.org/cthedot/cssutils

This is a bootstrap repository for developing and generating documents using
docbook_.

All document stubs and content are formatted using DocBook5_. Documents are
generated using the DocBook5_ XSLT2.0 stylesheets.

The contents of this repository are provided under the terms of the `Apache 2.0
License`_.

Installation
============

1. Install dependencies (libxml_, libxslt_, jing_, python_ with lxml_, cssutils_ modules)
    * On Fedora & RHEL::

        sudo yum install -y libxml libxslt jing trang python python-lxml python-cssutils

    * On Debian/Ubuntu::

        apt-get ...

2. Clone the repository into ``$HOME/.docbook`` or softlink it using ``ln -s``

3. Install phantomjs_ and ensure ``phantomjs`` is in ``$PATH``
   (phantomjs_ is used to render PDFs of article and slide content)


Creating DocBooks
=================

1. Use the **articles**, **book**, or **slides** directory contents based on
   whether you are building a docbook article, book, or set of slides. The
   scripts assume that all docbook files end with a specific extension:

    * Article: *.article.xml*
    * Book: *.book.xml*
    * Slides: *.slides.xml*

2. Write the contents according to the DocBook5_ specification

3. Compile the contents into an html or pdf file using ``make``.

DocBooks can be built by hand using ``xsltproc`` or the provided
``share/dbk5proc.py`` script and the appropriate xslt files.

Makefile Usage
==============

``make html``:
 compiles the docbook into a single HTML file

``make pdf``:
 compiles the docbook into an HTML file, then uses ``phantomjs`` to render it into a PDF

``make all``:
 generates both the html and pdf content

``make check``:
 validates the format of all of the *.xml* files using an appropriate RelaxNG
 schema

``make clean``:
 cleans up all of the generated output files

