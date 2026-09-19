#!/bin/bash
# Create a new draft post. Double-click to run.
set -euo pipefail

SITE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$SITE"

printf 'Post title: '
read -r TITLE
if [ -z "${TITLE:-}" ]; then
  echo "No title given. Nothing created."
  read -r -p "Press return to close." _ || true
  exit 1
fi

SLUG=$(printf '%s' "$TITLE" \
  | tr '[:upper:]' '[:lower:]' \
  | sed -e 's/[^a-z0-9]\{1,\}/-/g' -e 's/^-//' -e 's/-$//')
[ -n "$SLUG" ] || SLUG="post"

mkdir -p _drafts
FILE="_drafts/${SLUG}.md"
if [ -e "$FILE" ]; then
  FILE="_drafts/${SLUG}-$(date +%H%M%S).md"
fi

cat > "$FILE" <<EOF
---
title: "${TITLE//\"/\\\"}"
description: >-
  One or two sentences that show up on the writing index and in link previews.
tags: []
---

Write here in Markdown. The first paragraph is your opening.

<!--more-->

## A heading

Body text, \`inline code\`, and fenced blocks all work:

\`\`\`bash
echo hello
\`\`\`
EOF

echo
echo "Created: $FILE"
echo "Edit it, then run publish.command to put it on the site."
echo

if command -v code >/dev/null 2>&1; then
  code "$SITE" "$FILE" >/dev/null 2>&1 || open -t "$FILE" || true
else
  open -t "$FILE" || true
fi

read -r -p "Press return to close." _ || true
