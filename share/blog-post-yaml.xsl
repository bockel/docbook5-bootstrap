<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:dbk="http://docbook.org/ns/docbook" version="1.0" exclude-result-prefixes="xhtml dbk">
    <xsl:import href="xslt/html/docbook.xsl"/>
    <xsl:import href="xslt/html/highlight.xsl"/>
    <xsl:param name="highlight.source" select="1"/>
    <xsl:output method="html" omit-xml-declaration="yes"/>
    <xsl:template match="/" priority="1">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="dbk:article">
        <xsl:text>-----
</xsl:text>
            <xsl:apply-templates select="dbk:info" mode="yaml"/>
        <xsl:text>-----
</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="dbk:article/dbk:info" mode="yaml">
<xsl:for-each select="dbk:author/dbk:personname">
    <xsl:text>author: </xsl:text><xsl:value-of select="dbk:firstname"/><xsl:text> </xsl:text><xsl:value-of select="dbk:surname"/><xsl:text>
</xsl:text>
</xsl:for-each>
    </xsl:template>
    <xsl:template match="dbk:article/dbk:info"></xsl:template>
</xsl:stylesheet>
