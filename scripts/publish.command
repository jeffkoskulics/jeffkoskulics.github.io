#!/bin/bash
# Publish a draft: date it, move it to _posts, commit, push. Double-click to run.
set -euo pipefail

SITE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$SITE"

finish() {
  echo
  read -r -p "Press return to close." _ || true
}
trap finish EXIT

BRANCH=$(git rev-parse --abbrev-ref HEAD)

shopt -s nullglob
DRAFTS=(_drafts/*.md)
shopt -u nullglob

if [ ${#DRAFTS[@]} -eq 0 ]; then
  echo "No drafts in _drafts/."
  echo "Run new-post.command first, or just commit edits by hand."
  exit 0
fi

echo "Drafts:"
i=1
for d in "${DRAFTS[@]}"; do
  echo "  $i) $(basename "$d")"
  i=$((i + 1))
done
echo
printf 'Publish which number (return to cancel)? '
read -r CHOICE
[ -n "${CHOICE:-}" ] || { echo "Cancelled."; exit 0; }
case "$CHOICE" in
  ''|*[!0-9]*) echo "Not a number. Cancelled."; exit 1 ;;
esac
if [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt ${#DRAFTS[@]} ]; then
  echo "Out of range. Cancelled."
  exit 1
fi

SRC="${DRAFTS[$((CHOICE - 1))]}"
BASE=$(basename "$SRC")
TODAY=$(date +%Y-%m-%d)
DEST="_posts/${TODAY}-${BASE}"

if [ -e "$DEST" ]; then
  echo "A post already exists at $DEST. Rename the draft and try again."
  exit 1
fi

TITLE=$(sed -n 's/^title:[[:space:]]*//p' "$SRC" | head -1 | sed 's/^"//; s/"$//')
[ -n "$TITLE" ] || TITLE="$BASE"

mkdir -p _posts
git mv "$SRC" "$DEST" 2>/dev/null || mv "$SRC" "$DEST"

echo
echo "Publishing: $TITLE"
echo "  -> $DEST"
echo

git add -A
git commit -q -m "post: ${TITLE}"

n=0
until git push -u origin "$BRANCH"; do
  n=$((n + 1))
  if [ "$n" -ge 4 ]; then
    echo
    echo "Push failed 4 times. The commit is saved locally; try again later with:"
    echo "  git -C \"$SITE\" push -u origin $BRANCH"
    exit 1
  fi
  WAIT=$((2 ** n))
  echo "Push failed. Retrying in ${WAIT}s..."
  sleep "$WAIT"
done

echo
echo "Pushed. GitHub Pages rebuilds in about a minute:"
echo "  https://jeffkoskulics.github.io/blog/"
