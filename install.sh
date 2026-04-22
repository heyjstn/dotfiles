#!/usr/bin/env sh

set -eu

if [ "$(uname -s)" != "Darwin" ]; then
  echo "install.sh only supports macOS." >&2
  exit 1
fi

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ASSETS_DIR="$SCRIPT_DIR/assets"
FONT_DIR="$HOME/Library/Fonts"

if [ ! -d "$ASSETS_DIR" ]; then
  echo "Missing assets directory: $ASSETS_DIR" >&2
  exit 1
fi

mkdir -p "$FONT_DIR"

found_font=0

for font in \
  "$ASSETS_DIR"/*.otf \
  "$ASSETS_DIR"/*.OTF \
  "$ASSETS_DIR"/*.ttf \
  "$ASSETS_DIR"/*.TTF \
  "$ASSETS_DIR"/*.ttc \
  "$ASSETS_DIR"/*.TTC \
  "$ASSETS_DIR"/*.dfont \
  "$ASSETS_DIR"/*.DFONT
do
  [ -f "$font" ] || continue

  cp -f "$font" "$FONT_DIR/"
  echo "Installed $(basename "$font") to $FONT_DIR"
  found_font=1
done

if [ "$found_font" -eq 0 ]; then
  echo "No font files were found in $ASSETS_DIR" >&2
  exit 1
fi

echo "Fonts are now available in Font Book."
