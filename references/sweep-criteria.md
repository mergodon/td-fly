# Sweep criteria — what "drift" means

Loaded by `/td-fly:close` step 2 and handed to the fresh-eyes subagent. It is the
*definition* of what to flag, so the sweep returns the same shape of answer every run
instead of whatever the subagent improvises.

Output a SHORT prioritised list (HIGH / MED / LOW). Not new documentation, not a full
audit, no scores or grades. A clean bill is one line.

## Verify, don't skim

A path, command, flag, URL or version in a doc is a **claim**. Check the claims before
reading for tone — a stale identifier is the highest-value thing this sweep finds, and
the cheapest to confirm.

- Every file/dir path a doc mentions → `test -e`. Dead path = HIGH.
- Every command → does it still exist (`type`, `--help`)? Does the script it names still
  live where the doc says? Dead command = HIGH.
- Every version/status claim ("v0.9.0", "feature-complete", a checklist box) → compare
  with `git log`, the manifest, the actual files.
- Cross-file contradictions: README vs CLAUDE.md vs command text vs the code. Two docs
  disagreeing = one of them is lying to the next session.

## Repo docs — flag these

- **Dead references** — a path, file, command, flag or URL that no longer resolves.
- **Stale status** — version, checklist, "next up", roadmap that git contradicts.
- **Command text that doesn't match behaviour** — the doc describes a step the command
  no longer performs, or omits one it does.
- **Leftover scaffold** — a heading with nothing under it, a template placeholder, a
  section kept "for later" that never arrived.
- **Duplication across files** — the same fact stated in two docs. It will drift; pick
  the one home and cut the copy.

## Repo docs — do NOT flag

Adapted from Anthropic's `claude-md-management` plugin. These are the four ways a doc
sweep turns into noise:

- **Obvious from the code.** "The `UserService` class handles user operations." The name
  already said that.
- **Generic best practice.** "Write tests for new features." True everywhere, so it
  informs nothing here.
- **One-off fixes.** "Fixed the login bug in abc123." Won't recur; git already has it.
- **Verbose explanation** where a line would do. If a doc explains what JWT *is*, the
  finding is "cut it", not "expand it".

- **Reconstructible facts.** Claude Code's own built-in guidance puts it best: a line of a
  checked-in `CLAUDE.md` that a fresh session could rebuild with a few tool calls (`ls`,
  `cat`, reading the manifest, `--help`) is dead weight every session pays to load. Flag
  it for **deletion**, never for expansion.

Corollary: **absence of a section is not a finding.** A missing "Architecture" heading in
a 7-file repo is correct, not a gap. Only flag a missing thing if its absence actually
cost someone something.

Scope note: `~/.claude/CLAUDE.md` and ancestor-directory `CLAUDE.local.md` files load in
EVERY project, not just this one. Only propose cutting from them when the content is
clearly specific to this repo.

## Memory store — flag these

Pass the subagent this project's memory dir and its `MEMORY.md` index.

- **Code-governing knowledge that drifted into memory** — build status, invariants,
  design decisions, deploy steps. Memory is per-machine and unversioned; this is data
  loss waiting to happen. Move it to a repo doc. Always HIGH.
- **Contradicted by current code or git.**
- **Duplicates** — two files carrying the same fact.
- **Index out of sync** — a `MEMORY.md` line whose file is gone, or a file with no line.
- **Relative dates** — "last week", "recently". Memory outlives the sentence; resolve to
  an absolute date or drop it.

## The third case

`contract.md` gives the two-homes test (constrains the code → repo doc; about how we work
→ memory). The case it omits: **neither → it does not get written down at all.** That is
the common one during a sweep.

## Acting on the result

Fix the trivial and reversible inline: prune a dead memory file **and** its index line,
correct a stale version, move drifted knowledge into the repo doc, delete a dead path.
**A sweep finding never becomes an issue** — the source test in
`references/issue-discipline.md` bars it. Bigger than inline → report it and stop.

Never re-flag something already parked (an open issue) or already declined. A
fresh-context subagent cannot know what was declined, so check the record before
flagging: `gh issue list --state closed --limit 50 --json
number,title,stateReason` and keep the `NOT_PLANNED` ones (the `--search
'reason:not-planned'` form is index-backed and lags a few seconds after a close, so it can
miss a just-retired item). If a finding matches one, it was already declined — drop it.
