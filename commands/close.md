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

# 5. Tend the backlog
Runs *after* the commit so this session's work is visible to `git log --grep`. Rules live in `${CLAUDE_PLUGIN_ROOT}/references/issue-discipline.md` ("Closing").

Fetch once: `gh issue list --state open --limit 100 --json number,title,body,issueType,comments,createdAt`. Three passes — the first two run unattended, only the third asks.

**5a — type what's untyped (automatic).** Every open issue with no type gets one: **Bug** if something is broken, **Task** otherwise. **Never change a type that is already set** — that was someone's decision. Untyped is not a decision: 31% of open issues carry no type, and most owner-filed ones simply predate the feature. Typical load is 2 per repo (p90 6), so this is seconds; cap at 15.
Resolve the org's type IDs once — `gh api graphql -f query='query($o:String!){organization(login:$o){issueTypes(first:20){nodes{id name}}}}' -F o=<owner>` — then per issue, get its node id and `gh api graphql -f query='mutation($id:ID!,$t:ID!){updateIssue(input:{id:$id,issueTypeId:$t}){issue{number issueType{name}}}}' -F id=<node-id> -F t=<type-id>`.

**5b — close what's provably done (automatic).** Positive evidence only: a commit implementing it (cite the sha), or a premise you verified is dead. Age is never evidence. Cap 10, every close carries a one-line comment.

**5c — stale candidates (the one HIL).** List them in the report as a single batched question — number them, one line each, recommended action per item, and take the answer in one reply. Never close on age alone; the backtest that justified doing so was wrong 6 times in 10. Nothing stale → don't ask, just say the backlog is clean.

# 6. Report
One line: what shipped, what the sweep found, what was filed (and what was dropped at the bar), what was typed and closed, and what went to a repo doc vs memory. If step 5c found stale candidates, they follow as the single numbered question — otherwise there is no question and the close is done.
