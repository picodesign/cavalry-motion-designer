#!/usr/bin/env sh
# Copy the skill into the agent skills folder.
# Usage: ./install.sh [target-directory]   (default: ~/.claude/skills)
set -eu

NAME="cavalry-motion-designer"
SRC="$(cd "$(dirname "$0")" && pwd)/skills/$NAME"
TARGET="${1:-$HOME/.claude/skills}"

if [ ! -d "$SRC" ]; then
  echo "Skill folder not found: $SRC" >&2
  exit 1
fi

mkdir -p "$TARGET"
rm -rf "$TARGET/$NAME"
cp -R "$SRC" "$TARGET/$NAME"
echo "Installed $NAME to $TARGET/$NAME"
echo "Restart your agent session to load it."
