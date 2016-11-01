#!/usr/bin/env sh

SOURCE_DIR=$(dirname "$0")
TEMPLATES_DIR="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/"
FILE_TEMPLATES_DIR="$TEMPLATES_DIR/Templates/File Templates"
Awesome_TEMPLATES_DIR="$FILE_TEMPLATES_DIR/Source"
SOURCE_Awesome_DIR="$SOURCE_DIR"
SOURCE_DIR="$SOURCE_Awesome_DIR/AwesomeCommand Case Class.xctemplate"

echo "Installing templates to $Awesome_TEMPLATES_DIR from $SOURCE_DIR"
cp -R "$SOURCE_DIR" "$Awesome_TEMPLATES_DIR"
echo "Loading Finished"