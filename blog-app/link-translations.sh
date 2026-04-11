#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: ./link-translations.sh <slug>"
  exit 1
fi

SLUG="$1"
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
EN_FILE="$ROOT_DIR/src/pages/blog/${SLUG}.md"
ZH_FILE="$ROOT_DIR/src/pages/blog/${SLUG}.zh.md"

if [ ! -f "$EN_FILE" ]; then
  echo "English post not found: $EN_FILE"
  exit 1
fi

if [ ! -f "$ZH_FILE" ]; then
  echo "Chinese post not found: $ZH_FILE"
  exit 1
fi

python3 - <<PY
from pathlib import Path

def replace_or_insert_alternate(path_str, value):
    path = Path(path_str)
    text = path.read_text()
    lines = text.splitlines()
    replaced = False
    for i, line in enumerate(lines):
        if line.startswith('alternate:'):
            lines[i] = f'alternate: {value}'
            replaced = True
            break
    if not replaced:
        for i, line in enumerate(lines):
            if line.startswith('translationKey:'):
                lines.insert(i + 1, f'alternate: {value}')
                replaced = True
                break
    path.write_text('\n'.join(lines) + '\n')

replace_or_insert_alternate(r'''$EN_FILE''', '"/blog/$SLUG.zh/"')
replace_or_insert_alternate(r'''$ZH_FILE''', '"/blog/$SLUG/"')
PY

echo "Linked translations: $EN_FILE <-> $ZH_FILE"
