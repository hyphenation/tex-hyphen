<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:lang="urn:org:tug:texhyphen:languagedata">

  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <xsl:variable name="language-data" select="document('codemapping.xml')/lang:code-mappings"/>

  <xsl:template match="*|@*|node()">
	<xsl:copy>
	  <xsl:apply-templates select="*|@*|node()"/>
	</xsl:copy>
  </xsl:template>

  <xsl:template match="lang:language">
	<xsl:variable name="code" select="$language-data/lang:code-mapping[@code=current()/@code]"/>
	<xsl:variable name="fop-code">
	  <xsl:choose>
		<xsl:when test="$code">
		  <xsl:value-of select="$code/@fop-code"/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="@code"/>
		</xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
	<xsl:copy>
	  <xsl:if test="string($fop-code)">
		<xsl:attribute name="fop-code">
		  <xsl:value-of select="$fop-code"/>
		</xsl:attribute>
	  </xsl:if>
	  <xsl:apply-templates select="*|@*|node()"/>
	</xsl:copy>
  </xsl:template>

</xsl:stylesheet>
