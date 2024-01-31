<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

<xsl:output method="text"/>
<xsl:strip-space elements="*"/>

<!-- Change the built-in rule on text nodes to not output them -->
<xsl:template match="text()"/>

<xsl:template match="/">
    <!-- Match only packages that are on channel-0 & not in preview -->
    <xsl:apply-templates select="*/remotePackage[./channelRef[@ref='channel-0']][uses-license[@ref!='android-sdk-preview-license']]"/>
</xsl:template>

<!-- List "platforms" packages -->
<xsl:template match="*/remotePackage[contains(@path,'platforms;android')]">
<xsl:value-of select="@path"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="type-details[@xsi:type='sdk:platformDetailsType']/api-level"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="revision/major"/>
<xsl:if test="revision/minor">.<xsl:value-of select="revision/minor"/></xsl:if>
<xsl:if test="revision/micro">.<xsl:value-of select="revision/micro"/></xsl:if>
<xsl:text>&#x9;</xsl:text>
<xsl:value-of select="display-name"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="uses-license/@ref"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive/complete/size"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive/complete/url"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive/complete/checksum"/><xsl:text>&#x9;</xsl:text>
<xsl:if test="@obsolete = 'true'"><xsl:value-of select="name(@obsolete)"/></xsl:if><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="dependencies/dependency/@path"/><xsl:text>&#x9;</xsl:text>
<xsl:text>
</xsl:text>
</xsl:template>

<!-- List "build-tools" packages -->
<xsl:template match="*/remotePackage[contains(@path,'build-tools;')]">
<xsl:value-of select="@path"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="type-details[@xsi:type='generic:genericDetailsType']/api-level"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="revision/major"/>
<xsl:if test="revision/minor">.<xsl:value-of select="revision/minor"/></xsl:if>
<xsl:if test="revision/micro">.<xsl:value-of select="revision/micro"/></xsl:if>
<xsl:text>&#x9;</xsl:text>
<xsl:value-of select="display-name"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="uses-license/@ref"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/size"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/url"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/checksum"/><xsl:text>&#x9;</xsl:text>
<xsl:if test="@obsolete = 'true'"><xsl:value-of select="name(@obsolete)"/></xsl:if><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="dependencies/dependency/@path"/><xsl:text>&#x9;</xsl:text>
<xsl:text>
</xsl:text>
</xsl:template>

<!-- List "ndk" packages -->
<xsl:template match="*/remotePackage[contains(@path,'ndk;')]">
<xsl:value-of select="@path"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="type-details[@xsi:type='generic:genericDetailsType']/api-level"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="revision/major"/>
<xsl:if test="revision/minor">.<xsl:value-of select="revision/minor"/></xsl:if>
<xsl:if test="revision/micro">.<xsl:value-of select="revision/micro"/></xsl:if>
<xsl:text>&#x9;</xsl:text>
<xsl:value-of select="display-name"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="uses-license/@ref"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/size"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/url"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/checksum"/><xsl:text>&#x9;</xsl:text>
<xsl:if test="@obsolete = 'true'"><xsl:value-of select="name(@obsolete)"/></xsl:if><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="dependencies/dependency/@path"/><xsl:text>&#x9;</xsl:text>
<xsl:text>
</xsl:text>
</xsl:template>

<!-- List "ndk-bundle" packages -->
<xsl:template match="*/remotePackage[contains(@path,'ndk-bundle')]">
<xsl:value-of select="@path"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="type-details[@xsi:type='generic:genericDetailsType']/api-level"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="revision/major"/>
<xsl:if test="revision/minor">.<xsl:value-of select="revision/minor"/></xsl:if>
<xsl:if test="revision/micro">.<xsl:value-of select="revision/micro"/></xsl:if>
<xsl:text>&#x9;</xsl:text>
<xsl:value-of select="display-name"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="uses-license/@ref"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/size"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/url"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/checksum"/><xsl:text>&#x9;</xsl:text>
<xsl:if test="@obsolete = 'true'"><xsl:value-of select="name(@obsolete)"/></xsl:if><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="dependencies/dependency/@path"/><xsl:text>&#x9;</xsl:text>
<xsl:text>
</xsl:text>
</xsl:template>

<!-- List "sources" packages -->
<xsl:template match="*/remotePackage[contains(@path,'sources;')]">
<xsl:value-of select="@path"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="type-details[@xsi:type='generic:genericDetailsType']/api-level"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="revision/major"/>
<xsl:if test="revision/minor">.<xsl:value-of select="revision/minor"/></xsl:if>
<xsl:if test="revision/micro">.<xsl:value-of select="revision/micro"/></xsl:if>
<xsl:text>&#x9;</xsl:text>
<xsl:value-of select="display-name"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="uses-license/@ref"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive/complete/size"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive/complete/url"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive/complete/checksum"/><xsl:text>&#x9;</xsl:text>
<xsl:if test="@obsolete = 'true'"><xsl:value-of select="name(@obsolete)"/></xsl:if><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="dependencies/dependency/@path"/><xsl:text>&#x9;</xsl:text>
<xsl:text>
</xsl:text>
</xsl:template>

<!-- List "cmdline-tools" packages -->
<xsl:template match="*/remotePackage[contains(@path,'cmdline-tools;')]">
<xsl:value-of select="@path"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="type-details[@xsi:type='generic:genericDetailsType']/api-level"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="revision/major"/>
<xsl:if test="revision/minor">.<xsl:value-of select="revision/minor"/></xsl:if>
<xsl:if test="revision/micro">.<xsl:value-of select="revision/micro"/></xsl:if>
<xsl:text>&#x9;</xsl:text>
<xsl:value-of select="display-name"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="uses-license/@ref"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/size"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/url"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/checksum"/><xsl:text>&#x9;</xsl:text>
<xsl:if test="@obsolete = 'true'"><xsl:value-of select="name(@obsolete)"/></xsl:if><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="dependencies/dependency/@path"/><xsl:text>&#x9;</xsl:text>
<xsl:text>
</xsl:text>
</xsl:template>

<!-- List "patcher" packages -->
<xsl:template match="*/remotePackage[contains(@path,'patcher;')]">
<xsl:value-of select="@path"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="type-details[@xsi:type='generic:genericDetailsType']/api-level"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="revision/major"/>
<xsl:if test="revision/minor">.<xsl:value-of select="revision/minor"/></xsl:if>
<xsl:if test="revision/micro">.<xsl:value-of select="revision/micro"/></xsl:if>
<xsl:text>&#x9;</xsl:text>
<xsl:value-of select="display-name"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="uses-license/@ref"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive/complete/size"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive/complete/url"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive/complete/checksum"/><xsl:text>&#x9;</xsl:text>
<xsl:if test="@obsolete = 'true'"><xsl:value-of select="name(@obsolete)"/></xsl:if><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="dependencies/dependency/@path"/><xsl:text>&#x9;</xsl:text>
<xsl:text>
</xsl:text>
</xsl:template>

<!-- List "emulator" packages -->
<xsl:template match="*/remotePackage[contains(@path,'emulator')][archives/archive[./host-os='linux']]">
<xsl:value-of select="@path"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="type-details[@xsi:type='generic:genericDetailsType']/api-level"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="revision/major"/>
<xsl:if test="revision/minor">.<xsl:value-of select="revision/minor"/></xsl:if>
<xsl:if test="revision/micro">.<xsl:value-of select="revision/micro"/></xsl:if>
<xsl:text>&#x9;</xsl:text>
<xsl:value-of select="display-name"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="uses-license/@ref"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/size"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/url"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/checksum"/><xsl:text>&#x9;</xsl:text>
<xsl:if test="@obsolete = 'true'"><xsl:value-of select="name(@obsolete)"/></xsl:if><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="dependencies/dependency/@path"/><xsl:text>&#x9;</xsl:text>
<xsl:text>
</xsl:text>
</xsl:template>

<!-- List "extras" packages -->
<xsl:template match="*/remotePackage[contains(@path,'extras;')]">
<xsl:value-of select="@path"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="type-details[@xsi:type='generic:genericDetailsType']/api-level"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="revision/major"/>
<xsl:if test="revision/minor">.<xsl:value-of select="revision/minor"/></xsl:if>
<xsl:if test="revision/micro">.<xsl:value-of select="revision/micro"/></xsl:if>
<xsl:text>&#x9;</xsl:text>
<xsl:value-of select="display-name"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="uses-license/@ref"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/size"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/url"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/checksum"/><xsl:text>&#x9;</xsl:text>
<xsl:if test="@obsolete = 'true'"><xsl:value-of select="name(@obsolete)"/></xsl:if><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="dependencies/dependency/@path"/><xsl:text>&#x9;</xsl:text>
<xsl:text>
</xsl:text>
</xsl:template>

<!-- List "platform-tools" packages -->
<xsl:template match="*/remotePackage[contains(@path,'platform-tools')]">
<xsl:value-of select="@path"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="type-details[@xsi:type='generic:genericDetailsType']/api-level"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="revision/major"/>
<xsl:if test="revision/minor">.<xsl:value-of select="revision/minor"/></xsl:if>
<xsl:if test="revision/micro">.<xsl:value-of select="revision/micro"/></xsl:if>
<xsl:text>&#x9;</xsl:text>
<xsl:value-of select="display-name"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="uses-license/@ref"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/size"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/url"/><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="archives/archive[./host-os='linux']/complete/checksum"/><xsl:text>&#x9;</xsl:text>
<xsl:if test="@obsolete = 'true'"><xsl:value-of select="name(@obsolete)"/></xsl:if><xsl:text>&#x9;</xsl:text>
<xsl:value-of select="dependencies/dependency/@path"/><xsl:text>&#x9;</xsl:text>
<xsl:text>
</xsl:text>
</xsl:template>

</xsl:stylesheet>
