#!/usr/bin/env bash
# Promote a chosen illustration onto the live page and publish it.
#
# Usage:  bin/add-art.sh <target-filename.png> <path-to-chosen-image>
# Example: bin/add-art.sh hero-waterfall.png ~/Downloads/gemini-hero.png
#
# Copies your pick to assets/illustrations/<target>, commits, and pushes.
# GitHub Pages republishes automatically (~1 min). No Claude tokens spent.
set -euo pipefail

TARGET="${1:-}"
SRC="${2:-}"
if [ -z "$TARGET" ] || [ -z "$SRC" ]; then
  echo "Usage: bin/add-art.sh <target-filename.png> <path-to-chosen-image>" >&2
  exit 2
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

[ -f "$SRC" ] || { echo "✗ source image not found: $SRC" >&2; exit 1; }

# Guard against typos: the target must be a filename the project knows about
# (either wired into the page, or listed as a slot in IMAGE-PROMPTS.md).
USED=$(grep -oE 'src="assets/illustrations/[a-z0-9-]+\.png"' index.html | sed -E 's#src="assets/illustrations/(.*)"#\1#' | sort -u)
KNOWN=$(grep -oE '[a-z0-9-]+\.png' IMAGE-PROMPTS.md | sort -u)

if grep -qx "$TARGET" <<<"$USED"; then
  :
elif grep -qx "$TARGET" <<<"$KNOWN"; then
  echo "ℹ️  '$TARGET' is a known slot but isn't wired into index.html yet."
  echo "    The file will be added, but won't appear until an <img> references it."
else
  echo "✗ '$TARGET' is not a known illustration. Valid filenames:" >&2
  printf '%s\n' "$KNOWN" | sed 's/^/    /' >&2
  exit 1
fi

case "$SRC" in
  *.png|*.PNG) ;;
  *) echo "⚠️  source isn't a .png; the page expects PNGs (continuing anyway)." ;;
esac

cp "$SRC" "assets/illustrations/$TARGET"
echo "✓ placed assets/illustrations/$TARGET"

git add "assets/illustrations/$TARGET"
git commit -q -m "Add illustration: $TARGET"
git push -q
echo "✓ committed and pushed — GitHub Pages will republish shortly"
echo "  https://kevinselhi.github.io/natural-explorers/"
