---
name: close
description: Close a work session — capture the core into a repo doc, fresh-eyes sweep, file only what clears the bar, commit, push, tend the backlog. Unattended, no questions.
argument-hint: [note]
allowed-tools: Bash(git status *), Bash(git diff *), Bash(git log *), Bash(git branch *), Bash(git add *), Bash(git commit *), Bash(git push *), Bash(gh repo view *), Bash(gh issue *), Bash(gh run *), Agent
---

Checkpoint, not ceremony. Run the steps in order; skip silently what does not apply. **Ask nothing.** Start no new work: unfinished work is one line in the report. Waiting on CI or a deploy → say so first, with the run URL, before anything else.

# 0. Facts
`gh repo view --json name,owner` → `<name>`, `<owner>/<name>`. `git branch --show-current` → `<branch>`.
No remote or no `gh` → skip 3, 5, 6. Detached HEAD → skip 4's push and 3.

# 1. Capture — repo doc only
Core project knowledge that constrains the code and surfaced this session: an invariant, a gotcha that bit, a deploy step, a decision. Write it to the nearest repo doc (`docs/`, or the `CLAUDE.md` of the directory it governs). Rules:
- **Replace, don't append.** The new rule replaces the line it changes. Date, quote and the old rule go in the commit message.
- **Point at the executable truth.** If `--help`, a config or a script header carries it, the doc gets one pointer line.
- **No war stories.** The rule, not the incident.
- Nothing core → skip. Transcripts and git are the archive. Memory is not yours: auto memory writes itself.

# 2. Sweep — fresh eyes
Spawn ONE subagent with no knowledge of this session. Its prompt: the absolute path `${CLAUDE_SKILL_DIR}/sweep.md`, this repo's root, and this project's memory dir (`~/.claude/projects/<cwd with every "/" → "-">/memory/`). Ask for the short list the file describes.
Fix the trivial inline: dead path, stale version, duplicate, a code-governing fact in memory moved to the repo doc. Bigger → one line in the report. **A sweep finding is never an issue.**

# 3. File — the bar is high
Fetch once, reused by 5 and 6:
`gh issue list --state open --limit 100 --json number,title,body,issueType,comments,createdAt,parent`
File only what passes **both** gates: a **current, named victim** (a user hitting an error, a broken deploy, the owner's direct ask — never "a future maintainer") and **evidence a reader can re-run** (a trace, a status code, a failing command, a quoted ask). Found by looking at the repo instead of doing the work → not filed, however worded.
- Never: speculative improvements, meta-work about the process, anything a doc already says, near-duplicates (comment on the existing one), sweep findings.
- Always: bugs with a reproduction, blocked work naming the obstacle, security / data-loss / money risk with the concrete mechanism, a decision only the owner can make.
- **Ceiling: 3 non-urgent per close**, most closes zero; more → one issue naming the theme with a checklist. Broken things are exempt. **Backlog cap:** at 20+ open agent-filed issues (`**From:**` in body) file only Bugs and security.
- Search the fetched list for a duplicate and cite the search in the body (`searched: <terms>`).
- `gh issue create --type <Bug|Task> -t "<title>" -b "<body>"`, body opens `**From:** <name>@<branch>`. Never Idea or Epic. Cross-repo → load `td-fly:protocol` first.

# 4. Commit & push
Steps 1–2 leave edits by design: `git add -A && git commit -m "<type>: <what>"` without asking (conventional prefix). `git push -u origin HEAD`. Rejected → show the error, stop.

# 5. Tend the backlog — evidence, never age
On the list from 3, after the commit so `git log` sees this session.
- **Type the untyped** (cap 15): `gh issue edit <N> --type <Bug|Task>` — Bug if broken, Task otherwise. Never change a set type. First error (no Issue Types here) → skip the pass.
- **Close resolved** (cap 10): candidates from the anchored grep `git log -E --grep='(^|[^/A-Za-z0-9])#<N>([^0-9]|$)' --oneline`; **read the commit** before citing it. `gh issue close <N> --reason completed --comment "Done in <sha> — <one line>. — <name>"`.
- **Close obsolete**: premise verified dead (`test -e` the path, read the doc, confirm the superseding decision). `--reason "not planned"`, signed comment. A guess is not obsolescence.
- Leave alone: anything with a discussion, anything hand-filed unless a commit resolves it, Epics, any issue another open issue references. Stale is `/td-fly:mailbox`'s question, not yours.

# 6. Report — one block, then stop
What shipped · sweep result · filed / dropped at the bar · typed / closed · unfinished work, if any.
Last line, from the list in 3: `inbound from other repos: <N> open, <M> unanswered` — count issues whose `**From:**` names another repo; unanswered = no comment. If `$ARGUMENTS` carried a note (e.g. "restarting this box"), end with `safe to stop.` once the push is confirmed.
