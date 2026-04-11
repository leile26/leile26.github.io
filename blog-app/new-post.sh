#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: ./new-post.sh <slug> [-b|--bilingual]"
  exit 1
fi

SLUG="$1"
BILINGUAL="${2:-}"

if [ -n "$BILINGUAL" ] && [ "$BILINGUAL" != "--bilingual" ] && [ "$BILINGUAL" != "-b" ]; then
  echo "Usage: ./new-post.sh <slug> [-b|--bilingual]"
  exit 1
fi
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
EN_TEMPLATE="$ROOT_DIR/templates/post-template.md"
ZH_TEMPLATE="$ROOT_DIR/templates/post-template.zh.md"
EN_TARGET="$ROOT_DIR/src/pages/blog/${SLUG}.md"
ZH_TARGET="$ROOT_DIR/src/pages/blog/${SLUG}.zh.md"
TODAY="$(date +%F)"

if [ -f "$EN_TARGET" ]; then
  echo "Post already exists: $EN_TARGET"
  exit 1
fi

cp "$EN_TEMPLATE" "$EN_TARGET"
python3 - <<PY
from pathlib import Path
p = Path(r'''$EN_TARGET''')
text = p.read_text()
text = text.replace('Your Post Title', '$SLUG'.replace('-', ' ').title(), 1)
text = text.replace('2026-04-09', '$TODAY', 1)
text = text.replace('your-post-slug', '$SLUG')
p.write_text(text)
PY

echo "Created: $EN_TARGET"

if [ "$BILINGUAL" = "--bilingual" ] || [ "$BILINGUAL" = "-b" ]; then
  if [ -f "$ZH_TARGET" ]; then
    echo "Chinese post already exists: $ZH_TARGET"
    exit 1
  fi
  cp "$ZH_TEMPLATE" "$ZH_TARGET"
  python3 - <<PY
from pathlib import Path
p = Path(r'''$ZH_TARGET''')
text = p.read_text()
text = text.replace('你的文章标题', '$SLUG'.replace('-', ' ').title(), 1)
text = text.replace('2026-04-09', '$TODAY', 1)
text = text.replace('your-post-slug', '$SLUG')
p.write_text(text)
PY
  echo "Created Chinese version: $ZH_TARGET"
fi
