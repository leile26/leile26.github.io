#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BLOG_APP_DIR="$ROOT_DIR/blog-app"
DIST_BLOG_DIR="$BLOG_APP_DIR/dist/blog"
TARGET_BLOG_DIR="$ROOT_DIR/blog"

# Help non-interactive shells find Node/npm on macOS.
export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/local/opt/node@22/bin:$PATH"

if command -v npm >/dev/null 2>&1; then
  PKG_MGR="npm"
  BUILD_CMD=(npm run build)
  INSTALL_CMD=(npm install)
elif command -v pnpm >/dev/null 2>&1; then
  PKG_MGR="pnpm"
  BUILD_CMD=(pnpm build)
  INSTALL_CMD=(pnpm install)
elif command -v yarn >/dev/null 2>&1; then
  PKG_MGR="yarn"
  BUILD_CMD=(yarn build)
  INSTALL_CMD=(yarn install)
else
  echo "Error: could not find npm, pnpm, or yarn in PATH."
  echo "Current PATH: $PATH"
  echo "Please ensure Node.js is installed and available in your shell, then retry."
  exit 1
fi

cd "$BLOG_APP_DIR"

# If dependencies are missing, install them automatically.
if [ ! -x "$BLOG_APP_DIR/node_modules/.bin/astro" ]; then
  echo "astro binary not found under blog-app/node_modules/.bin/."
  echo "Installing blog dependencies with $PKG_MGR..."
  "${INSTALL_CMD[@]}"
fi

"${BUILD_CMD[@]}"

rm -rf "$TARGET_BLOG_DIR"
mkdir -p "$TARGET_BLOG_DIR"
cp -R "$DIST_BLOG_DIR/"* "$TARGET_BLOG_DIR/"

echo "Synced Astro blog output to $TARGET_BLOG_DIR"
