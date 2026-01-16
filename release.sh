#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"
BUILD_DIR="$PROJECT_DIR/target/x86_64-pc-windows-gnu/release"
RELEASE_STAGING="$PROJECT_DIR/GreenLuma"
LUMA_DIR="$PROJECT_DIR/luma"
OUTPUT_ZIP="$PROJECT_DIR/GreenLuma.zip"

bash "$PROJECT_DIR/build_windows.sh"

echo "Preparing GreenLuma directory..."
if [ -d "$RELEASE_STAGING" ]; then
    rm -rf "$RELEASE_STAGING"
fi
mkdir -p "$RELEASE_STAGING"

echo "Copying executable..."
cp "$BUILD_DIR/sunflower-luma.exe" "$RELEASE_STAGING/"

echo "Copying luma directory contents..."
if [ -d "$LUMA_DIR" ]; then
    cp -r "$LUMA_DIR"/* "$RELEASE_STAGING/"
else
    echo "warn: luma directory not found at $LUMA_DIR"
fi

echo "Creating zip archive..."
if [ -f "$OUTPUT_ZIP" ]; then
    rm "$OUTPUT_ZIP"
fi
cd "$PROJECT_DIR"
zip -r "GreenLuma.zip" "GreenLuma/"

echo "Output: $OUTPUT_ZIP"
