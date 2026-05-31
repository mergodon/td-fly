#!/usr/bin/env bash
# td-fly: link the shared contract into ~/.claude so projects can @import it.
# Idempotent — safe to re-run. The symlink points back into this repo, so a
# `git pull` here updates the contract in every project at once (zero drift).
set -euo pipefail
src="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/contract.md"
dst="$HOME/.claude/td-fly.md"
mkdir -p "$HOME/.claude"
ln -sfn "$src" "$dst"
echo "linked $dst -> $src"
echo "Add this line to a project's CLAUDE.md to adopt the contract:"
echo "  @~/.claude/td-fly.md"
