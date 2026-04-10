#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: ./new-post.sh <slug>"
  exit 1
fi

SLUG="$1"
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE="$ROOT_DIR/templates/post-template.md"
TARGET="$ROOT_DIR/src/pages/blog/${SLUG}.md"
TODAY="$(date +%F)"

if [ -f "$TARGET" ]; then
  echo "Post already exists: $TARGET"
  exit 1
fi

cp "$TEMPLATE" "$TARGET"
python3 - <<PY
from pathlib import Path
p = Path(r'''$TARGET''')
text = p.read_text()
text = text.replace('Your Post Title', '$SLUG'.replace('-', ' ').title(), 1)
text = text.replace('2026-04-09', '$TODAY', 1)
p.write_text(text)
PY

echo "Created: $TARGET"
