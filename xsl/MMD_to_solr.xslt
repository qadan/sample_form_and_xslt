<?xml version="1.0" encoding="UTF-8"?>
<!-- Namespaces, yo. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:foxml="info:fedora/fedora-system:def/foxml#"
    xmlns:mmd="http://musicbrainz.org/ns/mmd-1.0#">

    <!-- Basically, we're matching datastreams with the DSID we want. Whether 
         the datastream is configured to be versionable or not, the datastream
         info will still be contained within a datastreamVersion tag; in the
         case of a non-versionable datastream, it'll just always be version 0. -->
    <xsl:template match="foxml:datastream[@ID='MMD']/foxml:datastreamVersion[last()]"
      name="index_MMD">
        <!-- Params! Every field starts and ends with the same thing, so
             establish this. -->
        <xsl:param name="content"/>
        <xsl:param name="prefix">mmd_</xsl:param>
        <xsl:param name="suffix">_ms</xsl:param>

        <!-- For each artist - because we could make it do more of them later. -->
        <xsl:for-each select="$content//mmd:artist">
          <xsl:variable name="ARTIST_PREFIX" select="concat($prefix, 'artist_')"/>

          <!-- So, we're testing if the field or attribute has content. If it
               does, then ... -->
          <xsl:if test="./@id != ''">
            <!-- ... create a <field> tag. Field tags for Solr look like this:
                 <field name="solr_field_label">Field content</field>
                 A whole bunch of these strung together, and you have yourself
                 a complete Solr doc! It'll be contained within the necessary
                 tags for the Solr REST request when Gsearch runs the 
                 foxmlToSolr XSLT and sends it off to the REST API. -->
            <field>
              <!-- So, give it the 'name' attribute assembled from the prefix,
                   an identifying label, and the suffix, and then ... -->
              <xsl:attribute name="name">
                <xsl:value-of select="concat($ARTIST_PREFIX, 'id', $suffix)"/>
              </xsl:attribute>
              <!-- ... make the actual content the value of the field or
                   attribute. We tend to normalize-space() the fields to remove
                   excess whitespace; this isn't strictly necessary. -->
              <xsl:value-of select="translate(normalize-space(./@id), ' ', '-')"/>
            </field>
          </xsl:if>
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
                  <!-- In the case where we have Solr field names being created
                       by concatenating variables that could have spaces in
                       them, it's important to replace those spaces with
                       something else; otherwise Solr will blow up in a few
                       different places. Using translate() here, but feel free
                       to use whatever method works. -->
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
                  <xsl:value-of select="translate(concat($ARTIST_PREFIX, 'release-list_', $RELEASE-TYPE, 'title', $suffix), ' ', '_')"/>
                </xsl:attribute>
                <xsl:value-of select="normalize-space(./mmd:title)"/>
              </field>
            </xsl:if>
            <xsl:if test="./mmd:release-event-list/mmd:release/@date != ''">
              <field>
                <xsl:attribute name="name">
                  <xsl:value-of select="translate(concat($ARTIST_PREFIX, 'release-list_', $RELEASE-TYPE, 'release-event-list_release_date', $suffix), ' ', '_')"/>
                </xsl:attribute>
                <xsl:value-of select="normalize-space(./mmd:release-event-list/mmd:release/@date)"/>
              </field>
            </xsl:if>
            <xsl:if test="./mmd:release-event-list/mmd:release/@country != ''">
              <field>
                <xsl:attribute name="name">
                  <xsl:value-of select="translate(concat($ARTIST_PREFIX, 'release-list_', $RELEASE-TYPE, 'release-event-list_release_country', $suffix), ' ', '_')"/>
                </xsl:attribute>
                <xsl:value-of select="normalize-space(./mmd:release-event-list/mmd:release/@country)"/>
              </field>
            </xsl:if>

            <xsl:if test="./mmd:disc-list/mmd:disc">
              <xsl:for-each select="./mmd:disc-list/mmd:disc">
                <field>
                  <xsl:attribute name="name">
                    <xsl:value-of select="translate(concat($ARTIST_PREFIX, 'release_list_', $RELEASE-TYPE, 'release-event-list_disc-list_disc_id', $suffix), ' ', '_')"/>
                  </xsl:attribute>
                  <xsl:value-of select="normalize-space(./@id)"/>
                </field>
              </xsl:for-each>
            </xsl:if>

            <xsl:if test="./mmd:track-list/@count != ''">
              <field>
                <xsl:attribute name="name">
                  <xsl:value-of select="translate(concat($ARTIST_PREFIX, 'release-list_', $RELEASE-TYPE, 'track-list', $suffix), ' ', '_')"/>
                </xsl:attribute>
                <xsl:value-of select="normalize-space(./mmd:track-list/@count)"/>
              </field>
            </xsl:if>
          </xsl:for-each>

        </xsl:for-each>

    </xsl:template>
</xsl:stylesheet>
