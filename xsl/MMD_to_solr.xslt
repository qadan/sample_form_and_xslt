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
            <xsl:variable name="TARGET-TYPE" select="concat(normalize-space(./@target-type), '_')"/>
            <xsl:variable name="TYPE" select="concat(normalize-space(./relation/@type), '_')"/>

            <xsl:if test="./mmd:relation/@target != ''">
              <field>
                <xsl:attribute name="name">
                  <xsl:value-of select="translate(concat($ARTIST_PREFIX, 'relation-list_', $TARGET-TYPE, 'relation_', $TYPE, 'target', $suffix), ' ', '_')"/>
                </xsl:attribute>
                <xsl:value-of select="normalize-space(./mmd:relation/@target)"/>
              </field>
            </xsl:if>
            <xsl:if test="./mmd:relation/mmd:artist/@id != ''">
              <field>
                <xsl:attribute name="name">
                  <xsl:value-of select="translate(concat($ARTIST_PREFIX, 'relation-list_', $TARGET-TYPE, 'relation_', $TYPE, 'artist_id', $suffix), ' ', '_')"/>
                </xsl:attribute>
                <xsl:value-of select="normalize-space(./mmd:relation/mmd:artist/@id)"/>
              </field>
            </xsl:if>
            <xsl:if test="./mmd:relation/mmd:artist/mmd:name != ''">
              <field>
                <xsl:attribute name="name">
                  <xsl:value-of select="translate(concat($ARTIST_PREFIX, 'relation-list_', $TARGET-TYPE, 'relation_', $TYPE, 'artist_name', $suffix), ' ', '_')"/>
                </xsl:attribute>
                <xsl:value-of select="normalize-space(./mmd:relation/mmd:artist/mmd:name)"/>
              </field>
            </xsl:if>
          </xsl:for-each>

          <xsl:for-each select="./mmd:release-list">
            <xsl:variable name="RELEASE-TYPE" select="concat(normalize-space(./@id), '_')"/>

            <xsl:if test="./mmd:title != ''">
              <field>
                <xsl:attribute name="name">
                  <xsl:value-of select="translate(concat($ARTIST_PREFIX, 'release-list_', $RELEASE-TYPE, 'title_', $suffix), ' ', '_')"/>
                </xsl:attribute>
                <xsl:value-of select="normalize-space(./mmd:title)"/>
              </field>
            </xsl:if>
            <xsl:if test="./mmd:release-event-list/mmd:release/@date">
              <field>
                <xsl:attribute name="name">
                  <xsl:value-of select="translate(concat($ARTIST_PREFIX, 'release-list_', $RELEASE-TYPE, 'release-event-list_release_date_', $suffix), ' ', '_')"/>
                </xsl:attribute>
                <xsl:value-of select="normalize-space(./mmd:release-event-list/mmd:release/@date)"/>
              </field>
            </xsl:if>
            <xsl:if test="./mmd:release-event-list/mmd:release/@country != ''">
              <field>
                <xsl:attribute name="name">
                  <xsl:value-of select="translate(concat($ARTIST_PREFIX, 'release-list_', $RELEASE-TYPE, 'release-event-list_release_country_', $suffix), ' ', '_')"/>
                </xsl:attribute>
                <xsl:value-of select="normalize-space(./mmd:release-event-list/mmd:release/@country)"/>
              </field>
            </xsl:if>

            <xsl:if test="./mmd:disc-list/mmd:disc">
              <xsl:for-each select="./mmd:disc-list/mmd:disc">
                <field>
                  <xsl:attribute name="name">
                    <xsl:value-of select="translate(concat($ARTIST_PREFIX, 'release_list_', $RELEASE-TYPE, 'release-event-list_disc-list_disc_id_', $suffix), ' ', '_')"/>
                  </xsl:attribute>
                  <xsl:value-of select="normalize-space(./mmd:disc-list/mmd:disc/@id)"/>
                </field>
              </xsl:for-each>
            </xsl:if>

            <xsl:if test="./mmd:track-list/@count != ''">
              <field>
                <xsl:attribute name="name">
                  <xsl:value-of select="translate(concat($ARTIST_PREFIX, 'release-list_', $RELEASE-TYPE, 'track-list_', $suffix), ' ', '_')"/>
                </xsl:attribute>
                <xsl:value-of select="normalize-space(./mmd:track-list/@count)"/>
              </field>
            </xsl:if>
          </xsl:for-each>

        </xsl:for-each>

    </xsl:template>
</xsl:stylesheet>
