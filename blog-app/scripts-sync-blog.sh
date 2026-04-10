#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BLOG_APP_DIR="$ROOT_DIR/blog-app"
DIST_BLOG_DIR="$BLOG_APP_DIR/dist/blog"
TARGET_BLOG_DIR="$ROOT_DIR/blog"

cd "$BLOG_APP_DIR"
npm run build

rm -rf "$TARGET_BLOG_DIR"
mkdir -p "$TARGET_BLOG_DIR"
cp -R "$DIST_BLOG_DIR/"* "$TARGET_BLOG_DIR/"

echo "Synced Astro blog output to $TARGET_BLOG_DIR"
