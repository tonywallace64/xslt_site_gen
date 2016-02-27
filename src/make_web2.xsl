<?xml version="1.0" encoding="ISO-8859-1"?>

<!--
Note: xslt 1.0 cannot produce multiple output files
This is done by a file element in the "abc" namespace
which is processed by xslt_extn.

Processing instructions are surrounded by <xml_tags> element
in the "abc" namespace and stored in an escaped form, until
processed by xslt_extn with a +finaloutput option.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:ax="abc" version="1.0">
  <xsl:import href="ajw_utils.xsl" />
  <xsl:template match='/site'>
    <xsl:comment>Generated web pages</xsl:comment>
    <site_pages>
    <xsl:for-each select="./pages">
      <xsl:apply-templates/>
    </xsl:for-each>
    </site_pages>
  </xsl:template>

<xsl:template match="pages" name="pages-template">
  <xsl:for-each select="page">
    <xsl:apply-templates/>
  </xsl:for-each>
</xsl:template>

<xsl:template match="page">
<!-- Comment in template -->
<xsl:element name="ax:file">
<xsl:attribute name="filename">
  <xsl:value-of select="./url" />
</xsl:attribute>
<xsl:message>File <xsl:value-of select="./url" /></xsl:message>
<xsl:text xml:space="preserve" >
</xsl:text>
<ax:xml_tags>
<xsl:value-of select="./file_headers" />
</ax:xml_tags>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:xf="http://www.w3.org/2002/xforms">

<head>
<meta name="Keywords" content='{keywords}' />
<!-- Comment in template -->
<title>
  <xsl:value-of select="./title" />
</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<!-- for efficiencies sake consider separte template file.
The advantage over inlining is that it gets loaded once for all pages -->
<style type="text/css">
  body {color:blue;}  
  p  {line-height=130%;}
  h1 {text-align:center;}
  h2 {text-align:center;}
  h3 {text-align:center;}
  a:link {color:#0000FF;}
  a:visited {color:#C0C000;}
  nav {
  background-image:url(images/grgcleft2.png);
  position: absolute;
  top :0px;
  bottom:0;
  left: 0;
  width: 240px;
}
  section {
  position: relative;
  margin-left: 250px;
}
</style>
  <xsl:copy-of select="./model" />

</head>
<body>
  <nav>
  <h2>Contact</h2>
  <ul>
  <li><xsl:value-of select="ancestor::pages/contact-phone"/></li>
  <li><xsl:copy-of  select="ancestor::pages/contact-email/*"/></li>
  <xsl:choose>
    <xsl:when test="ancestor::pages[navtype='mesh']">
      <xsl:call-template name="meshindex" />
    </xsl:when>
    <xsl:when test="ancestor::pages[navtype='linear']">
      <xsl:call-template name="linearindex" />
    </xsl:when>
    <xsl:otherwise>
      Failed to match index template:
      <xsl:value-of select="ancestor::pages/navtype"/> 
      Current node is:
      <xsl:value-of select="string(./node())" />
    </xsl:otherwise>
  </xsl:choose>
  </ul>
</nav> 
<section>
  <xsl:message>section</xsl:message>
  <a>
    <xsl:attribute name="href">
      <xsl:value-of select="ancestor::pages/homepage"/>
    </xsl:attribute>
    <xsl:copy-of select="ancestor::pages/banner_image/child::img"/>
  </a>
  <br />
  <xsl:apply-templates select="./content/*"/>
</section>
</body>
</html>
</xsl:element>
</xsl:template>

<xsl:template name="meshindex">
    <xsl:for-each select="ancestor::pages/page">
      <li>
	<a>
	<xsl:attribute name="href">
	  <xsl:value-of select=".//url"  />
	</xsl:attribute>
	<xsl:value-of select=".//name" />
	</a>
      </li>
    </xsl:for-each>
</xsl:template>

<xsl:template name="linearindex">
    Mesh linear index
    <a href="{(ancestor::pages)[1]/page[1]/url}">Home</a>
    <a href="{ancestor::pages/page[1]}">Start</a>
    <a href="{ancestor::page/preceding-sibling::page[1]/url}">Previous</a>
    <a href="{ancestor::page/following-sibling::page[1]/url}">Next</a>
</xsl:template>


</xsl:stylesheet>
