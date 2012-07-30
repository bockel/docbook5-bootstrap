<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:d="http://docbook.org/ns/docbook" version="1.0" exclude-result-prefixes="xhtml d">
    <xsl:import href="html.xsl"/>
    <xsl:output method="html" encoding="UTF-8" indent="no"/>

    <xsl:template name="add.slide.htmlheader">
        <xsl:comment>insert html header css and js here</xsl:comment>
    </xsl:template>
    <xsl:template name="add.slide.header">
    </xsl:template>
    <xsl:template name="add.slide.footer">
        <div class="footer">
            <xsl:value-of select="concat(count(preceding-sibling::d:foil|preceding-sibling::d:foilgroup/d:foil)+1,'/',count(/d:slides/d:foil|/d:slides/d:foilgroup/d:foil))"/>
        </div>
    </xsl:template>
    <xsl:template name="add.titleslide">
        <div class="slide">
            <p><em>TITLE SLIDE</em></p>
        </div>
    </xsl:template>
    <!-- necessary to add additional html header elements -->
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="d:slides">
        <!-- TODO: add css, misc stylesheets & headers -->
        <html>
            <head>
                <xsl:call-template name="add.slide.htmlheader"/>
            </head>
            <body>
                <div class="presentation">
                    <xsl:call-template name="add.titleslide"/>
                    <xsl:apply-templates/>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="d:foil">
        <div class="slide">
            <xsl:apply-templates/>
            <xsl:call-template name="add.slide.footer"/>
        </div>
    </xsl:template>
    <xsl:template match="d:foil/d:info">
        <xsl:apply-templates/>
    </xsl:template>
     <xsl:template match="d:foil/d:info/d:title|d:foil/d:title">
        <p class="title"><xsl:value-of select="."/></p>
    </xsl:template>
</xsl:stylesheet>
