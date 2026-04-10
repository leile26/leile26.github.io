#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: ./push-blog.sh \"commit message\""
  exit 1
fi

COMMIT_MSG="$1"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

cd "$ROOT_DIR"

git add .

if git diff --cached --quiet; then
  echo "No staged changes to commit."
  exit 0
fi

git commit -m "$COMMIT_MSG"
git pull --rebase origin master
git push

echo "Pushed successfully. If blog-app changes were included, GitHub Actions may add one follow-up sync commit automatically."
