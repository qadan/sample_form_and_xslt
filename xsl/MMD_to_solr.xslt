<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:foxml="info:fedora/fedora-system:def/foxml#"
    xmlns:mmd="http://musicbrainz.org/ns/mmd-1.0#">
    
    <xsl:template match="foxml:datastream[@ID='MMD']/foxml:datastreamVersion[last()]"
        name="index_MMD">
        <xsl:param name="content"/>
        <xsl:param name="prefix">mmd_</xsl:param>
        <xsl:param name="suffix">_ms</xsl:param>

        <xsl:for-each select="$content//mmd:artist">
          <xsl:variable name="BASE_ID" select="normalize-space(./@id)"/>
          <xsl:variable name="ID" select="translate($BASE_ID, ' ', '_')"/>
          <xsl:variable name="ARTIST_PREFIX" select="concat($prefix, 'artist_', $ID, '_')"/>

          <xsl:if test="./mmd:name != ''">
            <field>
              <xsl:attribute name="name">
                <xsl:value-of select="concat($ARTIST_PREFIX, 'name', $suffix)"/>
              </xsl:attribute>
              <xsl:value-of select="./mmd:name"/>
            </field>
          </xsl:if>

          <xsl:if test="./mmd:disambiguation != ''">
            <field>
              <xsl:attribute name="name">
                <xsl:value-of select="concat($ARTIST_PREFIX, 'disambiguation', $suffix)"/>
              </xsl:attribute>
              <xsl:value-of select="./mmd:disambiguation"/>
            </field>
          </xsl:if>

          <xsl:if test="./mmd:life-span/@begin != ''">
            <field>
              <xsl:attribute name="name">
                <xsl:value-of select="concat($ARTIST_PREFIX, 'life-span_begin', $suffix)"/>
              </xsl:attribute>
              <xsl:value-of select="./mmd:life-span/@begin"/>
            </field>
          </xsl:if>

          <xsl:if test="./mmd:life-span/@end != ''">
            <field>
              <xsl:attribute name="name">
                <xsl:value-of select="concat($ARTIST_PREFIX, 'life-span_end', $suffix)"/>
              </xsl:attribute>
              <xsl:value-of select="./mmd:life-span/@end"/>
            </field>
          </xsl:if>

          <xsl:for-each select="./mmd:relation-list">
          </xsl:for-each>

          <xsl:for-each select="./mmd:release-list">
          </xsl:for-each>

        </xsl:for-each>

    </xsl:template>
</xsl:stylesheet>
