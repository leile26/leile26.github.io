#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: ./publish-post.sh <slug>"
  exit 1
fi

SLUG="$1"
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
DRAFT="$ROOT_DIR/drafts/${SLUG}.md"
TARGET_DIR="$ROOT_DIR/src/pages/blog"
TARGET="$TARGET_DIR/${SLUG}.md"

if [ ! -f "$DRAFT" ]; then
  echo "Draft not found: $DRAFT"
  exit 1
fi

mkdir -p "$TARGET_DIR"

if [ -f "$TARGET" ]; then
  echo "Published post already exists: $TARGET"
  exit 1
fi

mv "$DRAFT" "$TARGET"
echo "Published: $TARGET"
