#!/bin/bash

set -e

SCRIPT_PATH=$(dirname $0)

source $SCRIPT_PATH/_components_to_package.sh
source $SCRIPT_PATH/_common_functions.sh

set_placeholders() {
  # $1 = 'version'
  # $2 = input_suffix (control.in)
  # $3 = tmpfile

  suffix="$2"

  if [[ "$1" =~ ndk,* ]]; then
    VER=$(get_version_ndk_short "$version")
  else
    VER=$(get_version "$version")
  fi
  sed "s/%VER%/$VER/g" debian/$(get_package_name_short "$version").$suffix >> $TMPFILE
  sed -i "s/%PACKAGE_DISPLAY_NAME%/$(get_package_display_name "$version")/g" $TMPFILE
  sed -i "s/%ZIPFILE%/$(get_zip_filename "$version")/g" $TMPFILE
  sed -i "s/%MB_SIZE%/$(expr $(get_zip_size "$version") / 1000000)/g" $TMPFILE
}

write_to_control() {
    echo "" >> debian/control
    cat "$1" >> debian/control
    rm "$1"
}

# Build debian/control file
echo "# -- This file was generated automatically by the debian/scripts/$(basename $0) script --" > debian/control
echo "# -- Update control.in & *.control.in files instead --" >> debian/control
cat debian/control.in >> debian/control

for version in ${PLATFORMS_VERSIONS_TO_PACKAGE}; do
    TMPFILE=$(mktemp)
    set_placeholders "$version" "control.in" "$TMPFILE"

    # Write back to debian/control
    write_to_control "$TMPFILE"
done

for version in ${BUILD_TOOLS_VERSIONS_TO_PACKAGE}; do
    VER=$(get_version "$version")
    VER_MAJOR=$(get_version "$version" | cut -d . -f 1)

    TMPFILE=$(mktemp)
    if [ $VER_MAJOR -le 23 ]; then
      set_placeholders "$version" "control-32bits.in" "$TMPFILE"
    else
      set_placeholders "$version" "control.in" "$TMPFILE"
    fi

    sed -i "s/%VER_MAJOR%/$VER_MAJOR/g" $TMPFILE

    # Write back to debian/control
    write_to_control "$TMPFILE"
done

for version in ${PATCHER_VERSIONS_TO_PACKAGE}; do
    TMPFILE=$(mktemp)
    set_placeholders "$version" "control.in" "$TMPFILE"

    # Write back to debian/control
    write_to_control "$TMPFILE"
done

for version in ${CMDLINE_TOOLS_VERSIONS_TO_PACKAGE}; do
    TMPFILE=$(mktemp)
    set_placeholders "$version" "control.in" "$TMPFILE"

    # Write back to debian/control
    write_to_control "$TMPFILE"
done

for version in ${PLATFORM_TOOLS_VERSIONS_TO_PACKAGE}; do
    TMPFILE=$(mktemp)
    set_placeholders "$version" "control.in" "$TMPFILE"

    # Write back to debian/control
    write_to_control "$TMPFILE"
done

for version in ${NDK_VERSIONS_TO_PACKAGE}; do
    VER_MAJOR=$(get_version "$version" | cut -d . -f 1)

    TMPFILE=$(mktemp)
    if [ $VER_MAJOR -eq 10 ]; then
      # NDK r10 Depends on "file"
      set_placeholders "$version" "control-r10.in" "$TMPFILE"
    else
      set_placeholders "$version" "control.in" "$TMPFILE"
    fi

    # Write back to debian/control
    write_to_control "$TMPFILE"
done

for version in ${SOURCES_VERSIONS_TO_PACKAGE}; do
    TMPFILE=$(mktemp)
    set_placeholders "$version" "control.in" "$TMPFILE"

    # Write back to debian/control
    write_to_control "$TMPFILE"
done

for version in ${EMULATOR_VERSIONS_TO_PACKAGE}; do
    TMPFILE=$(mktemp)
    set_placeholders "$version" "control.in" "$TMPFILE"

    # Write back to debian/control
    write_to_control "$TMPFILE"
done

for version in ${EXTRAS_GOOGLE_AUTO_VERSIONS_TO_PACKAGE}; do
    TMPFILE=$(mktemp)
    if [ "$(get_version "$version")" = "1.1" ]; then
      set_placeholders "$version" "control-v1.1.in" "$TMPFILE"
    else
      set_placeholders "$version" "control.in" "$TMPFILE"
    fi

    # Write back to debian/control
    write_to_control "$TMPFILE"
done
