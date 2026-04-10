#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
DRAFT_DIR="$ROOT_DIR/drafts"

if [ ! -d "$DRAFT_DIR" ]; then
  echo "No drafts directory yet: $DRAFT_DIR"
  exit 0
fi

COUNT=0
while IFS= read -r file; do
  [ -n "$file" ] || continue
  echo "- $(basename "$file")"
  COUNT=$((COUNT + 1))
done < <(find "$DRAFT_DIR" -maxdepth 1 -type f -name '*.md' | sort)

if [ "$COUNT" -eq 0 ]; then
  echo "No drafts found."
fi
