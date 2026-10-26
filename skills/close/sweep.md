# Sweep — what to verify, what to flag, what to leave

You have no context of the session that just ended. Good: that is the point. Return a SHORT
prioritised list (HIGH / MED / LOW) or one line: `clean`. No rewritten docs, no scores.

## 1. Verify claims before reading for sense
Every path, command, flag, URL, version and status line in a doc is a claim.
- Path → `test -e`. Dead = HIGH.
- Command or script → `type` / `--help`, and it lives where the doc says. Dead = HIGH.
- Version, checklist box, "next up" → compare with `git log`, the manifest, the files.
- Two docs disagreeing (README vs CLAUDE.md vs a skill vs the code) = HIGH; name both.

## 2. Repo docs — flag
- A fact stated twice (two files, or a doc and the script header / `--help` it restates). Pick one home, cut the copy. The executable truth wins; the doc keeps a pointer.
- A dated reversal ("since <date>", "reverses", "his call") standing beside the rule it replaced. The current rule stays, alone.
- A war story: the incident instead of the rule. Git holds the incident.
- Leftover scaffold: an empty heading, a placeholder, a "for later" section.
- Anything a fresh session could rebuild with `ls`, `cat`, `--help`: dead weight every session pays to load. Flag for deletion, never for expansion.
- **A `CLAUDE.md` over 200 lines** (`wc -l`) = MED, with the three longest sections named.

## 3. Repo docs — do NOT flag
- Obvious from the code. Generic best practice. One-off fixes. A missing section — absence is not a finding unless it cost someone something.
- `~/.claude/CLAUDE.md` and ancestor `CLAUDE.local.md` load in every project: touch them only for content clearly specific to this repo.

## 4. Memory dir — one check only
Auto memory belongs to the harness. Flag only a fact that **governs code**: an invariant, a deploy step, a config value, a port, a schema rule. Memory is per machine and unversioned; that fact belongs in a repo doc. HIGH, with the file name. Preferences, feedback and working notes are not yours to judge.

## 5. Already decided
Before flagging, read `gh issue list --state closed --limit 50 --json number,title,stateReason` and drop anything matching a `NOT_PLANNED` item, and anything an open issue already carries.
