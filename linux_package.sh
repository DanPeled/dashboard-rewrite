#!/bin/bash

# Ensure the script is run from the Flutter project's root directory
if [ ! -f "pubspec.yaml" ]; then
  echo "This script must be run from the root of a Flutter project"
  exit 1
fi

# Parse the pubspec.yaml file to get the necessary data
APP_NAME_ORIG=$(grep -m 1 name pubspec.yaml | awk '{print $2}')

# Replace underscores with dashes in the app name
APP_NAME=$(echo "$APP_NAME_ORIG" | tr '_' '-')
APP_VERSION=$(grep -m 1 version pubspec.yaml | awk '{print $2}')

# Sanitize version to ensure no newline or invalid characters
APP_VERSION=$(echo "$APP_VERSION" | tr -d '\n' | tr -d '\r')
DESCRIPTION=$(grep description pubspec.yaml | awk '{print $2}')
# Define other package properties
ARCHITECTURE="amd64"                        # Assuming 64-bit Linux
DEPENDENCIES="libgtk-3-0, libflutter-linux" # Adjust based on actual dependencies

# Create directories for packaging
PACKAGE_DIR="$APP_NAME-package"
BIN_DIR="$PACKAGE_DIR/usr/local/bin"
LIB_DIR="$PACKAGE_DIR/usr/local/lib" # Directory for shared libraries
DEBIAN_DIR="$PACKAGE_DIR/DEBIAN"
TAR_DIR="$PACKAGE_DIR"

mkdir -p "$BIN_DIR"
mkdir -p "$LIB_DIR"
mkdir -p "$DEBIAN_DIR"

# Build the Flutter executable and copy to the bin directory
flutter build linux
cp build/linux/x64/release/bundle/$APP_NAME_ORIG "$BIN_DIR/"

# Copy the libapp.so file to the lib directory
cp build/lib/libapp.so "$LIB_DIR/"

# Create the DEBIAN/control file with necessary package metadata
cat <<EOF >"$DEBIAN_DIR/control"
Package: $APP_NAME
Version: $APP_VERSION
Architecture: $ARCHITECTURE
Maintainer: Gold87 
Installed-Size: $(du -s $BIN_DIR | awk '{print $1}')
Depends: $DEPENDENCIES
Section: utils
Priority: optional
Description: $DESCRIPTION
EOF

# Build the .deb package
dpkg-deb --build "$PACKAGE_DIR"
echo "DEB package created: $PACKAGE_DIR.deb"

# Create a .tar.gz archive of the Flutter app
tar -czvf "$APP_NAME-$APP_VERSION-linux.tar.gz" -C build/linux/x64/release/bundle $APP_NAME
echo "TAR.GZ package created: $APP_NAME-$APP_VERSION-linux.tar.gz"

# Clean up
rm -rf "$PACKAGE_DIR"

echo "Packaging complete."
