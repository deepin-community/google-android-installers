#!/bin/bash

set -e

# This file is sourced by other bash scripts

get_pattern() {
  # $1 = version_to_package (as produced by _components_to_package.sh)

  if [[ "$1" =~ "^^"* ]]; then
    echo "$1"
    return
  fi

  local version version_p1 version_p2
  version=${1//,/;}

  case "$1" in
    "platforms,"*)
      version_p1=$(echo "$version" | cut -d "~" -f 1)
      version_p2=$(echo "$version" | cut -d "~" -f 2)
      echo "^${version_p1}\t.* ${version_p2}\t"
      ;;
    *)
      echo "^${version}\t"
      ;;
  esac
}

get_line() {
  grep --perl-regex "$(get_pattern "$1")" $PACKAGE_PATH/debian/version_list.txt
}

get_version_general() {
  get_line "$1" | cut -d "	" -f3
}

get_version_patcher() {
  get_line "$1" | cut -d "	" -f1 | cut -d ";" -f2 | tr -d 'v'
}

get_version_sources() {
  get_line "$1" | cut -d "	" -f1 | cut -d ";" -f2 | cut -d '-' -f2
}

get_version_platforms() {
  local api label
  api=$(get_line "$1" | cut -d "	" -f2) ;\
  label=$(get_line "$1" | cut -d "	" -f4 | cut -d " " -f4 | tr '[:upper:]' '[:lower:]');\

  if [[ ! "$label" =~ ^"$api".* ]]; then
    echo "$api-$label"
  else
    echo "$label"
  fi
}

get_version() {
  # $1 = pattern
  case $(get_pattern "$1") in
    "^platforms;"*)
      get_version_platforms "$1"
      ;;
    "^patcher;"*)
      get_version_patcher "$1"
      ;;
    "^sources;"*)
      get_version_sources "$1"
      ;;
    *)
      get_version_general "$1"
      ;;
  esac
}

get_version_ndk_short() {
  local version ver_major ver_letter
  version="$(get_version "$1")"
  ver_major=$(echo "$version" | cut -d . -f 1)
  ver_letter=$(echo "$version" | cut -d . -f 2 | tr '1-9' 'b-z' | tr -d '0')
  echo "r${ver_major}${ver_letter}"
}

get_platforms_revision() {
  get_version_general "$1"
}

get_package_display_name() {
  get_line "$1" | cut -d "	" -f4
}

get_license() {
  get_line "$1" | cut -d "	" -f5
}

get_zip_size() {
  get_line "$1" | cut -d "	" -f6
}

get_zip_filename() {
  # $1 = pattern
  get_line "$1" | cut -d "	" -f7
}

get_zip_sha1() {
  get_line "$1" | cut -d "	" -f8
}

get_unpacked_size() {
  # $1 = pattern
  UNPACKED_SIZE=$(grep --perl-regex "$(get_zip_filename "$1")\t" $PACKAGE_PATH/debian/version_list_unpacked_size.txt | cut -d "	" -f2 | sed "s/^$/0/")
  if [ -z "$UNPACKED_SIZE" ]; then
    echo 0
  else
    echo "$UNPACKED_SIZE"
  fi
}

get_installed_size() {
  # $1 = pattern
  echo $(((0 + $(get_unpacked_size "$1") / 1024)))
}

get_package_name_short() {
  case $1 in
    "platforms,"*)
      echo "platform"
      ;;
    "build-tools,"*)
      echo "build-tools"
      ;;
    "patcher,"*)
      echo "patcher"
      ;;
    "cmdline-tools,"[0-9]*)
      echo "cmdline-tools"
      ;;
    "platform-tools")
      echo "platform-tools"
      ;;
    "ndk,"*)
      echo "ndk"
      ;;
    "sources,"*)
      echo "sources"
      ;;
    "emulator")
      echo "emulator"
      ;;
    "extras,google,auto")
      echo "extras-google-auto"
      ;;
    *)
      echo "INVALID: $(get_pattern "$1"). END"
      ;;
  esac
}

get_package_name() {
  # $1 = pattern

  case $1 in
    "platforms,"*| \
    "build-tools,"*| \
    "patcher,"*| \
    "cmdline-tools,"[0-9]*| \
    "sources,"*)
      echo "google-android-$(get_package_name_short "$1")-$(get_version "$1")-installer"
      ;;
    "ndk,"*)
      echo "google-android-$(get_package_name_short "$1")-$(get_version_ndk_short "$1")-installer"
      ;;
    "platform-tools"| \
    "emulator"| \
    "extras,google,auto")
      echo "google-android-$(get_package_name_short "$1")-installer"
      ;;
    *)
      echo "INVALID: $(get_pattern "$1"). END"
      ;;
  esac
}


get_repo_dir() {
  grep "REPO_DIR=" "$PACKAGE_PATH/debian/version_list.info" | cut -d "=" -f2
}

get_path() {
  get_line "$1" | cut -d "	" -f1 | sed "s,;,/,g"
}

get_path_dirname() {
  dirname "$(get_path "$1")"
}

get_path_basename() {
  basename "$(get_path "$1")"
}

get_alternative_alternative_dirname() {
  echo "/usr/lib/android-sdk/$(get_path_dirname "$1")/$(get_path_basename "$1")"
}

get_alternative_link_dirname() {
  echo "/usr/bin"
}
