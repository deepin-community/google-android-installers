#!/bin/bash

set -e

SCRIPT_PATH=$(dirname $0)

source $SCRIPT_PATH/_components_to_package.sh
source $SCRIPT_PATH/_common_functions.sh

DEB_VERSION="$1"

processed_once=()

# array containing [1] binaries of build-tools, [2] version in which it appeared for the 1st time, [3] conflicting debian package
build_tools_provides=()
build_tools_provides+=("aapt|1|aapt")
build_tools_provides+=("aapt2|24")
build_tools_provides+=("aidl|1|aidl")
build_tools_provides+=("apksigner|26.0.1|apksigner")
build_tools_provides+=("d8|28.0.1")
build_tools_provides+=("dexdump|1|dexdump")
build_tools_provides+=("split-select|22.0.1|split-select")
build_tools_provides+=("zipalign|19.1.0|zipalign")

# array containing [1] binaries of cmdline-tools, [2] version in which it appeared for the 1st time, [3] conflicting debian package
cmdline_tools_provides=()
cmdline_tools_provides+=("bin/apkanalyzer|1")
cmdline_tools_provides+=("bin/avdmanager|1")
cmdline_tools_provides+=("bin/lint|1")
cmdline_tools_provides+=("bin/profgen|5.0")
cmdline_tools_provides+=("bin/retrace|4.0")
cmdline_tools_provides+=("bin/screenshot2|1|android-platform-tools-base")
cmdline_tools_provides+=("bin/sdkmanager|1|sdkmanager")

update_file() {
  # $1: output file
  # $2: variable name
  # $3: variable value
  local sedscript input output
  sedscript="$3"
  input="$1"
  output="$2"

  if [ ! -s "$input" ]; then
    # echo "        Skipping missing or empty file: $input"
    return
  fi

  if [ ! -f "$output" ] || [[ ! " ${processed_once[*]} " =~ " ${output} " ]]; then
    sed "$sedscript" "$input" > "$output"
    # Add file to list of files processed at least once
    processed_once+=("${output}")
  else
    sed -i "$sedscript" "$output"
  fi

}

add_alternatives() {
  local version relpath name priority
  version="$1"
  relpath="$2"
  name="$(basename "$2")"
  priority="$3"

  echo "Name: $name
Link: $(get_alternative_link_dirname)/$name
Alternative: $(get_alternative_alternative_dirname "$version")/$relpath
Priority: $priority
" >> "debian/$(get_package_name "$version").alternatives"

}

generate_files() {

  local VER PATH_DIRNAME PATH_BASENAME LICENSE REPO_DIR ZIPFILE ZIPSHA1 PKG_NAME_SHORT PKG_NAME

  if [[ "$1" =~ ^ndk,* ]]; then
    VER="$(get_version_ndk_short "$1")"
  else
    VER="$(get_version "$1")"
  fi
  PATH_DIRNAME="$(get_path_dirname "$1")"
  PATH_BASENAME="$(get_path_basename "$1")"
  LICENSE="$(get_license "$1")"
  REPO_DIR="$(get_repo_dir "$1")"
  ZIPFILE="$(get_zip_filename "$1")"
  ZIPSHA1="$(get_zip_sha1 "$1")"
  PKG_NAME_SHORT="$(get_package_name_short "$1")"
  PKG_NAME="$(get_package_name "$1")"

  echo "$ZIPSHA1  $ZIPFILE" > "for-postinst/default/$ZIPFILE.sha1"

  cp debian/bug-script.in debian/$PKG_NAME.bug-script

  update_file debian/$PKG_NAME_SHORT.config.in debian/$PKG_NAME.config "s/%VER%/$VER/g"

  update_file debian/$PKG_NAME_SHORT.dirs.in debian/$PKG_NAME.dirs "s/%VER%/$VER/g"

  if [ "$VER" = "r10e" ]; then
    update_file debian/$PKG_NAME_SHORT-r10.install.in debian/$PKG_NAME.install "s/%VER%/$VER/g"
  else
    update_file debian/$PKG_NAME_SHORT.install.in debian/$PKG_NAME.install "s/%VER%/$VER/g"
  fi
  update_file debian/$PKG_NAME_SHORT.install.in debian/$PKG_NAME.install "s/%ZIPFILE%/$ZIPFILE/g"
  update_file debian/$PKG_NAME_SHORT.install.in debian/$PKG_NAME.install "s!%PATH_DIRNAME%!$PATH_DIRNAME!g"
  update_file debian/$PKG_NAME_SHORT.install.in debian/$PKG_NAME.install "s/%PATH_BASENAME%/$PATH_BASENAME/g"

  update_file debian/$PKG_NAME_SHORT.lintian-overrides.in debian/$PKG_NAME.lintian-overrides "s/%VER%/$VER/g"

  update_file debian/$PKG_NAME_SHORT.postinst.in debian/$PKG_NAME.postinst "s/%VER%/$VER/g"
  update_file debian/$PKG_NAME_SHORT.postinst.in debian/$PKG_NAME.postinst "s!%REPO_DIR%!$REPO_DIR!g"
  update_file debian/$PKG_NAME_SHORT.postinst.in debian/$PKG_NAME.postinst "s/%ZIPFILE%/$ZIPFILE/g"
  update_file debian/$PKG_NAME_SHORT.postinst.in debian/$PKG_NAME.postinst "s!%PATH_DIRNAME%!$PATH_DIRNAME!g"
  update_file debian/$PKG_NAME_SHORT.postinst.in debian/$PKG_NAME.postinst "s/%PATH_BASENAME%/$PATH_BASENAME/g"
  update_file debian/$PKG_NAME_SHORT.postinst.in debian/$PKG_NAME.postinst "/^INS_DIR=/ s!\./!!g"

  update_file debian/$PKG_NAME_SHORT.postrm.in debian/$PKG_NAME.postrm "s/%VER%/$VER/g"

  update_file debian/templates.in debian/$PKG_NAME.templates "s/%VER%/$VER/g"


  cp debian/copyright.header.in debian/$PKG_NAME.copyright
  {
    echo ""
    echo "Files: *"
    echo "Copyright: Google Inc. "
    echo "License: $LICENSE"
    cat debian/licenses/$LICENSE.copyright
    echo ""
    cat debian/copyright.debian.in
  } >> debian/$PKG_NAME.copyright

  #platform
  if [ "$PKG_NAME_SHORT" = "platform" ]; then
    local version version_suppl count
    version_suppl=$(echo "$1" | sed "s/,/;/g" | cut -d "~" -f 2)
    version=$(echo "$1" | sed "s/,/;/g" | cut -d "~" -f 1)

    count=$(grep --perl-regex "^$version\t" debian/version_list.txt | wc -l)
    if [ $count -gt 1 ]; then \
      if [ -f "debian/$PKG_NAME.substvars" ]; then rm "debian/$PKG_NAME.substvars"; fi
      for i in $(seq 1 $((count - 1))); do \
        LINES="$(grep --perl-regex "^$version\t" debian/version_list.txt | grep -v --perl-regex "^$version\t.* $version_suppl\t")"
        CONFLICT_VER=$(sed "${i}q;d" <<< "$LINES" | cut -d "	" -f2)
        CONFLICT_VERBIS=$(sed "${i}q;d" <<< "$LINES" | cut -d "	" -f4 | cut -d " " -f4 | tr '[:upper:]' '[:lower:]')
        if [[ ! "$CONFLICT_VERBIS" =~ ^"$CONFLICT_VER".* ]]; then
          CONFLICT_VER="$CONFLICT_VER-$CONFLICT_VERBIS"
        else
          CONFLICT_VER="$CONFLICT_VERBIS"
        fi
        touch "debian/$PKG_NAME.substvars"
        if ! grep "google-android-platform-$VER-installer:Conflicts=" "debian/$PKG_NAME.substvars" > /dev/null; then \
          echo "google-android-platform-$VER-installer:Conflicts=" >> "debian/$PKG_NAME.substvars"
        fi
        sed -i -e "/google-android-platform-$VER-installer:Conflicts=/ s/=\(.*\)/=google-android-$PKG_NAME_SHORT-$CONFLICT_VER-installer, \1/" "debian/$PKG_NAME.substvars"
        sed -i -e "/google-android-platform-$VER-installer:Conflicts=/ s/, $//" "debian/$PKG_NAME.substvars"
      done
    fi
  fi

  # build-tools
  if [ "$PKG_NAME_SHORT" = "build-tools" ]; then
    local last_version ver_increment
    local provides_bin provides_ver provided conflicting conflict

    last_version="$(tail -n1 <<< ${BUILD_TOOLS_VERSIONS_TO_PACKAGE} | sort -V | cut -d "," -f 2)"
    ver_increment=$(grep -n "$1" <<< "${BUILD_TOOLS_VERSIONS_TO_PACKAGE}" | cut -d : -f 1)

    if [ -f "debian/$PKG_NAME.alternatives" ]; then rm "debian/$PKG_NAME.alternatives"; fi

    for binary in "${build_tools_provides[@]}"; do
      provides_relpath="$(cut -d "|" -f 1 <<< "$binary")"
      provides_bin="$(basename "$provides_relpath")"
      provides_ver="$(cut -d "|" -f 2 <<< "$binary")"
      conflict="$(cut -d "|" -f 3 <<< "$binary")"
      if dpkg --compare-versions "$VER" ge "$provides_ver"; then
        provided="$provided, $provides_bin"
        if [ -n "$conflict" ]; then
          conflicting="$conflicting, $conflict"
        fi
        add_alternatives "$1" "$provides_relpath" "$((50 + $ver_increment))"
      fi
    done
    provided="$(tail -c +3 <<< "$provided")"
    conflicting="$(tail -c +3 <<< "$conflicting")"

    if [ -f "debian/$PKG_NAME.substvars" ]; then rm "debian/$PKG_NAME.substvars"; fi

    touch "debian/$PKG_NAME.substvars"
    if ! grep "$PKG_NAME_SHORT:Provides=" "debian/$PKG_NAME.substvars" > /dev/null; then \
      echo "$PKG_NAME_SHORT:Provides=$provided" >> "debian/$PKG_NAME.substvars"
      echo "$PKG_NAME_SHORT:Conflicts=$conflicting" >> "debian/$PKG_NAME.substvars"
      echo "$PKG_NAME_SHORT:Replaces=$conflicting" >> "debian/$PKG_NAME.substvars"
    fi
  fi

  # cmdline-tools
  if [ "$PKG_NAME_SHORT" = "cmdline-tools" ]; then
    local last_version ver_increment
    local provides_bin provides_ver provided conflicting conflict

    last_version="$(tail -n1 <<< ${CMDLINE_TOOLS_VERSIONS_TO_PACKAGE} | sort -V | cut -d "," -f 2)"
    ver_increment=$(grep -n "$1" <<< "${CMDLINE_TOOLS_VERSIONS_TO_PACKAGE}" | cut -d : -f 1)

    if [ -f "debian/$PKG_NAME.alternatives" ]; then rm "debian/$PKG_NAME.alternatives"; fi

    for binary in "${cmdline_tools_provides[@]}"; do
      provides_relpath="$(cut -d "|" -f 1 <<< "$binary")"
      provides_bin="$(basename "$provides_relpath")"
      provides_ver="$(cut -d "|" -f 2 <<< "$binary")"
      conflict="$(cut -d "|" -f 3 <<< "$binary")"
      if dpkg --compare-versions "$VER" ge "$provides_ver"; then
        provided="$provided, $provides_bin"
        if [ -n "$conflict" ]; then
          conflicting="$conflicting, $conflict"
        fi
        add_alternatives "$1" "$provides_relpath" "$((50 + $ver_increment))"
      fi

      # Add a Provides value for the virtual package 'google-android-cmdline-tools-latest-installer'
      if [ "$VER" = "$last_version" ]; then
        provided="$provided, google-android-cmdline-tools-latest-installer"
      fi

    done
    provided="$(tail -c +3 <<< "$provided")"
    conflicting="$(tail -c +3 <<< "$conflicting")"

    if [ -f "debian/$PKG_NAME.substvars" ]; then rm "debian/$PKG_NAME.substvars"; fi

    touch "debian/$PKG_NAME.substvars"
    if ! grep "$PKG_NAME_SHORT:Provides=" "debian/$PKG_NAME.substvars" > /dev/null; then \
      echo "$PKG_NAME_SHORT:Provides=$provided" >> "debian/$PKG_NAME.substvars"
      echo "$PKG_NAME_SHORT:Conflicts=$conflicting" >> "debian/$PKG_NAME.substvars"
      echo "$PKG_NAME_SHORT:Replaces=$conflicting" >> "debian/$PKG_NAME.substvars"
    fi
  fi

  # emulator & platform-tools
  if [ "$PKG_NAME_SHORT" = "emulator" ] || [ "$PKG_NAME_SHORT" = "platform-tools" ]; then
    cp debian/$PKG_NAME_SHORT.bash-completion debian/$PKG_NAME.bash-completion
    cp debian/$PKG_NAME_SHORT.links debian/$PKG_NAME.links
  fi

}

echo "Removing sha1 sums files"
rm -f for-postinst/default/*.sha1

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
  echo "    Creating autogenerated files for $version"
  generate_files "$version"
done

cp debian/google-android-licenses.copyright.in debian/google-android-licenses.copyright
