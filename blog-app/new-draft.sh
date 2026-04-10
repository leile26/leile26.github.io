#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: ./new-draft.sh <slug>"
  exit 1
fi

SLUG="$1"
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
DRAFT_DIR="$ROOT_DIR/drafts"
TEMPLATE="$ROOT_DIR/templates/post-template.md"
TARGET="$DRAFT_DIR/${SLUG}.md"
TODAY="$(date +%F)"

mkdir -p "$DRAFT_DIR"

if [ -f "$TARGET" ]; then
  echo "Draft already exists: $TARGET"
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

echo "Created draft: $TARGET"
