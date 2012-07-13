.. _SAXON: http://saxon.sourceforge.net/
.. _ant: http://ant.apache.org/
.. _fop: http://xmlgraphics.apache.org/fop/
.. _libxml: http://xmlsoft.org/
.. _trang: https://code.google.com/p/jing-trang/
.. _docbook: http://docbook.org
.. _DocBook5: http://www.docbook.org/specs/docbook-5.0-spec-cd-03.html

This is a bootstrap repository for developing and generating documents using
docbook_.

All document stubs and content are formatted using DocBook5_. Documents are
generated using the DocBook5_ XSLT2.0 stylesheets.

Installation
============

1. Install dependencies (SAXON_, ant_, fop_, libxml_, trang_)
    * On Fedora & RHEL::

        sudo yum install -y saxon ant fop libxml trang

    * On Debian/Ubuntu::

        apt-get ...

2. Clone the repository into ``$HOME/.docbook`` or softlink it using ``ln -s``

3. Run ``sh update.sh`` or update manually

4. *optional* Install OFFO hyphenation patterns for ``fop`` (only used for PDF
   generation): http://offo.sourceforge.net/hyphenation/index.html

Manual Update
-------------

1. Checkout latest docbook xslt2.0 files::

    git submodule update --init
    git submodule foreach git checkout master
    git submodule foreach git pull

2. Generate the ``docbook.rng`` file::

    cd share
    trang xslt20/schema/docbook.rnc docbook.rng

3. Build the xslt2.0 dependencies::

    cd xslt20
    ant

Fedora & RHEL
-------------

On Fedora and RHEL, there is a missing jar that causes ``fop`` fail when
processing SVG images.

To fix:

1. Download the **xml-commons-external-*-bin** binary package from
   http://xerces.apache.org/mirrors.cgi

2. Unarchive the downloaded package and copy the ``xml-apis-ext.jar`` file
   ``/usr/share/java/`` or other location

3. Update (or create) the ``$HOME/.foprc`` file to add the jar to the Java
   CLASSPATH::

    CLASSPATH=$CLASSPATH:/usr/share/java/xml-apis-ext.jar


Creating DocBooks
=================

1. Use the **articles**, **book**, or **slides** directory contents based on
   whether you are building a docbook article, book, or set of slides. The
   scripts assume that all docbook files end in a *.dbk* extension.

   For books and slides, the makefiles assume that the top-level file is named
   *index.dbk*

2. Write the contents according to the DocBook5_ specification

3. Compile the contents into an html or pdf file. If using ``make``, all output
   files will be placed in an *out/* directory

Makefile Usage
==============

``make html``:
 compiles the docbook into a single HTML file

``make pdf``:
 compiles the docbook into an fop_ file, then converts that fop into a pdf

``make all``:
 generates both the html and pdf content

``make check``:
 validates the format of all of the *.dbk* files using an appropriate RelaxNG
 schema

``make clean``:
 cleans up all of the generated output files

