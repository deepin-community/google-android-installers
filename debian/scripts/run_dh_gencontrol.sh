#!/bin/bash

set -e

SCRIPT_PATH=$(dirname $0)

source $SCRIPT_PATH/_components_to_package.sh
source $SCRIPT_PATH/_common_functions.sh

DEB_VERSION="$1"

dh_gencontrol -pgoogle-android-licenses -- -Tdebian/substvars.in

for version in ${PLATFORMS_VERSIONS_TO_PACKAGE}; do
  echo running dh_gencontrol for "$version"
  dh_gencontrol \
    -p$(get_package_name "$version") \
    -- \
    -v$(get_version "$version")+r$(get_platforms_revision "$version").$DEB_VERSION \
    -DInstalled-Size=$(get_installed_size "$version") \
    -Tdebian/substvars.in
done

for version in ${BUILD_TOOLS_VERSIONS_TO_PACKAGE}; do
  echo running dh_gencontrol for "$version"
  dh_gencontrol \
    -p$(get_package_name "$version") \
    -- \
    -v$(get_version "$version")+$DEB_VERSION \
    -DInstalled-Size=$(get_installed_size "$version") \
    -Tdebian/substvars.in
done

for version in ${PATCHER_VERSIONS_TO_PACKAGE}; do
  echo running dh_gencontrol for "$version"
  dh_gencontrol \
    -p$(get_package_name "$version") \
    -- \
    -v$(get_version "$version")+$DEB_VERSION \
    -DInstalled-Size=$(get_installed_size "$version") \
    -Tdebian/substvars.in
done

for version in ${CMDLINE_TOOLS_VERSIONS_TO_PACKAGE}; do
  echo running dh_gencontrol for "$version"
  dh_gencontrol \
    -p$(get_package_name "$version") \
    -- \
    -v$(get_version "$version")+$DEB_VERSION \
    -DInstalled-Size=$(get_installed_size "$version") \
    -Tdebian/substvars.in
done

for version in ${PLATFORM_TOOLS_VERSIONS_TO_PACKAGE}; do
  echo running dh_gencontrol for "$version"
  dh_gencontrol \
    -p$(get_package_name "$version") \
    -- \
    -v$(get_version "$version")+$DEB_VERSION \
    -DInstalled-Size=$(get_installed_size "$version") \
    -Tdebian/substvars.in
done

for version in ${NDK_VERSIONS_TO_PACKAGE}; do
  echo running dh_gencontrol for "$version"
  dh_gencontrol \
    -p$(get_package_name "$version") \
    -- \
    -v$(get_version "$version")+$DEB_VERSION \
    -DInstalled-Size=$(get_installed_size "$version") \
    -Tdebian/substvars.in
done

for version in ${SOURCES_VERSIONS_TO_PACKAGE}; do
  echo running dh_gencontrol for "$version"
  dh_gencontrol \
    -p$(get_package_name "$version") \
    -- \
    -v$(get_version "$version")+$DEB_VERSION \
    -DInstalled-Size=$(get_installed_size "$version") \
    -Tdebian/substvars.in
done

for version in ${EMULATOR_VERSIONS_TO_PACKAGE}; do
  echo running dh_gencontrol for "$version"
  dh_gencontrol \
    -p$(get_package_name "$version") \
    -- \
    -v$(get_version "$version")+$DEB_VERSION \
    -DInstalled-Size=$(get_installed_size "$version") \
    -Tdebian/substvars.in
done

for version in ${EXTRAS_GOOGLE_AUTO_VERSIONS_TO_PACKAGE}; do
  echo running dh_gencontrol for "$version"
  dh_gencontrol \
    -p$(get_package_name "$version") \
    -- \
    -v$(get_version "$version")+$DEB_VERSION \
    -DInstalled-Size=$(get_installed_size "$version") \
    -Tdebian/substvars.in \
    -Tdebian/google-android-extras-google-auto-installer.substvars.in
done
