#!/usr/bin/env bash
set -euo pipefail

PORT="${1:-8000}"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BLOG_APP_DIR="$ROOT_DIR/blog-app"

cd "$BLOG_APP_DIR"
./scripts-sync-blog.sh

cd "$ROOT_DIR"

echo ""
echo "Previewing the synced root site at:"
echo "  http://127.0.0.1:${PORT}/"
echo "  http://127.0.0.1:${PORT}/blog/"
echo ""
echo "Press Ctrl+C to stop."

python3 -m http.server "$PORT"
