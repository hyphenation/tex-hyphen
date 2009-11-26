<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tex="urn:org:tug:texhyphen"
  xmlns:lang="urn:org:tug:texhyphen:languagedata"
  exclude-result-prefixes="tex lang">

  <xsl:output doctype-system="hyphenation.dtd" indent="yes"/>
  
  <xsl:param name="comment-length" select="72"/>
  <xsl:param name="tex-code"/>
  <xsl:param name="hyphen-min-before-default" select="2"/>
  <xsl:param name="hyphen-min-after-default" select="3"/>

  <xsl:template match="/tex:tex">
    <hyphenation-info>
	  <xsl:choose>
		<xsl:when test="tex:hyphenation">
		  <!-- (comment*), (patterns), (comment*, hyphenation, comment*) => (comment*), hyphen-min, (comment*, exceptions, comment*), (patterns) -->
		  <xsl:variable name="set1" select="node()[following-sibling::tex:patterns]"/>
		  <xsl:variable name="set2" select="tex:patterns"/>
		  <xsl:variable name="set3" select="node()[preceding-sibling::tex:patterns]"/>
		  <xsl:apply-templates select="$set1"/>
		  <xsl:call-template name="hyphen-min"/>
		  <xsl:apply-templates select="$set3"/>
		  <xsl:apply-templates select="$set2"/>
		</xsl:when>
		<xsl:otherwise>
		  <!-- (comment*), (patterns, comment*) => (comment*), hyphen-min, (patterns, comment*) -->
		  <xsl:variable name="set1" select="node()[following-sibling::tex:patterns]"/>
		  <xsl:variable name="set2" select="node()[preceding-sibling::tex:patterns or self::tex:patterns]"/>
		  <xsl:apply-templates select="$set1"/>
		  <xsl:call-template name="hyphen-min"/>
		  <xsl:apply-templates select="$set2"/>
		</xsl:otherwise>
	  </xsl:choose>
    </hyphenation-info>
  </xsl:template>

  <xsl:template match="tex:patterns">
    <patterns>
      <xsl:apply-templates />
    </patterns>
  </xsl:template>

  <xsl:template match="tex:patterns" mode="call-hyphen-min">
	<xsl:call-template name="hyphen-min"/>
    <patterns>
      <xsl:apply-templates />
    </patterns>
  </xsl:template>

  <xsl:template name="hyphen-min">
    <xsl:variable name="hyphen-min"
      select="document('languages.xml')/lang:languages/lang:language[@code=$tex-code]/lang:hyphen-min" />
    <xsl:if test="count($hyphen-min)">
      <hyphen-min before="{$hyphen-min/@before}" after="{$hyphen-min/@after}" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="tex:message"/>

  <xsl:template match="tex:hyphenation">
    <exceptions>
      <xsl:apply-templates />
    </exceptions>
  </xsl:template>

  <!-- Comments in TeX contain the trailing new line.                     -->
  <!-- Here we keep the trailing new line if the comment is immediately   -->
  <!-- preceded or followed by a text node.                               -->
  <!-- Otherwise we strip the new line and pad the comment                -->
  <!-- to the parameter comment-length.                                   -->
  <!-- The XSLT engine uses the same criteria to decide if the comment    -->
  <!-- should start on a new line or not.                                 -->
  <!-- This is not quite correct, because we risk adding spaces to        -->
  <!-- elements with mixed content.                                       -->
  <!-- The following test would be more appropriate:                      -->
  <!-- test="preceding-sibling::text() or following-sibling::text()".     -->
  <xsl:template match="comment()">
    <xsl:choose>
      <xsl:when
        test="preceding-sibling::node()[1][self::text()]
            or following-sibling::node()[1][self::text()]">
        <xsl:comment>
          <xsl:value-of select="." />
        </xsl:comment>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="length" select="string-length(.)" />
        <xsl:comment>
          <xsl:value-of select="substring(.,1,$length - 1)" />
          <xsl:text> </xsl:text>
          <xsl:call-template name="make-spaces">
            <xsl:with-param name="length"
              select="$comment-length - ($length - 1)" />
          </xsl:call-template>
        </xsl:comment>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="make-spaces">
    <xsl:param name="length" select="0" />
    <xsl:choose>
      <xsl:when test="$length >= 10">
        <xsl:text>          </xsl:text>
        <xsl:call-template name="make-spaces">
          <xsl:with-param name="length" select="$length - 10" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$length >= 5">
        <xsl:text>     </xsl:text>
        <xsl:call-template name="make-spaces">
          <xsl:with-param name="length" select="$length - 5" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$length >= 1">
        <xsl:text> </xsl:text>
        <xsl:call-template name="make-spaces">
          <xsl:with-param name="length" select="$length - 1" />
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
    <xsl:text></xsl:text>
  </xsl:template>

</xsl:stylesheet>