<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    >

<xsl:output method="text"/>
<xsl:strip-space elements="*"/>
<xsl:param name="license"/>

<!-- Change the built-in rule on text nodes to not output them -->
<xsl:template match="text()"/>

<xsl:template match="/">
    <xsl:apply-templates select="*/license[@id=$license]"/>
</xsl:template>

<!-- List "platforms" packages -->
<xsl:template match="license">
<xsl:value-of select="."/>
<xsl:text>
</xsl:text>
</xsl:template>

</xsl:stylesheet>
