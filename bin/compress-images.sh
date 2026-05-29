#!/usr/bin/env bash
# Compress site images that are too heavy for easy mobile load, then publish.
#
# Finds images on any page that are over budget (file > 1500KB OR longest edge
# > 1600px), rewrites them smaller IN PLACE (keeping filenames so the page
# <img> contract holds), then commits + pushes the changes — like publish-art.sh.
#
# Usage:
#   bin/compress-images.sh                 # compress over-budget images, then publish
#   bin/compress-images.sh --dry-run       # just report what's over budget (no writes, no push)
#   bin/compress-images.sh assets/illustrations/home-hero.png   # only these files
#   bin/compress-images.sh --max-kb 700 --max-dim 1400          # tune thresholds
#
# The heavy lifting (Pillow) lives in bin/compress_images.py. System Python is
# externally managed (PEP 668), so we keep a private venv at bin/.venv-img.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

VENV="$ROOT/bin/.venv-img"
PY="$VENV/bin/python"

# One-time venv + Pillow setup; reused on later runs.
if [ ! -x "$PY" ]; then
  echo "Setting up image-tools venv (one time)…"
  python3 -m venv "$VENV"
  "$VENV/bin/pip" install --quiet --upgrade pip
  "$VENV/bin/pip" install --quiet pillow
fi
if ! "$PY" -c "import PIL" 2>/dev/null; then
  "$VENV/bin/pip" install --quiet pillow
fi

# Run the compressor, passing through all args.
"$PY" "$ROOT/bin/compress_images.py" "$@"

# --dry-run never publishes.
for a in "$@"; do [ "$a" = "--dry-run" ] && exit 0; done

# Stage only image assets; if nothing changed, stop quietly.
shopt -s nullglob
git add assets/illustrations/*.png assets/photos/*.jpg assets/photos/*.jpeg assets/photos/*.png 2>/dev/null || true
shopt -u nullglob

if git diff --cached --quiet; then
  echo
  echo "No image changes to publish."
  exit 0
fi

echo
echo "Publishing compressed images:"
git diff --cached --name-only | sed 's/^/  /'

git commit -q -m "Compress oversized images for fast mobile load"
git push -q
echo
echo "✓ pushed — GitHub Pages republishes in ~1 min"
echo "  https://kevinselhi.github.io/natural-explorers/"
