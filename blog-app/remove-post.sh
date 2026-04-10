#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: ./remove-post.sh <slug>"
  exit 1
fi

SLUG="$1"
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
PUBLISHED="$ROOT_DIR/src/pages/blog/${SLUG}.md"
DRAFT="$ROOT_DIR/drafts/${SLUG}.md"
REMOVED=0

if [ -f "$PUBLISHED" ]; then
  rm -f "$PUBLISHED"
  echo "Removed published post: $PUBLISHED"
  REMOVED=1
fi

if [ -f "$DRAFT" ]; then
  rm -f "$DRAFT"
  echo "Removed draft: $DRAFT"
  REMOVED=1
fi

if [ "$REMOVED" -eq 0 ]; then
  echo "No post found for slug: $SLUG"
  exit 1
fi
