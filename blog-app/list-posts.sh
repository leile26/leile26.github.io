#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
POST_DIR="$ROOT_DIR/src/pages/blog"

if [ ! -d "$POST_DIR" ]; then
  echo "No published post directory found: $POST_DIR"
  exit 0
fi

COUNT=0
while IFS= read -r file; do
  [ -n "$file" ] || continue
  base="$(basename "$file")"
  if [ "$base" = "index.astro" ]; then
    continue
  fi
  echo "- $base"
  COUNT=$((COUNT + 1))
done < <(find "$POST_DIR" -maxdepth 1 -type f | sort)

if [ "$COUNT" -eq 0 ]; then
  echo "No published posts found."
fi
