<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl">

<xsl:output method="xml"/>
<xsl:strip-space elements="*"/>

<!-- Change the built-in rule on text nodes to not output them -->
<xsl:template match="text()"/>

<xsl:template match="/">
    <!-- Match only packages that are on channel-0 & not in preview -->
    <xsl:apply-templates select="*/remotePackage[./channelRef[@ref='channel-0']][uses-license[@ref!='android-sdk-preview-license']]"/>
</xsl:template>

<!-- List "platforms" packages -->
<xsl:template match="*/remotePackage[contains(@path,'platforms;android')]">
    <exsl:document href="{translate(@path,';','/')}/package.xml" method="xml" encoding="UTF-8" standalone="yes" indent="yes">
        <ns2:repository
            xmlns:ns2="http://schemas.android.com/repository/android/common/01"
            xmlns:common="http://schemas.android.com/repository/android/common/01"
            xmlns:generic="http://schemas.android.com/repository/android/generic/01"
            xmlns:sdk="http://schemas.android.com/sdk/android/repo/repository2/01"
            xmlns:sdk-common="http://schemas.android.com/sdk/android/repo/common/01"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            >

        <xsl:copy-of select="/sdk:sdk-repository/@*"/>
        <xsl:copy-of select="/sdk:sdk-repository/license[@id = current()/uses-license/@ref]"/>
        <localPackage>
        <xsl:copy-of select="@*"/>
        <xsl:copy-of select="type-details"/>
        <xsl:copy-of select="revision"/>
        <xsl:copy-of select="display-name"/>
        <xsl:copy-of select="uses-license"/>
        <xsl:copy-of select="dependencies"/>
        </localPackage>
        </ns2:repository>
    </exsl:document>
</xsl:template>

<!-- List "build-tools" packages -->
<xsl:template match="*/remotePackage[contains(@path,'build-tools;')]">
    <exsl:document href="{translate(@path,';','/')}/package.xml" method="xml" encoding="UTF-8" standalone="yes" indent="yes">
        <ns2:repository
            xmlns:ns2="http://schemas.android.com/repository/android/common/01"
            xmlns:common="http://schemas.android.com/repository/android/common/01"
            xmlns:generic="http://schemas.android.com/repository/android/generic/01"
            xmlns:sdk="http://schemas.android.com/sdk/android/repo/repository2/01"
            xmlns:sdk-common="http://schemas.android.com/sdk/android/repo/common/01"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            >

        <xsl:copy-of select="/sdk:sdk-repository/@*"/>
        <xsl:copy-of select="/sdk:sdk-repository/license[@id = current()/uses-license/@ref]"/>
        <localPackage>
        <xsl:copy-of select="@*"/>
        <xsl:copy-of select="type-details"/>
        <xsl:copy-of select="revision"/>
        <xsl:copy-of select="display-name"/>
        <xsl:copy-of select="uses-license"/>
        <xsl:copy-of select="dependencies"/>
        </localPackage>
        </ns2:repository>
    </exsl:document>
</xsl:template>

<!-- List "ndk" packages -->
<xsl:template match="*/remotePackage[contains(@path,'ndk;')]">
    <exsl:document href="{translate(@path,';','/')}/package.xml" method="xml" encoding="UTF-8" standalone="yes" indent="yes">
        <ns2:repository
            xmlns:ns2="http://schemas.android.com/repository/android/common/01"
            xmlns:common="http://schemas.android.com/repository/android/common/01"
            xmlns:generic="http://schemas.android.com/repository/android/generic/01"
            xmlns:sdk="http://schemas.android.com/sdk/android/repo/repository2/01"
            xmlns:sdk-common="http://schemas.android.com/sdk/android/repo/common/01"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            >

        <xsl:copy-of select="/sdk:sdk-repository/@*"/>
        <xsl:copy-of select="/sdk:sdk-repository/license[@id = current()/uses-license/@ref]"/>
        <localPackage>
        <xsl:copy-of select="@*"/>
        <xsl:copy-of select="type-details"/>
        <xsl:copy-of select="revision"/>
        <xsl:copy-of select="display-name"/>
        <xsl:copy-of select="uses-license"/>
        <xsl:copy-of select="dependencies"/>
        </localPackage>
        </ns2:repository>
    </exsl:document>
</xsl:template>

<!-- List "ndk-bundle" packages -->
<xsl:template match="*/remotePackage[contains(@path,'ndk-bundle')]">
    <exsl:document href="{translate(@path,';','/')}/package.xml" method="xml" encoding="UTF-8" standalone="yes" indent="yes">
        <ns2:repository
            xmlns:ns2="http://schemas.android.com/repository/android/common/01"
            xmlns:common="http://schemas.android.com/repository/android/common/01"
            xmlns:generic="http://schemas.android.com/repository/android/generic/01"
            xmlns:sdk="http://schemas.android.com/sdk/android/repo/repository2/01"
            xmlns:sdk-common="http://schemas.android.com/sdk/android/repo/common/01"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            >

        <xsl:copy-of select="/sdk:sdk-repository/@*"/>
        <xsl:copy-of select="/sdk:sdk-repository/license[@id = current()/uses-license/@ref]"/>
        <localPackage>
        <xsl:copy-of select="@*"/>
        <xsl:copy-of select="type-details"/>
        <xsl:copy-of select="revision"/>
        <xsl:copy-of select="display-name"/>
        <xsl:copy-of select="uses-license"/>
        <xsl:copy-of select="dependencies"/>
        </localPackage>
        </ns2:repository>
    </exsl:document>
</xsl:template>

<!-- List "sources" packages -->
<xsl:template match="*/remotePackage[contains(@path,'sources;')]">
    <exsl:document href="{translate(@path,';','/')}/package.xml" method="xml" encoding="UTF-8" standalone="yes" indent="yes">
        <ns2:repository
            xmlns:ns2="http://schemas.android.com/repository/android/common/01"
            xmlns:common="http://schemas.android.com/repository/android/common/01"
            xmlns:generic="http://schemas.android.com/repository/android/generic/01"
            xmlns:sdk="http://schemas.android.com/sdk/android/repo/repository2/01"
            xmlns:sdk-common="http://schemas.android.com/sdk/android/repo/common/01"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            >

        <xsl:copy-of select="/sdk:sdk-repository/@*"/>
        <xsl:copy-of select="/sdk:sdk-repository/license[@id = current()/uses-license/@ref]"/>
        <localPackage>
        <xsl:copy-of select="@*"/>
        <xsl:copy-of select="type-details"/>
        <xsl:copy-of select="revision"/>
        <xsl:copy-of select="display-name"/>
        <xsl:copy-of select="uses-license"/>
        <xsl:copy-of select="dependencies"/>
        </localPackage>
        </ns2:repository>
    </exsl:document>
</xsl:template>

<!-- List "cmdline-tools" packages -->
<xsl:template match="*/remotePackage[contains(@path,'cmdline-tools;')]">
    <exsl:document href="{translate(@path,';','/')}/package.xml" method="xml" encoding="UTF-8" standalone="yes" indent="yes">
        <ns2:repository
            xmlns:ns2="http://schemas.android.com/repository/android/common/01"
            xmlns:common="http://schemas.android.com/repository/android/common/01"
            xmlns:generic="http://schemas.android.com/repository/android/generic/01"
            xmlns:sdk="http://schemas.android.com/sdk/android/repo/repository2/01"
            xmlns:sdk-common="http://schemas.android.com/sdk/android/repo/common/01"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            >

        <xsl:copy-of select="/sdk:sdk-repository/@*"/>
        <xsl:copy-of select="/sdk:sdk-repository/license[@id = current()/uses-license/@ref]"/>
        <localPackage>
        <xsl:copy-of select="@*"/>
        <xsl:copy-of select="type-details"/>
        <xsl:copy-of select="revision"/>
        <xsl:copy-of select="display-name"/>
        <xsl:copy-of select="uses-license"/>
        <xsl:copy-of select="dependencies"/>
        </localPackage>
        </ns2:repository>
    </exsl:document>
</xsl:template>

<!-- List "patcher" packages -->
<xsl:template match="*/remotePackage[contains(@path,'patcher;')]">
    <exsl:document href="{translate(@path,';','/')}/package.xml" method="xml" encoding="UTF-8" standalone="yes" indent="yes">
        <ns2:repository
            xmlns:ns2="http://schemas.android.com/repository/android/common/01"
            xmlns:common="http://schemas.android.com/repository/android/common/01"
            xmlns:generic="http://schemas.android.com/repository/android/generic/01"
            xmlns:sdk="http://schemas.android.com/sdk/android/repo/repository2/01"
            xmlns:sdk-common="http://schemas.android.com/sdk/android/repo/common/01"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            >

        <xsl:copy-of select="/sdk:sdk-repository/@*"/>
        <xsl:copy-of select="/sdk:sdk-repository/license[@id = current()/uses-license/@ref]"/>
        <localPackage>
        <xsl:copy-of select="@*"/>
        <xsl:copy-of select="type-details"/>
        <xsl:copy-of select="revision"/>
        <xsl:copy-of select="display-name"/>
        <xsl:copy-of select="uses-license"/>
        <xsl:copy-of select="dependencies"/>
        </localPackage>
        </ns2:repository>
    </exsl:document>
</xsl:template>

<!-- List "emulator" packages -->
<xsl:template match="*/remotePackage[contains(@path,'emulator')][archives/archive[./host-os='linux']]">
    <exsl:document href="{translate(@path,';','/')}/package.xml" method="xml" encoding="UTF-8" standalone="yes" indent="yes">
        <ns2:repository
            xmlns:ns2="http://schemas.android.com/repository/android/common/01"
            xmlns:common="http://schemas.android.com/repository/android/common/01"
            xmlns:generic="http://schemas.android.com/repository/android/generic/01"
            xmlns:sdk="http://schemas.android.com/sdk/android/repo/repository2/01"
            xmlns:sdk-common="http://schemas.android.com/sdk/android/repo/common/01"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            >

        <xsl:copy-of select="/sdk:sdk-repository/@*"/>
        <xsl:copy-of select="/sdk:sdk-repository/license[@id = current()/uses-license/@ref]"/>
        <localPackage>
        <xsl:copy-of select="@*"/>
        <xsl:copy-of select="type-details"/>
        <xsl:copy-of select="revision"/>
        <xsl:copy-of select="display-name"/>
        <xsl:copy-of select="uses-license"/>
        <xsl:copy-of select="dependencies"/>
        </localPackage>
        </ns2:repository>
    </exsl:document>
</xsl:template>

<!-- List "extras" packages -->
<xsl:template match="*/remotePackage[contains(@path,'extras;')]">
    <exsl:document href="{translate(@path,';','/')}/package.xml" method="xml" encoding="UTF-8" standalone="yes" indent="yes">
        <ns2:repository
            xmlns:ns2="http://schemas.android.com/repository/android/common/01"
            xmlns:common="http://schemas.android.com/repository/android/common/01"
            xmlns:generic="http://schemas.android.com/repository/android/generic/01"
            xmlns:sdk="http://schemas.android.com/sdk/android/repo/repository2/01"
            xmlns:sdk-common="http://schemas.android.com/sdk/android/repo/common/01"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            >

        <xsl:copy-of select="/sdk:sdk-repository/@*"/>
        <xsl:copy-of select="/sdk:sdk-repository/license[@id = current()/uses-license/@ref]"/>
        <localPackage>
        <xsl:copy-of select="@*"/>
        <xsl:copy-of select="type-details"/>
        <xsl:copy-of select="revision"/>
        <xsl:copy-of select="display-name"/>
        <xsl:copy-of select="uses-license"/>
        <xsl:copy-of select="dependencies"/>
        </localPackage>
        </ns2:repository>
    </exsl:document>
</xsl:template>

<!-- List "platform-tools" packages -->
<xsl:template match="*/remotePackage[contains(@path,'platform-tools')]">
    <exsl:document href="{translate(@path,';','/')}/package.xml" method="xml" encoding="UTF-8" standalone="yes" indent="yes">
        <ns2:repository
            xmlns:ns2="http://schemas.android.com/repository/android/common/01"
            xmlns:common="http://schemas.android.com/repository/android/common/01"
            xmlns:generic="http://schemas.android.com/repository/android/generic/01"
            xmlns:sdk="http://schemas.android.com/sdk/android/repo/repository2/01"
            xmlns:sdk-common="http://schemas.android.com/sdk/android/repo/common/01"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            >

        <xsl:copy-of select="/sdk:sdk-repository/@*"/>
        <xsl:copy-of select="/sdk:sdk-repository/license[@id = current()/uses-license/@ref]"/>
        <localPackage>
        <xsl:copy-of select="@*"/>
        <xsl:copy-of select="type-details"/>
        <xsl:copy-of select="revision"/>
        <xsl:copy-of select="display-name"/>
        <xsl:copy-of select="uses-license"/>
        <xsl:copy-of select="dependencies"/>
        </localPackage>
        </ns2:repository>
    </exsl:document>
</xsl:template>

</xsl:stylesheet>
