---
description: Wrap a work session — capture knowledge, sweep for drift, file only what clears the bar, close what's provably done, commit, push. The lean close ceremony.
---

You are closing a work session. Keep it lean — this is a checkpoint, not a ceremony. Do these in order; skip silently what doesn't apply. **One question at most, at the very end** (step 5c). Everything else runs unattended.

# 0. Setup — three facts, resolved once
- **Plugin root** = `${CLAUDE_PLUGIN_ROOT}`. If that came through unsubstituted, resolve it from `~/.claude/plugins/installed_plugins.json` (the `installPath` under `td-fly@td-fly`) — it holds the same `references/`.
- **Repo** = `gh repo view --json name,owner`. Failure (no remote, `gh` not authenticated) → note it, and skip steps 3 and 5 entirely; the rest still runs.
- **Branch** = `git branch --show-current`. Empty (detached HEAD) → note `branch: detached`, skip steps 3 and 4's push; never file with a malformed marker.

# 1. Capture what's worth keeping
Sort by *kind* — two homes, and the split matters:
- **Core project knowledge** surfaced this session — only the heart-of-the-system facts that constrain the code: load-bearing invariants, biting gotchas, deploy discipline, key decisions, open bugs → write it to a **repo doc** next to the code (extend an existing `docs/` file or `CLAUDE.md`; don't spawn a scaffold). Capture only the core, not every finding — the transcripts and git are the archive. **Never memory.**
- **Working-style facts** — user preferences, how-we-work feedback, cross-session context → the built-in memory store; update existing files, don't duplicate.

Nothing new of either kind → skip.

# 2. Sweep — docs + memory (fresh eyes)
Spawn ONE subagent with **no prior context** — tell it nothing about this session — and hand it `<plugin root>/references/sweep-criteria.md`. That file defines what to verify, what counts as drift, and what NOT to flag. Paste the resolved absolute path into its prompt, along with this project's memory dir (``~/.claude/projects/<absolute cwd with every `/` replaced by `-`>/memory/``) and its `MEMORY.md`. Ask for a SHORT prioritized list (HIGH/MED/LOW) — no scores, no grades, no rewritten docs.

Fix the trivial and reversible inline yourself — prune a dead memory file *and* its index line, correct a stale version, move drifted knowledge into the repo doc. **Sweep findings never become issues** — the source test in step 3's reference bars them. Clean bill → one line, move on.

# 3. File leftovers — the bar is HIGH
**Fetch the open issues once, here** — steps 3 and 5 both read this list:
`gh issue list --state open --limit 100 --json number,title,body,id,parent,issueType,comments,createdAt`

**Read `<plugin root>/references/issue-discipline.md` before filing anything.** It sets both gates, the source test, the do/don't lists, the severity-aware ceiling and the per-repo backlog cap (count the fetched issues whose body carries `**From:**`).

Consolidate related candidates first. Search the fetched list for a duplicate and cite the search in the body. Type it **Bug or Task only** — never `Idea`, never `Epic`; those are the owner's to create, and only when asked:
`gh issue create --type <Bug|Task> -t "<title>" -b "<body>"` — body opens `**From:** <name>@<branch>`. No confirm round — file, or drop it silently. Nothing cleared the bar → say so in step 6.

# 4. Commit & push
- Steps 1–2 leave edits by design, so **commit without asking** — a commit is local and reversible. Conventional message (`feat:` / `fix:` / `chore:` / `docs:`).
- `git push -u origin HEAD`. No PRs. Rejected → surface the error and stop.

# 5. Tend the backlog
Runs *after* the commit so this session's work is visible to `git log`. Rules live in `<plugin root>/references/issue-discipline.md` ("Tending the backlog"). Three passes on the list from step 3 — the first two run unattended, only the third asks.

**5a — type what's untyped (automatic).** Every open issue with no `issueType` gets one — **Bug** if something is broken, **Task** otherwise: `gh issue edit <N> --type <Bug|Task>`. **Never change a type that is already set** — that was someone's decision; untyped is not a decision. If the first edit errors (user-owned repo, org without Issue Types), skip the pass silently. Cap 15.

**5b — close what's provably done (automatic).** Positive evidence only, never age:
- **Resolved** — a commit implements it. Find candidates with an anchored grep — `git log -E --grep='(^|[^/A-Za-z0-9])#<N>([^0-9]|$)' --oneline` (an unanchored `#1` matches `#10` and `other-repo#1`) — then **read the matched commit** before citing it. Close `--reason completed`, cite the sha.
- **Obsolete** — the premise is dead and you verified it (`test -e` the path, read the doc, confirm the superseding decision). Close `--reason "not planned"`.
Cap 10, every close carries a one-line comment signed `— <name>`.

**5c — stale candidates (the one question).** The reference lists the conditions — all of them, on the issue's own text, using `createdAt`, `comments`, `parent`, the anchored grep, and a scan of the other fetched bodies for `#<N>`. List survivors in the report as a single batched question — numbered, one line each, recommended action per item — and take the answer in one reply. Never close on age alone. Nothing stale → don't ask, just say the backlog is clean.

# 6. Report
One line: what shipped, what the sweep found, what was filed (and what was dropped at the bar), what was typed and closed, and what went to a repo doc vs memory. If step 5c found stale candidates, they follow as the single numbered question — otherwise there is no question and the close is done.
