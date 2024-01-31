#!/bin/bash

set -e

# This file is sourced by other bash scripts

SCRIPT_PATH=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PACKAGE_PATH=$(realpath "$SCRIPT_PATH/../..")

# Whether we should also package the versions marked as obsolete in repository2-1.xml
SKIP_OBSOLETE_PACKAGES=1

# Build List of components to package
if [ $SKIP_OBSOLETE_PACKAGES -eq 1 ]; then
    PLATFORMS_VERSIONS_TO_PACKAGE=$(grep "^platforms;" $PACKAGE_PATH/debian/version_list.txt | grep -v --perl-regex "\tobsolete" | sed "s/;/,/g" | awk -F"\t" '{split($4,a," "); print $1"~"a[4]}')
    BUILD_TOOLS_VERSIONS_TO_PACKAGE=$(grep "^build-tools;" $PACKAGE_PATH/debian/version_list.txt | grep -v --perl-regex "\tobsolete" | sed "s/;/,/g" | cut -d "	" -f1 | sort -V)
    PATCHER_VERSIONS_TO_PACKAGE=$(grep "^patcher;" $PACKAGE_PATH/debian/version_list.txt | grep -v --perl-regex "\tobsolete" | sed "s/;/,/g" | cut -d "	" -f1 | sort)
    CMDLINE_TOOLS_VERSIONS_TO_PACKAGE=$(grep "^cmdline-tools;[0-9]" $PACKAGE_PATH/debian/version_list.txt | grep -v --perl-regex "\tobsolete" | sed "s/;/,/g" | cut -d "	" -f1 | sort -V)
    PLATFORM_TOOLS_VERSIONS_TO_PACKAGE=$(grep "^platform-tools" $PACKAGE_PATH/debian/version_list.txt | grep -v --perl-regex "\tobsolete" | sed "s/;/,/g" | cut -d "	" -f1 | sort -r | head -1)
    NDK_VERSIONS_TO_PACKAGE=$(grep "^ndk;" $PACKAGE_PATH/debian/version_list.txt | grep -v --perl-regex "\tobsolete" | sed "s/;/,/g" | cut -d "	" -f1 | sort)
    SOURCES_VERSIONS_TO_PACKAGE=$(grep "^sources;" $PACKAGE_PATH/debian/version_list.txt | grep -v --perl-regex "\tobsolete" | sed "s/;/,/g" |  cut -d "	" -f1)
    EMULATOR_VERSIONS_TO_PACKAGE=$(grep "^emulator" $PACKAGE_PATH/debian/version_list.txt | grep -v --perl-regex "\tobsolete" | sed "s/;/,/g" | cut -d "	" -f1 | sort -r | head -1)
    EXTRAS_GOOGLE_AUTO_VERSIONS_TO_PACKAGE=$(grep "^extras;google;auto" $PACKAGE_PATH/debian/version_list.txt | grep -v --perl-regex "\tobsolete" | sed "s/;/,/g" | cut -d "	" -f1 | sort -r | head -1)
else
    PLATFORMS_VERSIONS_TO_PACKAGE=$(grep "^platforms;" $PACKAGE_PATH/debian/version_list.txt | sed "s/;/,/g" | awk -F"\t" '{split($4,a," "); print $1"~"a[4]}')
    BUILD_TOOLS_VERSIONS_TO_PACKAGE=$(grep "^build-tools;" $PACKAGE_PATH/debian/version_list.txt | sed "s/;/,/g" | cut -d "	" -f1 | sort -V)
    PATCHER_VERSIONS_TO_PACKAGE=$(grep "^patcher;" $PACKAGE_PATH/debian/version_list.txt | sed "s/;/,/g" | cut -d "	" -f1 | sort)
    CMDLINE_TOOLS_VERSIONS_TO_PACKAGE=$(grep "^cmdline-tools;[0-9]" $PACKAGE_PATH/debian/version_list.txt | sed "s/;/,/g" | cut -d "	" -f1 | sort -V)
    PLATFORM_TOOLS_VERSIONS_TO_PACKAGE=$(grep "^platform-tools" $PACKAGE_PATH/debian/version_list.txt | sed "s/;/,/g" | cut -d "	" -f1 | sort -r | head -1)
    NDK_VERSIONS_TO_PACKAGE=$(grep "^ndk;" $PACKAGE_PATH/debian/version_list.txt | sed "s/;/,/g" | cut -d "	" -f1 | sort)
    SOURCES_VERSIONS_TO_PACKAGE=$(grep "^sources;" $PACKAGE_PATH/debian/version_list.txt | sed "s/;/,/g" |  cut -d "	" -f1)
    EMULATOR_VERSIONS_TO_PACKAGE=$(grep "^emulator" $PACKAGE_PATH/debian/version_list.txt | sed "s/;/,/g" | cut -d "	" -f1 | sort -r | head -1)
    EXTRAS_GOOGLE_AUTO_VERSIONS_TO_PACKAGE=$(grep "^extras;google;auto" $PACKAGE_PATH/debian/version_list.txt | sed "s/;/,/g" | cut -d "	" -f1 | sort -r | head -1)
fi
