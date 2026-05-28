#!/usr/bin/env bash
# Show which illustrations the page needs and which are still missing.
# Usage: bin/art-status.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "Illustrations referenced by index.html (these are 'in use' on the page):"
echo

have=0 need=0
while IFS= read -r f; do
  if [ -f "assets/illustrations/$f" ]; then
    printf '  \033[32m✓\033[0m  %s\n' "$f"
    have=$((have + 1))
  else
    printf '  \033[31m✗\033[0m  %s  (missing — shows alt-text for now)\n' "$f"
    need=$((need + 1))
  fi
done < <(grep -oE 'src="assets/illustrations/[a-z0-9-]+\.png"' index.html | sed -E 's#src="assets/illustrations/(.*)"#\1#' | sort -u)

echo
echo "  $have present · $need missing"
echo
echo "To generate art: open IMAGE-PROMPTS.md, paste a slot's prompt into Gemini/ChatGPT,"
echo "then promote your favorite with:  bin/add-art.sh <filename.png> <path-to-image>"
