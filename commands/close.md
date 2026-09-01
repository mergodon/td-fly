---
description: Wrap a work session or project — capture core knowledge to repo docs (working-style to memory), run a fresh-eyes sweep of docs + memory, file only the leftovers that clear a high bar (max 3), close issues that are done or dead, commit, and push. The lean close ceremony.
---

You are closing a work session. Keep it lean — this is a checkpoint, not a ceremony. Do these in order; skip silently what doesn't apply.

# 1. Capture what's worth keeping
Sort by *kind* — two homes, and the split matters:
- **Core project knowledge** surfaced this session — only the heart-of-the-system facts that constrain the code: load-bearing invariants, biting gotchas, deploy discipline, key decisions, open bugs → write it to a **repo doc** next to the code (extend an existing `docs/` file or `CLAUDE.md`; don't spawn a scaffold). Capture only the core, not every finding — the transcripts and git are the archive. Versioned, visible to anyone who clones the repo. **Never memory.**
- **Working-style facts** — user preferences, how-we-work feedback, cross-session context → the built-in memory store; update existing files, don't duplicate.

Unsure which? *Constrains the code* → repo doc. *About how we work* → memory. Nothing new of either kind → skip.

# 2. Sweep — docs + memory (fresh eyes)
Spawn ONE subagent with **no prior context** for a fast hygiene sweep across both stores. **Hand it `${CLAUDE_PLUGIN_ROOT}/references/sweep-criteria.md`** — that file defines what counts as drift, what to verify, and (just as important) what NOT to flag. Paste the resolved absolute path into the subagent's prompt; if `${CLAUDE_PLUGIN_ROOT}` came through unsubstituted, say so and fall back to the inline list below. Ask it for a SHORT prioritized list (HIGH/MED/LOW) — not new documentation, not a full audit, no scores or grades; the goal is a fast "where are we":
- **Repo docs + command files** — claims that don't match what the commands actually do, dead references, drift between files, stale status/version, leftover scaffold.
- **The memory store** — pass it this project's memory dir (`~/.claude/projects/<absolute cwd with every `/` replaced by `-`>/memory/`) plus its `MEMORY.md` index. Flag: entries stale or contradicted by current code/git, duplicates, an index line out of sync with its file, and **code-governing knowledge that has drifted into memory** (build status, invariants, design decisions → belong in a repo doc, never memory).

Then fix the trivial/reversible misses inline yourself — prune a dead memory file *and* its index line, correct a stale status, move drifted knowledge into the repo doc. Fold anything bigger or judgment-heavy into step 3 — where most of it will not clear the filing bar, which is the point. Clean bill → say so in one line and move on. Don't re-flag what's already parked or deliberately accepted as lean. Keep it bounded — a tiny store sweeps in seconds; this stays a checkpoint, not an audit.

# 3. File leftovers — the bar is HIGH
**Read `${CLAUDE_PLUGIN_ROOT}/references/issue-discipline.md` before filing anything.** It carries the two gates, the do/don't lists, the 3-per-close ceiling, and the measured reason the bar exists.

The default is **don't file** — most closes file zero. File only what would cost something real if lost AND has a concrete trigger observed this session. Consolidate related candidates first; set the Issue Type in the same `createIssue` mutation; body opens `**From:** <project-name>@<branch>`. No confirm round — file, or drop it silently. Nothing cleared the bar → say so in step 6.

# 4. Close what's done or dead
Same reference file, "Closing" section — it carries the three close-triggers (resolved / obsolete / stale Idea 60d+), what to leave alone, and the 10-per-run cap.

Fetch this repo's open issues (GraphQL, same query shape as `/td-fly:mailbox` step 2 — you need `issueType` and `body`). Closing is reversible, so it runs without asking. Verify a premise before calling it obsolete. Every close carries a one-line comment. Nothing to close → skip silently.

# 5. Commit & push
- `git status --short` — if there are uncommitted changes, ask: commit / stash / discard. Wait for the answer.
- Commit shipped work with a conventional message (`feat:` / `fix:` / `chore:` / `docs:`).
- Push to `origin/main`. No PRs. If push is rejected, surface the error and stop.

# 6. Report
One line: what shipped, what the sweep found (docs + memory), what was filed (and what was dropped at the bar), what was closed, what was documented (repo) vs remembered (memory).
