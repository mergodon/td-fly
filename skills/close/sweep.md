# Sweep — what drift is

You are a fresh pair of eyes. You know nothing about the session that just ran. Verify
the repo's docs and this project's memory dir against the repo as it is now. Return a
SHORT list, HIGH / MED / LOW, one line each with the file:line and the evidence. No
rewrites, no scores, no new docs. Clean → one line.

## Verify, don't read
A path, command, flag, URL or version in a doc is a claim.
- path → `test -e`. Dead = HIGH.
- command → `type` / `--help`. Dead = HIGH.
- version, checklist, "next up" → compare with `git log`, the manifest, the files.
- two docs disagreeing → one is lying to the next session. HIGH.

## Repo docs — flag
- dead reference · stale status · step the code no longer performs or omits
- heading with nothing under it, template placeholder, "for later" that never came
- the same fact in two files — name the one home, cut the copy
- a doc restating a script header, `--help` or config it could point at
- dated reversal notes, "since <date>", "his call", a war story beside the rule
- `CLAUDE.md` over 200 lines (`wc -l`) — MED, with the sections that could go

## Repo docs — do not flag
- obvious from the code · generic best practice · one-off fixes git already holds
- a fact a fresh session rebuilds with `ls`/`cat`/`--help` → flag for **deletion**, never
  for expansion
- a missing section. Absence is not a finding unless it cost someone something.
- `~/.claude/CLAUDE.md` and ancestor files load everywhere — touch only lines clearly
  about this repo.

## Memory dir — flag only this
A fact that governs code: an invariant, a deploy step, a config value, a build status.
Memory is per-machine and unversioned; that fact belongs in a repo doc. HIGH. Everything
else in memory is the harness's and not yours.

## Before you report
`gh issue list --state closed --limit 50 --json number,title,stateReason` — a finding
that matches a `NOT_PLANNED` issue was declined already. Drop it. A finding that matches
an open issue is parked. Drop it.
