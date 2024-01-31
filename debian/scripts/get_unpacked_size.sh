#!/bin/bash

set -e

# Get the binary size of unknown packages by downloading them
# Use this script in a SCHROOT environment to not polute yours
# as it downloads and removes the packages for which size is unknown

# Usage:
#   Run this from a schroot environment
#     ./debian/scripts/get_unpacked_size.sh
#

SCRIPT_PATH=$(dirname $0)

source $SCRIPT_PATH/_components_to_package.sh
source $SCRIPT_PATH/_common_functions.sh

if [ -z "$debian_chroot" ] || [ $UID -ne 0 ]; then
    echo "This must be run in a schroot as user root."
    exit
fi

check_empty_android-sdk_dir() {
    if [ -e /usr/lib/android-sdk ]; then
        echo "First remove all google-android-* packages to have no /usr/lib/android-sdk dir";
        exit;
    fi
}

get_unpacked_size() {
    # $1 = $ZIPFILE
    # $2 = $PKG_NAME
    # $3 = $SUBPATH

    if ! grep --perl-regex -q "^$1\t" ../version_list_unpacked_size.txt; then
      # Installs the deb package to download the archive on google servers
      # Then gets the uncompressed size of the downloaded archive
      # Finally purge the package
      check_empty_android-sdk_dir
      dpkg --force-depends -i ../../../${2}_*.deb
      SIZE=$(du -b /usr/lib/android-sdk/${3} | tail -1 | cut -d "	" -f1)
      dpkg -P ${2}
      echo -e "$1\t$SIZE" >> ../version_list_unpacked_size.txt
    else
      UNPACKED_SIZE=$(grep --perl-regex "^$1\t" ../version_list_unpacked_size.txt | cut -d "	" -f2 | sed "s/^$/0/")
      echo "Size for $1 already known: $UNPACKED_SIZE"
    fi
}

SCRIPT_PATH=$(dirname $0)

cd $SCRIPT_PATH
source _components_to_package.sh

for version in ${PLATFORMS_VERSIONS_TO_PACKAGE} \
    ${BUILD_TOOLS_VERSIONS_TO_PACKAGE} \
    ${PATCHER_VERSIONS_TO_PACKAGE} \
    ${CMDLINE_TOOLS_VERSIONS_TO_PACKAGE} \
    ${PLATFORM_TOOLS_VERSIONS_TO_PACKAGE} \
    ${NDK_VERSIONS_TO_PACKAGE} \
    ${SOURCES_VERSIONS_TO_PACKAGE} \
    ${EMULATOR_VERSIONS_TO_PACKAGE} \
    ${EXTRAS_GOOGLE_AUTO_VERSIONS_TO_PACKAGE} \
    ; do

  get_unpacked_size "$(get_zip_filename "$version")" "$(get_package_name "$version")" "$(get_path "$version")"
done
