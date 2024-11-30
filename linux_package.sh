#!/bin/bash

PUBSPEC_FILE="pubspec.yaml"
OUTPUT_DIR="build/linux/deb_package"
BUNDLE_DIR="build/linux/x64/release/bundle"
CONTROL_FILE="$OUTPUT_DIR/DEBIAN/control"
DESKTOP_FILE="$OUTPUT_DIR/usr/share/applications/$APP_NAME.desktop"

function read_pubspec() {
  key=$1
  yq eval ".${key}" "$PUBSPEC_FILE"
}

if [[ ! -f "$PUBSPEC_FILE" ]]; then
  echo "Error: pubspec.yaml not found! Ensure this script is run in the root of your Flutter project."
  exit 1
fi

APP_NAME=$(read_pubspec "name")
VERSION=$(read_pubspec "version")
DESCRIPTION=$(read_pubspec "description")
MAINTAINER="Gold86"

if [[ -z "$APP_NAME" || -z "$VERSION" || -z "$DESCRIPTION" ]]; then
  echo "Error: Missing required values in pubspec.yaml."
  exit 1
fi

# Default maintainer if not found
if [[ -z "$MAINTAINER" ]]; then
  MAINTAINER="Unknown"
fi

# Dependencies for Linux app
DEPENDENCIES="libc6, libstdc++6, libgtk-3-0"

echo "Packaging Flutter app '$APP_NAME' version '$VERSION'..."

echo "Building Flutter app for Linux..."
flutter build linux --release

echo "Preparing DEB package structure..."
mkdir -p "$OUTPUT_DIR/DEBIAN" "$OUTPUT_DIR/usr/share/$APP_NAME" "$OUTPUT_DIR/usr/share/applications"

# Copy built files
cp -r "$BUNDLE_DIR/"* "$OUTPUT_DIR/usr/share/$APP_NAME"

# Create control file
echo "Creating control file..."
cat >"$CONTROL_FILE" <<EOL
Package: elastic-dashboard
Version: $VERSION
Section: base
Priority: optional
Architecture: amd64
Maintainer: $MAINTAINER
Depends: $DEPENDENCIES
Description: $DESCRIPTION
EOL

# Create desktop entry
echo "Creating desktop entry..."
cat >"$DESKTOP_FILE" <<EOL
[Desktop Entry]
Name=$APP_NAME
Comment=$DESCRIPTION
Exec=/usr/share/$APP_NAME/$APP_NAME
Icon=$APP_NAME
Terminal=false
Type=Application
Categories=Utility;
EOL

# Ensure executable permissions on the app binary
chmod +x "$OUTPUT_DIR/usr/share/$APP_NAME/$APP_NAME"

# Build .deb package
echo "Building .deb package..."
dpkg-deb --build "$OUTPUT_DIR" "${APP_NAME}_${VERSION}_amd64.deb"

# Clean up
rm -rf "$OUTPUT_DIR"

echo "Package '${APP_NAME}_${VERSION}_amd64.deb' created successfully!"
