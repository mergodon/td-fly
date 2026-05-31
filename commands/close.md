---
description: Wrap a work session or project — capture durable facts to memory, park leftover TODOs to GitHub issues, commit, and push. The lean close ceremony.
---

You are closing a work session. Keep it lean — this is a checkpoint, not a ceremony. Do these in order; skip silently what doesn't apply.

# 1. Remember
Scan the session for durable facts worth keeping (decisions, preferences, non-obvious technical findings, anything the user said to remember). Write them to the built-in memory store — update existing memory files rather than duplicating. Nothing new learned → skip.

# 2. Park leftovers
Gather any unfinished, out-of-scope items raised this session. Present them as ONE numbered digest, each with a suggested action (`file as Bug / Task / Idea` / `drop`). Take the user's decisions in one reply, then file the chosen ones as GitHub issues in this repo (`gh api graphql` with the right Issue Type; body opens `**From:** <project-name>`). Nothing to park → skip.

# 3. Commit & push
- `git status --short` — if there are uncommitted changes, ask: commit / stash / discard. Wait for the answer.
- Commit shipped work with a conventional message (`feat:` / `fix:` / `chore:` / `docs:`).
- Push to `origin/main`. No PRs. If push is rejected, surface the error and stop.

# 4. Report
One line: what shipped, what was parked, what's remembered.
