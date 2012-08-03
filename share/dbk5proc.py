#!/bin/env python
from pygments import lexers, highlight, formatters
from pygments.util import ClassNotFound
from lxml import etree
from lxml.html import fragment_fromstring

def html_highlight(context, language, code, config):
    """
    Highlight the given ``code`` in the given ``language``.  ``context`` is
    the XPath context, in which this function was applied.  ``config`` is
    ignored.

    Return a list of HTML nodes containined the highlighted code.
    """
    # necessary, because lxml somehow fails to correctly pass code (reason
    # is unknown to me)
    if not code:
        code = context.context_node.xpath('.//text()')
    try:
        lang = language[0].lower()
        lexer = lexers.get_lexer_by_name(lang)
    except ClassNotFound:
        lexer = lexers.guess_lexer(code[0])
    html = highlight(code[0], lexer, formatters.HtmlFormatter(nowrap=True))
    highlight_div = fragment_fromstring(html, create_parent='code')
    highlight_div.set('class', lang)
    return [highlight_div]

def main(xslt_file,xml_file,out_file,args):
    xslt_params = dict()
    for p in args:
        eq = p.index('=')
        xslt_params[p[0:eq]] = etree.XSLT.strparam(p[eq+1:])
    # print(xslt_params)

    xhl = etree.FunctionNamespace('http://net.sf.xslthl/ConnectorXalan')
    xhl.prefix = 'xhl'
    xhl['highlight'] = html_highlight

    xml_p = etree.XMLParser(remove_blank_text=True, resolve_entities=True, load_dtd=True)
    transform = etree.XSLT(etree.parse(xslt_file, xml_p))
    document = etree.parse(xml_file, xml_p)
    document.xinclude()
    out_file.write(str(transform(document, **xslt_params)))
    return 0

def print_usage(cmd):
    print("USAGE: python %s <xslt> <in_xml> <out_file>"%(cmd))

if __name__=="__main__":
    import sys
    exit = 1
    if len(sys.argv) > 3:
        outf = sys.stdout
        if sys.argv[3] != '-':
            outf = open(sys.argv[3],'w')
        try:
            exit = main(sys.argv[1],sys.argv[2],outf,sys.argv[4:])
        finally:
            outf.close()
    if exit != 0:
        print_usage(sys.argv[0])
    sys.exit(exit)
