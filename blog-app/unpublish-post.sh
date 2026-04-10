#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: ./unpublish-post.sh <slug>"
  exit 1
fi

SLUG="$1"
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE="$ROOT_DIR/src/pages/blog/${SLUG}.md"
DRAFT_DIR="$ROOT_DIR/drafts"
TARGET="$DRAFT_DIR/${SLUG}.md"

if [ ! -f "$SOURCE" ]; then
  echo "Published post not found: $SOURCE"
  exit 1
fi

mkdir -p "$DRAFT_DIR"

if [ -f "$TARGET" ]; then
  echo "Draft already exists: $TARGET"
  exit 1
fi

mv "$SOURCE" "$TARGET"
echo "Moved back to drafts: $TARGET"
