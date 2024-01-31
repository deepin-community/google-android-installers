#!/bin/bash

set -e

SCRIPT_PATH=$(dirname $0)

cd $SCRIPT_PATH

TMPDIR=$(mktemp -d)

LATEST_RELEASE_URL=$(wget -qO- https://api.github.com/repos/M0Rf30/android-udev-rules/releases/latest | grep -oP '"tarball_url": "\K(.*)(?=")')
wget $LATEST_RELEASE_URL -O "$TMPDIR/latest.tar.gz"

tar -xvf "$TMPDIR/latest.tar.gz" -C ../.. --strip-components=1 --wildcards "*/51-android.rules"

sed -i "s/adbusers/plugdev/g" ../../51-android.rules

rm -r "$TMPDIR"
