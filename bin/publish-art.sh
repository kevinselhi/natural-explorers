#!/usr/bin/env bash
# Publish any new or updated illustrations to the live page.
# Use after saving images via studio.html (or after dropping PNGs into the folder).
# Usage: bin/publish-art.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# Stage only illustration PNGs (nullglob so an empty match doesn't error).
shopt -s nullglob
pngs=(assets/illustrations/*.png)
shopt -u nullglob
if [ ${#pngs[@]} -gt 0 ]; then
  git add "${pngs[@]}"
fi

if git diff --cached --quiet; then
  echo "No new or changed illustrations to publish."
  echo "(Save images first via studio.html, then re-run.)"
  exit 0
fi

echo "Publishing these illustrations:"
git diff --cached --name-only | sed 's/^/  /'

git commit -q -m "Add/update illustrations"
git push -q
echo
echo "✓ pushed — GitHub Pages republishes in ~1 min"
echo "  https://kevinselhi.github.io/natural-explorers/"
