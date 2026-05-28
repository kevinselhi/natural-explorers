#!/usr/bin/env bash
# Publish any new or updated hike-guide photos to the live page.
# Use after saving photos via photo-studio.html (or after dropping JPEGs into the folder).
# Usage: bin/publish-photos.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

shopt -s nullglob
photos=(assets/photos/*.jpg assets/photos/*.jpeg)
shopt -u nullglob
if [ ${#photos[@]} -gt 0 ]; then
  git add "${photos[@]}"
fi

if git diff --cached --quiet; then
  echo "No new or changed photos to publish."
  echo "(Save photos first via photo-studio.html, then re-run.)"
  exit 0
fi

echo "Publishing these photos:"
git diff --cached --name-only | sed 's/^/  /'

git commit -q -m "Add/update hike-guide photos (© Kevin Selhi)"
git push -q
echo
echo "✓ pushed — GitHub Pages republishes in ~1 min"
echo "  https://kevinselhi.github.io/natural-explorers/hike.html"
