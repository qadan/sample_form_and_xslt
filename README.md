# Sample Form and XSLT

## Intro

Adds a bare-bones MusicBrainz Artist XML form, associated with the Person Entity Content Model, to the list of forms and form associations.

Includes a handy-dandy Gsearch XSLT to index it too! The Gsearch XSLT favours clarity over efficiency so that it can be used as an example of how to transform an XML Forms output datastream to a Solr doc.

## Installation

* Install the module by, y'know, installing it.
* Ensure that `xsl/MMD_to_solr.xslt` is accessible by the fedora user, and point your Gsearch configuration to it. With the discoverygarden basic-solr-config, this should probably be done by copying the XSLT to the configuration's `islandora_transforms` folder, and then adding an `<xsl:include>` declaration inside the configuration's `foxmlToSolr.xslt` (in that giant chunk of `<xsl:include>`s that all reference XSLTs inside the `islandora_transforms` folder.
* Restart Gsearch (probably `sudo service restart tomcat` for most of y'all?)

## TODO

Write a cleanup transformation that places all the releases and relations under the same release-list and relation-list organized by the `type` and `target-type`, respectively.
