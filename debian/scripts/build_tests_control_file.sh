#!/bin/bash

set -e

SCRIPT_PATH=$(dirname $0)

source $SCRIPT_PATH/_components_to_package.sh
source $SCRIPT_PATH/_common_functions.sh

DISABLE_TESTS=0
TEST_ONLY_ONE_PACKAGE_PER_COMPONENT=1

if [ $TEST_ONLY_ONE_PACKAGE_PER_COMPONENT -eq 1 ]; then
    # For BUILD_TOOLS_VERSIONS_TO_PACKAGE we take the 1st and last (because one contains 32bit binary, and the other 64bit binary)
    tmp=$(sort -u <<< $(head -n1 <<< ${BUILD_TOOLS_VERSIONS_TO_PACKAGE}; tail -n1 <<< ${BUILD_TOOLS_VERSIONS_TO_PACKAGE}))
    BUILD_TOOLS_VERSIONS_TO_PACKAGE=$tmp
    unset tmp
    PLATFORMS_VERSIONS_TO_PACKAGE=$(tail -n1 <<< ${PLATFORMS_VERSIONS_TO_PACKAGE})
    CMDLINE_TOOLS_VERSIONS_TO_PACKAGE=$(tail -n1 <<< ${CMDLINE_TOOLS_VERSIONS_TO_PACKAGE})
    PLATFORM_TOOLS_VERSIONS_TO_PACKAGE=$(tail -n1 <<< ${PLATFORM_TOOLS_VERSIONS_TO_PACKAGE})
    NDK_VERSIONS_TO_PACKAGE=$(tail -n1 <<< ${NDK_VERSIONS_TO_PACKAGE})
    EMULATOR_VERSIONS_TO_PACKAGE=$(tail -n1 <<< ${EMULATOR_VERSIONS_TO_PACKAGE})
    EXTRAS_GOOGLE_AUTO_VERSIONS_TO_PACKAGE=$(tail -n1 <<< ${EXTRAS_GOOGLE_AUTO_VERSIONS_TO_PACKAGE})
fi

#Disable test for some packages
#unset BUILD_TOOLS_VERSIONS_TO_PACKAGE
unset PLATFORMS_VERSIONS_TO_PACKAGE
unset CMDLINE_TOOLS_VERSIONS_TO_PACKAGE
unset PLATFORM_TOOLS_VERSIONS_TO_PACKAGE
unset NDK_VERSIONS_TO_PACKAGE
unset EMULATOR_VERSIONS_TO_PACKAGE
#unset EXTRAS_GOOGLE_AUTO_VERSIONS_TO_PACKAGE

# Build debian/tests/control file
mkdir -p debian/tests
echo "# -- This file was generated automatically by the debian/scripts/$(basename $0) script --" > debian/tests/control

if [ $DISABLE_TESTS -eq 1 ]; then
    # Disable tests to not use bandwith to download the packages
    rm debian/tests/control
    exit;
fi

for version in ${BUILD_TOOLS_VERSIONS_TO_PACKAGE}; do
    VER_MAJOR=$(get_version "$version" | cut -d . -f 1)
    PATH_DIRNAME="$(get_path_dirname "$version")"
    PATH_BASENAME="$(get_path_basename "$version")"

    echo "Test-Command: /usr/lib/android-sdk/$PATH_DIRNAME/$PATH_BASENAME/aapt v" >> debian/tests/control
    echo "Depends: $(get_package_name "$version")" >> debian/tests/control

    if [ $VER_MAJOR -le 23 ]; then
        echo "Architecture: i386 amd64" >> debian/tests/control
    else
        echo "Architecture: amd64" >> debian/tests/control
    fi

    echo "" >> debian/tests/control
done

for version in ${PLATFORMS_VERSIONS_TO_PACKAGE}; do
    PATH_DIRNAME="$(get_path_dirname "$version")"
    PATH_BASENAME="$(get_path_basename "$version")"

    echo "Test-Command: cat /usr/lib/android-sdk/$PATH_DIRNAME/$PATH_BASENAME/source.properties" >> debian/tests/control
    echo "Depends: $(get_package_name "$version")" >> debian/tests/control
    echo "" >> debian/tests/control
done

for version in ${CMDLINE_TOOLS_VERSIONS_TO_PACKAGE}; do
    PATH_DIRNAME="$(get_path_dirname "$version")"
    PATH_BASENAME="$(get_path_basename "$version")"

    echo "Test-Command: /usr/lib/android-sdk/$PATH_DIRNAME/$PATH_BASENAME/bin/sdkmanager --version" >> debian/tests/control
    echo "Depends: $(get_package_name "$version")" >> debian/tests/control
    echo "" >> debian/tests/control
done

for version in ${PLATFORM_TOOLS_VERSIONS_TO_PACKAGE}; do
    PATH_DIRNAME="$(get_path_dirname "$version")"
    PATH_BASENAME="$(get_path_basename "$version")"

    echo "Test-Command: /usr/lib/android-sdk/$PATH_DIRNAME/$PATH_BASENAME/adb version" >> debian/tests/control
    echo "Depends: $(get_package_name "$version")" >> debian/tests/control
    echo "Architecture: amd64" >> debian/tests/control
    echo "" >> debian/tests/control
done

for version in ${NDK_VERSIONS_TO_PACKAGE}; do
    VER_MAJOR=$(get_version "$version" | cut -d . -f 1)
    PATH_DIRNAME="$(get_path_dirname "$version")"
    PATH_BASENAME="$(get_path_basename "$version")"

    if [ $VER_MAJOR -lt 16 ]; then
        # This works for NDK r10e at least. Not tested for r11 to r15
        echo "Test-Command: \`/usr/lib/android-sdk/$PATH_DIRNAME/$PATH_BASENAME/ndk-which readelf\` -d /usr/lib/android-sdk/$PATH_DIRNAME/$PATH_BASENAME/platforms/android-21/arch-x86/usr/lib/libdl.so" >> debian/tests/control
    elif [ $VER_MAJOR -lt 23 ]; then
        echo "Test-Command: \`/usr/lib/android-sdk/$PATH_DIRNAME/$PATH_BASENAME/ndk-which readelf\` -d /usr/lib/android-sdk/$PATH_DIRNAME/$PATH_BASENAME/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/i686-linux-android/21/libdl.so" >> debian/tests/control
    else
        echo "Test-Command: /usr/lib/android-sdk/$PATH_DIRNAME/$PATH_BASENAME/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-readobj -d /usr/lib/android-sdk/$PATH_DIRNAME/$PATH_BASENAME/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/i686-linux-android/21/libdl.so" >> debian/tests/control
    fi
    echo "Depends: $(get_package_name "$version")" >> debian/tests/control
    echo "Architecture: amd64" >> debian/tests/control
    echo "" >> debian/tests/control
done

for version in ${EMULATOR_VERSIONS_TO_PACKAGE}; do
    PATH_DIRNAME="$(get_path_dirname "$version")"
    PATH_BASENAME="$(get_path_basename "$version")"

    echo "Test-Command: emulator -help" >> debian/tests/control
    echo "Depends: $(get_package_name "$version")" >> debian/tests/control
    echo "Architecture: amd64" >> debian/tests/control
    echo "" >> debian/tests/control
done

for version in ${EXTRAS_GOOGLE_AUTO_VERSIONS_TO_PACKAGE}; do
    PATH_DIRNAME="$(get_path_dirname "$version")"
    PATH_BASENAME="$(get_path_basename "$version")"

    echo "Test-Command: /usr/lib/android-sdk/$PATH_DIRNAME/$PATH_BASENAME/desktop-head-unit --version" >> debian/tests/control
    echo "Depends: $(get_package_name "$version")" >> debian/tests/control
    echo "Architecture: amd64" >> debian/tests/control
    echo "" >> debian/tests/control

done
