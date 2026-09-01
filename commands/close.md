---
description: Wrap a work session — capture knowledge, sweep for drift, file only what clears the bar, close what's provably done, commit, push. The lean close ceremony.
---

You are closing a work session. Keep it lean — this is a checkpoint, not a ceremony. Do these in order; skip silently what doesn't apply.

# 1. Capture what's worth keeping
Sort by *kind* — two homes, and the split matters:
- **Core project knowledge** surfaced this session — only the heart-of-the-system facts that constrain the code: load-bearing invariants, biting gotchas, deploy discipline, key decisions, open bugs → write it to a **repo doc** next to the code (extend an existing `docs/` file or `CLAUDE.md`; don't spawn a scaffold). Capture only the core, not every finding — the transcripts and git are the archive. **Never memory.**
- **Working-style facts** — user preferences, how-we-work feedback, cross-session context → the built-in memory store; update existing files, don't duplicate.

Nothing new of either kind → skip.

# 2. Sweep — docs + memory (fresh eyes)
Spawn ONE subagent with **no prior context** and hand it `${CLAUDE_PLUGIN_ROOT}/references/sweep-criteria.md` — that file defines what to verify, what counts as drift, and what NOT to flag. Paste the resolved absolute path into its prompt, along with this project's memory dir (`~/.claude/projects/<absolute cwd with every `/` replaced by `-`>/memory/`) and its `MEMORY.md`. Ask for a SHORT prioritized list (HIGH/MED/LOW) — no scores, no grades, no rewritten docs.

If `${CLAUDE_PLUGIN_ROOT}` came through unsubstituted, say so and brief it inline instead: verify every path/command/version claim in the repo docs, and check memory for entries contradicted by current code, duplicates, index drift, and code-governing knowledge that belongs in a repo doc.

Fix the trivial and reversible inline yourself — prune a dead memory file *and* its index line, correct a stale version, move drifted knowledge into the repo doc. **Sweep findings never become issues** (see step 3's reference). Clean bill → one line, move on.

# 3. File leftovers — the bar is HIGH
**Read `${CLAUDE_PLUGIN_ROOT}/references/issue-discipline.md` before filing anything.** It sets both gates, the source test, the do/don't lists, the severity-aware ceiling and the per-repo backlog cap.

Consolidate related candidates first. Type it **Bug or Task only** — never `Idea`, never `Epic`; those are the owner's to create, and only when asked. Set it in the same `createIssue` mutation. Body opens `**From:** <project-name>@<branch>` (short name from `gh repo view --json name`, branch from `git branch --show-current`) and cites the duplicate search you ran. No confirm round — file, or drop it silently. Nothing cleared the bar → say so in step 6.

# 4. Commit & push
- `git status --short` — if there are uncommitted changes, ask: commit / stash / discard. Wait for the answer.
- Commit shipped work with a conventional message (`feat:` / `fix:` / `chore:` / `docs:`).
- Push to `origin/main`. No PRs. If push is rejected, surface the error and stop.

# 5. Close what's provably done
Runs *after* the commit so this session's work is visible to `git log --grep`. Same reference file, "Closing" section.

Fetch this repo's open issues (`gh issue list --state open --json number,title,body,issueType` — `issueType` is exposed as of gh 2.98.0). Close **only** on positive evidence: a commit implementing it (cite the sha), or a premise you verified is dead. Age is never evidence — stale candidates get **listed in the report for the owner to decide**, never auto-closed. Every close carries a one-line comment; cap at 10 per run. Nothing qualifies → skip silently.

# 6. Report
One line: what shipped, what the sweep found, what was filed (and what was dropped at the bar), what was closed, what stale candidates await a call, and what went to a repo doc vs memory.
