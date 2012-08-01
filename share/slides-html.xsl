<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://exslt.org/strings" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:d="http://docbook.org/ns/docbook" version="1.0" exclude-result-prefixes="xhtml d">
    <xsl:import href="html.xsl"/>
    <xsl:param name="resource.root" select="'.'"/>
    <xsl:param name="intro.sect" select="'Intro'"/>
    <xsl:param name="theme.name" select="'default'"/>
    <xsl:output method="html" encoding="UTF-8" indent="no"/>

    <xsl:template name="add.slide.htmlheader">
        <link rel="stylesheet" href="{$resource.root}/css/reset.css" type="text/css"/>
        <link rel="stylesheet" href="{$resource.root}/css/showoff.css" type="text/css"/>

        <script type="text/javascript" src="{$resource.root}/js/jquery-1.4.2.min.js"></script>
        <script type="text/javascript" src="{$resource.root}/js/jquery.cycle.all.js"></script>
        <script type="text/javascript" src="{$resource.root}/js/jquery-print.js"></script>
        <script type="text/javascript" src="{$resource.root}/js/jquery.batchImageLoad.js"></script>

        <script type="text/javascript" src="{$resource.root}/js/jquery.doubletap-0.1.js"></script>

        <script type="text/javascript" src="{$resource.root}/js/fg.menu.js"></script>
        <script type="text/javascript" src="{$resource.root}/js/showoff.js"></script>
        <script type="text/javascript" src="{$resource.root}/js/jTypeWriter.js"> </script>
        <script type="text/javascript" src="{$resource.root}/js/core.js"></script>
        <script type="text/javascript" src="{$resource.root}/js/showoffcore.js"></script>

        <link type="text/css" href="{$resource.root}/css/fg.menu.css" media="screen" rel="stylesheet" />
        <link type="text/css" href="{$resource.root}/css/theme/ui.all.css" media="screen" rel="stylesheet" />
        <link type="text/css" href="{$resource.root}/themes/theme.{$theme.name}.css" media="screen" rel="stylesheet" />
        <link type="text/css" href="{$resource.root}/themes/docbook.css" rel="stylesheet"/>
        <!--<link type="text/css" href="{$resource.root}/themes/highlight-solarized.css" media="screen" rel="stylesheet" />-->

        <script type="text/javascript">
        $(function(){
        setupPreso(false, './');
        });
        </script>
    </xsl:template>
    <xsl:template name="add.slide.bodyheader">
        <a tabindex="0" href="#search-engines" class="fg-button fg-button-icon-right ui-widget ui-state-default ui-corner-all" id="navmenu"><span class="ui-icon ui-icon-triangle-1-s"></span>slides</a>
        <div id="navigation" class="hidden"></div>
        <div id="help">
          <table>
            <tr><td class="key">space, &#8594;</td><td>next slide</td></tr>
            <tr><td class="key">&#8592;</td><td>previous slide</td></tr>
            <tr><td class="key">d</td><td>debug mode</td></tr>
            <tr><td class="key">## &lt;ret&gt;</td><td>go to slide #</td></tr>
            <tr><td class="key">c</td><td>table of contents (vi)</td></tr>
            <tr><td class="key">f</td><td>toggle footer</td></tr>
            <tr><td class="key">r</td><td>reload slides</td></tr>
            <tr><td class="key">p</td><td>toggle print layout</td></tr>
            <tr><td class="key">z</td><td>toggle help (this)</td></tr>
          </table>
        </div>
        <div class="buttonNav"><input type="submit" onClick="prevStep();" value="prev"/><input type="submit" onClick="nextStep();" value="next"/></div>
        <div id="preso">Loading Presentation...</div>
        <div id="footer"><span id="slideInfo"></span> <span id="debugInfo"></span></div>
    </xsl:template>
    <xsl:template name="add.slide.header">
    </xsl:template>
    <xsl:template name="add.slide.footer">
        <div class="footer">
            <xsl:value-of select="concat(
                count(preceding-sibling::*[self::d:foil or self::d:foilgroup])
                +count(preceding-sibling::d:foilgroup/d:foil)
                +count(parent::*[self::d:foil or self::d:foilgroup])
                +count(../preceding-sibling::*[self::d:foil or self::d:foilgroup])
                +count(../preceding-sibling::d:foilgroup/d:foil)+1
                ,'/',count(/d:slides/d:foil|/d:slides/d:foilgroup|/d:slides/d:foilgroup/d:foil))"/>
        </div>

    </xsl:template>
    <xsl:template match="d:slides/d:info">
        <div class="slide titleslide">
            <div class="content" ref="{$intro.sect}/title">
                <div class="slidetitle">
                    <h1><xsl:value-of select="d:title"/></h1>
                </div>
                <table>
                    <tr>
                        <xsl:for-each select="d:author">
                            <td><div class="slideauthor">
                                <xsl:value-of select="concat(d:personname/d:firstname,' ',d:personname/d:surname)"/>
                                <xsl:if test="d:email">
                                    <div class="email"><xsl:value-of select="d:email"/></div>
                                </xsl:if>
                            </div></td>
                        </xsl:for-each>
                    </tr>
                </table>
            </div>
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
                <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
                <xsl:choose>
                    <xsl:when test="d:info/d:title"><title><xsl:value-of select="d:info/d:title"/></title></xsl:when>
                    <xsl:when test="d:title"><title><xsl:value-of select="d:title"/></title></xsl:when>
                    <xsl:otherwise><title>Presentation</title></xsl:otherwise>
                </xsl:choose>
                <xsl:call-template name="add.slide.htmlheader"/>
            </head>
            <body>
                <xsl:call-template name="add.slide.bodyheader"/>
                <div id="slides" class="offscreen" style="display: none;">
                    <xsl:apply-templates/>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="d:foilgroup">
        <xsl:variable name="ref">
            <xsl:choose>
                <!--<xsl:when test="d:info/d:title"><xsl:value-of select="str:replace(d:info/d:title,' ','_')"/></xsl:when>-->
                <xsl:when test="d:info/d:title"><xsl:value-of select="d:info/d:title"/></xsl:when>
                <xsl:when test="d:title"><xsl:value-of select="d:title"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="concat('section',count(preceding-sibling::d:foilgroup)+1)"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <div class="slide titleslide">
            <div class="content" ref="{concat($ref,'/slide0')}">
                <xsl:apply-templates select="d:info|d:title"/>
            </div>
        </div>
        <xsl:apply-templates select="d:foil">
            <xsl:with-param name="parent" select="concat($ref,'/')"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="d:foil">
        <xsl:param name="parent" select="concat($intro.sect,'/')"/>
        <xsl:variable name="ref" select="concat('slide',count(preceding-sibling::d:foil)+1)"/>
        <div class="slide">
            <div class="content" ref="{concat($parent,$ref)}">
                <xsl:apply-templates/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="d:foil/d:info|d:foilgroup/d:info">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="d:foil/d:info/d:title|d:foil/d:title
                        |d:foilgroup/d:info/d:title|d:foilgroup/d:title">
        <div class="{name()}">
            <xsl:if test="string-length(.) &gt; 0">
                <h1><xsl:value-of select="."/></h1>
            </xsl:if>
        </div>
    </xsl:template>
    <xsl:template match="d:foil/d:info/d:subtitle|d:foil/d:subtitle
                        |d:foilgroup/d:info/d:subtitle|d:foilgroup/d:subtitle">
        <xsl:if test="string-length(.) &gt; 0">
            <h3 class="{name()}"><xsl:value-of select="."/></h3>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
