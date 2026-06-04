---
description: Wrap a work session or project — capture core knowledge to repo docs (working-style to memory), run a fresh-eyes reality check for discrepancies, park leftover TODOs to GitHub issues, commit, and push. The lean close ceremony.
---

You are closing a work session. Keep it lean — this is a checkpoint, not a ceremony. Do these in order; skip silently what doesn't apply.

# 1. Capture what's worth keeping
Sort by *kind* — two homes, and the split matters:
- **Core project knowledge** surfaced this session — only the heart-of-the-system facts that constrain the code: load-bearing invariants, biting gotchas, deploy discipline, key decisions, open bugs → write it to a **repo doc** next to the code (extend an existing `docs/` file or `CLAUDE.md`; don't spawn a scaffold). Capture only the core, not every finding — the transcripts and git are the archive. Versioned, visible to anyone who clones the repo. **Never memory.**
- **Working-style facts** — user preferences, how-we-work feedback, cross-session context → the built-in memory store; update existing files, don't duplicate.

Unsure which? *Constrains the code* → repo doc. *About how we work* → memory. Nothing new of either kind → skip.

# 2. Reality check (fresh eyes)
Only if this session changed docs or commands. Spawn ONE subagent with **no prior context** to read this repo's docs + command files and flag discrepancies — claims that don't match what the commands actually do, dead references, drift between files, stale status/version, leftover scaffold. Ask it for a SHORT prioritized list (HIGH/MED/LOW), not new documentation — the goal is a fast "where are we", not a full audit. Then: fix the trivial/reversible mismatches inline yourself; fold anything bigger into the Park step below. Clean bill → say so in one line and move on. Don't re-flag something already parked or deliberately accepted as lean.

# 3. Park leftovers
Gather any unfinished, out-of-scope items raised this session. **Consolidate** related ones into a single issue first (don't file three near-duplicates). Then **just file them** — no confirm round — each at its recommended Issue Type (Bug / Task / Idea) via `gh api graphql`; body opens `**From:** <project-name>@<branch>` (short name from `gh repo view --json name`, branch from `git branch --show-current` — the marker `/td-fly:mailbox` filters on; tagging the branch keeps a parked leftover scoped to the branch it came from). Parking is reversible and the goal is to keep flying, not lose anything — so favor filing over asking. Pause to ask **only** when a leftover carries a genuinely important or ambiguous call (worth filing at all? big scope?); everything else, file and report in step 5. Drop pure noise silently. Nothing to park → skip.

# 4. Commit & push
- `git status --short` — if there are uncommitted changes, ask: commit / stash / discard. Wait for the answer.
- Commit shipped work with a conventional message (`feat:` / `fix:` / `chore:` / `docs:`).
- Push to `origin/main`. No PRs. If push is rejected, surface the error and stop.

# 5. Report
One line: what shipped, what the reality check found, what was parked, what was documented (repo) vs remembered (memory).
