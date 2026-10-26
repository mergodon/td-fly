---
name: close
description: Checkpoint the session — capture core facts to a repo doc, fresh-eyes sweep, file only what clears the bar, commit, push, tend the backlog. Unattended; starts no new work.
argument-hint: "[note]"
---

Close is a checkpoint. Run steps 1–7 in order, skip silently what does not apply, ask
nothing. Rules are in `${CLAUDE_PLUGIN_ROOT}/contract.md` — the §-numbers below point
there. Read it once if it is not already in context.

**Two guards, before anything:**
- Close starts no new work. Unfinished work → one line in the report (step 7), not a fix.
- Waiting on CI or a deploy? Say so first, with the run URL, then continue.

# 1. Facts
- repo: `gh repo view --json name,owner` → `<owner>/<name>`. Fails → note it, skip 4 and 6.
- branch: `git branch --show-current`. Empty → note `detached`, skip 4 and the push.
- open issues, fetched once for steps 4 and 6:
  `gh issue list --state open --limit 100 --json number,title,body,issueType,createdAt,comments`

# 2. Capture (§1)
Core facts this session surfaced that constrain the code → the nearest repo doc, under
§1's four write rules. Memory is not yours to write. Nothing core → skip.

# 3. Sweep
Spawn ONE subagent with no session context. Give it only:
- `${CLAUDE_SKILL_DIR}/sweep.md` (absolute path, pasted)
- the repo root
- this project's memory dir: `~/.claude/projects/<cwd with every / → ->/memory/`
Ask for a short HIGH/MED/LOW list. Fix the trivial and reversible inline (dead path,
stale version, duplicate, misplaced memory fact). Bigger → report it. Sweep findings
never become issues. Clean → one line.

# 4. File (§2, `${CLAUDE_PLUGIN_ROOT}/references/issue-discipline.md` — read before filing)
Both gates, source test, ceiling 3, backlog cap 20. Search the fetched list for a
duplicate and cite the search in the body. Then
`gh issue create --type <Bug|Task> -t "<title>" -b "**From:** <name>@<branch>\n\n<body>\n\n— <name>"`.
File or drop; never ask.

# 5. Commit, push
Steps 2–3 leave edits by design. Conventional message. `git push -u origin HEAD`.
Rejected → show the error, stop.

# 6. Tend the backlog (issue-discipline, "Tending")
After the push, so this session is in `git log`. Two passes, both unattended:
- **Type** every untyped open issue, Bug if broken else Task:
  `gh issue edit <N> --type <Bug|Task>`. Never change a set type. First error → skip
  the pass. Cap 15.
- **Close** on positive evidence only. Resolved: anchored grep
  `git log -E --grep='(^|[^/A-Za-z0-9])#<N>([^0-9]|$)' --oneline`, read the hit, then
  `gh issue close <N> --reason completed --comment "Done in <sha> — <line>. — <name>"`.
  Obsolete: premise verified dead (`test -e`, read the doc) →
  `--reason "not planned"`. Never on age. Cap 10.
Stale is mailbox's question, not close's.

# 7. Report — one line, then one more
What shipped · sweep found · filed / dropped at the bar · typed / closed · unfinished.
Then: `inbound from other repos: <N> open, <M> unanswered` — count fetched issues whose
body has `**From:**` and `comments` is 0. Done.
