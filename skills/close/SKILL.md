---
name: close
description: Close a work session — capture the core, sweep for drift, file what clears the bar, commit, push, tend the backlog. A checkpoint, not a ceremony.
---

Close the session. Run every step unattended. Skip what does not apply, silently. Ask nothing.

**Scope.** Close starts no new work. Unfinished work gets one line in the report. If a CI run or deploy is still going, say so first, with its URL, then continue.

# 1. Facts
- `repo` = `gh repo view --json name,owner`. Fails → skip steps 3 and 5.
- `branch` = `git branch --show-current`. Empty → skip 3 and the push.
- Fetch once, reuse in 3, 5, 6: `gh issue list --state open --limit 100 --json number,title,body,issueType,createdAt,comments`.

# 2. Capture
Core project knowledge only — invariants, biting gotchas, deploy discipline, decisions that constrain code. It goes in a repo doc next to the code (`docs/` or `CLAUDE.md`). Never memory: the harness owns memory.
- Replace, do not append. The new rule replaces the line it changes; the old rule and the date go in the commit message.
- Point at the executable truth. A script header, `--help` or a config file carries the fact → the doc gets a pointer, not a copy.
- No war stories. The rule goes in the doc; the incident stays in git.
Nothing core → skip.

# 3. Sweep
Spawn one subagent with no session context. Tell it nothing about this session. Hand it this list and the project memory dir (`~/.claude/projects/<cwd with / → ->/memory/`). Ask for a short HIGH/MED/LOW list, no rewrites.

Flag:
- A path, command, flag, URL or version a doc names that no longer resolves (`test -e`, `type`, `--help`, `git log`). HIGH.
- Two docs that disagree. HIGH.
- A fact that governs code sitting in memory. HIGH — move it to the repo doc.
- A `CLAUDE.md` over 200 lines. MED.
- Dead scaffold, stale checklist, a fact rebuildable with two tool calls. LOW — cut, never expand.
Do not flag: what the code already says, generic advice, one-off fixes, a missing section. Skip anything an open or `NOT_PLANNED` issue already covers (`gh issue list --state closed --limit 50 --json number,title,stateReason`).

Fix the trivial inline. Bigger → one line in the report. A sweep finding is never an issue.

# 4. File
Both gates or nothing: a current, named victim (a user, a broken deploy, a wrong number, mate asking) AND evidence a reader can re-run (trace, status, command, count, quote). Found by looking at the repo instead of doing the work → drop it, however it is worded.
- File: bugs with a reproduction, blocked work with a named obstacle, security/data/money risk with the mechanism named, a fork only mate can decide.
- Never: speculative improvements, process meta-work, anything a doc already says, sweep findings, near-duplicates (comment instead).
- Search the fetched list for a duplicate; cite the search in the body.
- Type `Bug` or `Task` only. Never `Idea`, never `Epic`.
- Ceiling: 3 deferrable items per close; over that, one issue with a checklist. Broken things are not counted. Backlog of 20+ agent-filed (`**From:**` in body) open issues → only Bugs and risks.
- `gh issue create --type <Bug|Task> -t "<title>" -b "<body>"`. Body opens `**From:** <name>@<branch>`. Cross-repo: `-R <owner/repo>`, sign `— <name>`.

# 5. Commit and push
Commit without asking, conventional message. `git push -u origin HEAD`. Rejected → show the error, stop.

# 6. Tend the backlog
On the fetched list, after the commit. Evidence only, never age.
- Untyped → `gh issue edit <N> --type <Bug|Task>`. Never change a set type. Cap 15. First error → skip the pass.
- Resolved → a commit implements it. Find with `git log -E --grep='(^|[^/A-Za-z0-9])#<N>([^0-9]|$)' --oneline`, read the commit, then `gh issue close <N> --reason completed --comment "Done in <sha>. — <name>"`.
- Obsolete → the premise is verified dead (`test -e`, read the doc). `--reason "not planned"`, one-line signed comment.
- Cap 10 closes. Stale is not yours — mailbox proposes it to mate.
- An inbound issue a peer session is working live (see mailbox) → leave it; the record closes on commit evidence like any other.

# 7. Report
One paragraph: shipped, sweep result, filed and dropped, typed and closed, what went to a repo doc. Last line, from the fetched list: `inbound from other repos: N open, M unanswered` (issues with a `**From:**` marker from another repo; unanswered = no comment). No question.
