# td-fly — shared work contract (reference)

The canonical write-up of the rhythm. **Not imported anywhere** — the `close` and
`mailbox` commands carry their own copy of this protocol; this file is the human-readable
reference. Keep it short. This is the *interface* (how repos rendezvous), not a
per-project rulebook — project structure is yours to decide per repo.

## What gets kept, and where
Work conversationally. No heavy doc scaffold — but keeping a record of the project's
state is **mandatory, not optional**. Sort what's worth keeping by *kind*:
- **Core project knowledge** — the heart-of-the-system facts that constrain the code:
  load-bearing invariants, the gotchas that bite, deploy discipline, key design decisions,
  open bugs. These live **in the repo as a doc**, versioned next to the code (extend an
  existing `docs/` file or `CLAUDE.md`). Capture only the core — *not every finding.* The
  transcripts and git history are the archive; we can always go back. Lean: one home, a
  short curated record, never memory.
- **Memory** is only for *how we work*: preferences, working-style feedback, cross-session
  continuity. **Never put code-governing knowledge in memory** — it's private to one
  machine, unversioned, and recalled by chance. That is data loss waiting to happen.
- Leftover TODOs → GitHub issues, but only the few that clear the filing bar — the two
  gates, the do/don't lists and the 3-per-close ceiling live in the plugin's
  `references/issue-discipline.md`, which `/td-fly:close` loads.

**Which repo doc.** Nearest wins: a fact that only governs one package or module belongs
in that directory's own `CLAUDE.md`, not the root one — Claude reads every `CLAUDE.md`
from the file's directory up, so a root file in a monorepo taxes every session with
context most of them don't need. Machine-local or personal notes (a local port, a
scratch path, an unshared preference) go in `CLAUDE.local.md` — and add that filename to
the repo's `.gitignore`, which is what keeps it personal. It is not ignored by default.

## Rhythm
Two commands carry the rhythm:
- `/td-fly:close` — wrap a session: remember facts → fresh-eyes sweep (docs + memory) → park TODOs to issues → commit → push.
- `/td-fly:mailbox` — cross-repo check: issues filed *into* this repo + issues this repo
  filed *into others*, as one digest.

## Work mode
Default: work in this repo only; commit and push when asked. Don't push or open PRs
unprompted. Prefer acting automatically on small, reversible things rather than asking —
and don't raise the same suggestion every session; mention it once, then let it rest.

## Cross-repo protocol
The one real interface contract — the rest is yours. When a project files an issue into
another repo (or reads ones filed into it):
- **Declare connected repos** in this project's own `CLAUDE.md` under a `## Cross-repo`
  heading — one `owner/name` slug per line. That list *is* the scope of `/td-fly:mailbox`
  outbound. Not listed = not seen, by design; declaring a new one is a one-line edit.
- **Every cross-repo issue body opens with** `**From:** <project-name>@<branch>` — the
  canonical sender marker: who filed it and from which branch. `<branch>` is the one the
  filing repo was on (`git branch --show-current`) — always stamped, `@main` included.
  A legacy marker with no `@` part reads as `main`. An issue with *no* marker at all is
  hand-filed and is never branch-hidden (below).
- **Branch-scoped rendezvous.** `/td-fly:mailbox` filters to the branch you're on — it
  shows only filings whose `@<branch>` matches your current branch. Coordinate by keeping
  branch names aligned across the repos that talk: `main` ↔ `main`, `feature-x` ↔
  `feature-x`. Unmarked (hand-filed) issues are never branch-hidden.
- **Sign every cross-repo comment and closure** with `— <project-name>`. Never address
  GitHub usernames in cross-repo prose.
- `<project-name>` = this repo's short name (the `name` in `owner/name`).
