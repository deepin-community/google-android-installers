#!/bin/bash

# This script will get the repo XML file from googles server
# This same file is used by Google Android's SDK Manager
# It:
#  - extracts all necessary information to file "version_list.txt"
#  - extracts the licenses. They are store in *.copyright files in the dir of this scripts
#  - creates package.xml files
#  - builds debian/control file
#  - builds debian/tests/control file
#  - inform on the timestamp in the XML file

set -e

SCRIPT_PATH=$(dirname $0)

if [ ! "$(realpath "$SCRIPT_PATH")" = "$PWD/debian/scripts" ]; then
  echo "This script must be run from the package root dir (the path containing the debian/ dir)"
  exit 1
fi

TMPDIR=$(mktemp -d -t google-installers-upgrade.XXX) || exit
trap "echo removing $TMPDIR && rm -rf -- '$TMPDIR'" EXIT
# Download upstream XML
#SERVER_URL=https://raw.githubusercontent.com/eagletmt/android-repository-history/master/repository
SERVER_URL=https://dl.google.com/android/repository/
REPO_DIR=
UPSTREAM_XML=repository2-1.xml

echo "Downloading $UPSTREAM_XML..."
wget -q --show-progress ${SERVER_URL}${REPO_DIR}${UPSTREAM_XML} -O $TMPDIR/$(basename $UPSTREAM_XML)
echo

GENERATION_DATE=$(grep "Generated on" $TMPDIR/$(basename $UPSTREAM_XML) | sed "s/.*Generated on \(.*\) with.*/\1/")
TIMESTAMP=$(date --date="$GENERATION_DATE" +%s)
echo "TIMESTAMP=$TIMESTAMP" > "debian/version_list.info"
echo "TIMESTAMP_DATE=\"$(date -Iseconds -u -d@$TIMESTAMP)\"" >> "debian/version_list.info"
echo "REPO_DIR=$REPO_DIR" >> "debian/version_list.info"

CURRENT_TIMESTAMP="$(dpkg-parsechangelog --show-field Version)"
if dpkg --compare-versions $TIMESTAMP gt $CURRENT_TIMESTAMP; then
  echo "Current Debian version:   [$CURRENT_TIMESTAMP] $(date -Iseconds -u -d@$CURRENT_TIMESTAMP)"
  echo "Current upstream version: [$TIMESTAMP] $(date -Iseconds -u -d@$TIMESTAMP)"
  echo "Continuing processing..."
else
  echo "XML generation timestamp is not newer than last version in debian/changelog"
  rm -r "$TMPDIR"
  trap - EXIT
  exit
fi

# Extract info from XML to version_list.txt
xsltproc $SCRIPT_PATH/list_available_packages.xsl "$TMPDIR/$(basename $UPSTREAM_XML)" > "$TMPDIR/version_list.txt"

# Manually add some lines
echo "ndk;10.4		10.4	NDK (Side by side) r10e	android-sdk-license	1110915721	android-ndk-r10e-linux-x86_64.zip	f692681b007071103277f6edc6f91cb5c5494a32		patcher;v4	" >> "$TMPDIR/version_list.txt"
if grep --perl-regexp "extras;google;auto\t\t2\.0.*77e3f80c2834e1fad33f56539ceb0215da408fab" "$TMPDIR/version_list.txt" > /dev/null ; then
    # Fix version of Android Auto to 2.0.0+really2.0 because upstream labeled 2.0rc2 as 2.0.2, and the final
    # release is labeled 2.0
    sed -i "s/extras;google;auto\t\t2\.0\t/extras;google;auto\t\t2.0.2+really2.0\t/" "$TMPDIR/version_list.txt"
fi

# Remove package.xml files
for dir in $(grep -v "^#" "$TMPDIR/version_list.txt" | cut -d "	" -f1 | cut -d ";" -f1 | sort -u); do
    rm -fr $dir
done

# Create package.xml files
xsltproc "$SCRIPT_PATH/make_package.xml.xsl" "$TMPDIR/$(basename $UPSTREAM_XML)"

# Write everything to debian/version_list.txt
echo "# This file is generated automatically by script in debian/scripts/$(basename $0)" > "debian/version_list.txt"
echo "# Don't update this file manually." >> "debian/version_list.txt"
cp -a "$TMPDIR/version_list.txt" "$TMPDIR/version_list_all.txt"
sort -V "$TMPDIR/version_list_all.txt" >> "debian/version_list.txt"

# Extract licenses
rm -r debian/licenses
mkdir -p debian/licenses
rm -r licenses
mkdir -p licenses
for license in $(grep -v "^#" debian/version_list.txt | cut -d "	" -f 5 | sort -u); do
    xsltproc --stringparam license $license $SCRIPT_PATH/extract-copyrights.xsl "$TMPDIR/$(basename $UPSTREAM_XML)" > debian/licenses/$license.copyright
    # Compute sha1 of license (we need to remove newline at end of file to be consistent with:
    # https://android.googlesource.com/platform/tools/base/+/gradle_2.2.2/repository/src/main/java/com/android/repository/api/License.java)
    perl -p -e 'chomp if eof' debian/licenses/$license.copyright | sha1sum | cut -d " " -f 1 > licenses/$license
    # Reformat for inclusion in copyright file
    sed -i -e "s/^$/./" -e "s/^/ /" debian/licenses/$license.copyright
done

rm -r "$TMPDIR"
trap - EXIT

echo -en "\nBuilding d/control file... "
debian/scripts/build_control_file.sh || exit
echo "done"

echo -en "\nBuilding d/tests/control file... "
debian/scripts/build_tests_control_file.sh || exit
echo "done"

echo

echo "Generation Date of XML: $GENERATION_DATE"
echo "Timestamp: $TIMESTAMP"
echo "You may update version in changelog with that version with"
echo "  dch -v $TIMESTAMP"
