#!/usr/bin/env bash
# td-fly SessionStart hook. Prints ONE line when other repos have open issues filed
# into this repo, else nothing. Never fails the session: any error → silent exit 0.
set -u
exec 2>/dev/null
t() { if command -v timeout >/dev/null; then timeout 8 "$@"; else "$@"; fi; }

command -v gh  >/dev/null || exit 0
command -v git >/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null || exit 0

slug=$(t gh repo view --json nameWithOwner --jq .nameWithOwner) || exit 0
[ -n "$slug" ] || exit 0
name=${slug#*/}

# Open issues whose body opens with a **From:** marker naming ANOTHER repo; count those with no comment.
counts=$(t gh issue list -R "$slug" --state open --limit 100 --json body,comments --jq '
  [ .[] | select(.body | test("^\\*\\*From:\\*\\*"))
        | select((.body | capture("^\\*\\*From:\\*\\*\\s*(?<n>[^@\\s]+)").n) != "'"$name"'") ]
  | "\(length) \([ .[] | select((.comments | length) == 0) ] | length)"') || exit 0
set -- $counts
open=${1:-0}; unanswered=${2:-0}
[ "$open" -gt 0 ] 2>/dev/null || exit 0

echo "td-fly: $open open issue(s) filed into $slug by other repos, $unanswered unanswered. Say 'mailbox' to see them."
exit 0
