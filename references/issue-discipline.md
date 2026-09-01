# Issue discipline — what earns an issue, and what ends one

Loaded by `/td-fly:close` steps 3 and 5, and canonical for `/td-fly:mailbox`'s close
actions. Filing and closing are one lifecycle: an issue nobody ever closes is the same
noise as one nobody should have filed.

## Why this exists

Across the 162 `mergodon` repos on 2026-09-01, all 1534 issues ever filed:

| | |
|---|---|
| Filed by the close ceremony | **1278 of 1534 — 83%** |
| Filed by the owner | 256 |
| August: agent vs owner | **541 vs 30 — 18:1, at 17.5/day** |
| Worst single day into one repo | **25** |
| Same-day batches of 3+ into one repo | **168** |
| Still open, agent-filed | 375, across 60 repos |
| Never closed, every cohort | ~30% |
| Filed with no Issue Type set | 39% |

A hand-classification of 110 of them: 27% load-bearing, 38% real-but-deferrable, 16%
speculative, 18% noise. **A third should never have been filed** — but two thirds were
legitimate, so the goal is to cut the bottom third, not to file less of everything.

Boundary: the `**From:**` marker is the only way to separate agent from human filings and
it starts 2026-05-19 (in `td-flow`, this plugin's predecessor), so every agent-side figure
covers a ~3.5-month window. Two marker forms exist — `**From:** name@branch` and an older
`**From:** name` — and both are counted; a branch-only count returns 1008 instead of 1278.

## The bar — both gates, or don't file

**Gate 1 — name who is hurt, right now.**
A user hitting an error, a broken deploy, a wrong number in production, the owner asking
directly. The victim must be **current and identifiable**. "A future maintainer", "the
next dev", "whoever reads this" is an invented victim and fails — if you had to imagine
them, there isn't one.

**Gate 2 — point at evidence a reader could re-run.**
A stack trace, an HTTP status, a failing command, a count measured on prod, a quoted ask.
Real openers from the corpus: *"Measured on prod (2026-08-24, --dry-run)… 1,700 leaks
withdrawn"*; *"Admin 'Send password reset' 500s — Route [password.reset] not defined"*.
The tell for the other kind is prose about the repo itself, with no victim and nothing to
re-run.

**Source test, and it outranks wording.** If the finding came from *looking at the repo*
rather than from *doing the work*, it does not get filed — however it is phrased. Most
noise issues in the corpus literally open "Found by a fresh-eyes doc sweep", but rewording
that to "Verified:" changes nothing. Step 2's sweep output is fixed inline or dropped.

**Before filing, search for a duplicate and say you did.** Cite the search in the body
(`searched: repo:<slug> is:issue "<terms>"`). An uncited duplicate check is not a check —
the corpus has clusters whose own comments read *"Duplicate of #7"*, *"Supersedes #5,
which covered the same drift from an earlier close sweep."*

## File

- **Bugs with a reproduction** — a command that fails, a wrong output, a broken deploy.
- **Blocked work** — started, then stopped on a named obstacle. Not "waiting on someone
  to get round to it"; that is a reminder, not an issue.
- **Security, data-loss and money risk** — the one Gate 2 exception, and it is narrow:
  name the **concrete mechanism and the asset at risk**. "Could be a security problem" is
  not a mechanism. This exception is the easiest one to abuse — if invoking it feels
  convenient, it does not apply.
- **A decision only the owner can make** — a real fork, not a preference.

## Do not file

- **Speculative improvements** — "we could someday generalise X".
- **Meta-work about the process** — "consider documenting the sweep", "add tests for the
  helper". Self-generated work that exists because the agent thought of it.
- **Anything already written down.** A repo doc now carrying the fact makes the issue a
  duplicate of the doc.
- **Sweep findings** — see the source test above.
- **Near-duplicates of an open issue** — comment on the existing one.

## Ceiling — severity-aware

**At most 3 non-urgent issues per close**, and most closes should file zero. Over that,
file ONE issue naming the theme with the rest as a checklist.

**The ceiling does not apply to things that are actually broken.** Bugs, security defects
and anything blocking a release are filed individually however many there are — burying
five independent security bugs in one checklist is worse than filing five. The corpus's
worst day (25 issues into `anzscofinder-app-web`) was a launch audit spanning five
separate security defects, legal, billing and one urgent blocker; collapsing that would
have hidden the urgent item. The same day's other extreme — 13 one-line feature ideas into
a test repo — is exactly what the ceiling is for.

So: count only the deferrable items against the ceiling. If you are collapsing, say so in
the report — *"5 candidates, filed 2 bugs individually, folded 3 into a themed issue"*.

**Backlog cap — the ceiling is per-session, which is gameable across sessions.** Before
filing, count this repo's open agent-filed issues (`**From:**` in body). **At 20 or more,
file nothing that is not a Bug or a security risk until the backlog is back under 20.**
Re-theming the same work across successive sessions defeats the per-close ceiling; this
does not.

## Type it, and only ever Bug or Task

**Never file an `Idea`. Never file an `Epic`.** Those are the owner's to create — file one
only when the owner asks for it in so many words. Measured: of 151 Ideas, **116 (77%) were
agent-filed**, and Idea has the worst close rate of any type (55% vs 67% for Task) — it is
the bucket speculative work rots in. Epics are 15 issues in 5 of 75 repos; where the owner
uses them they are real planning surfaces with sub-issues, which is precisely why the agent
should not manufacture more.

That leaves two types, and the choice is easy: **Bug** if something is broken, **Task**
otherwise. If it is neither, re-read the gates — it probably should not be filed.

Set the type in the same `createIssue` mutation. 39% of agent filings arrive untyped; among
repos with 5+ agent-filed issues, 32 are "mixed" — the type demonstrably works there, yet
3–83% of filings skip it. Control: zero such repos are all-untyped, so it is always
available. An untyped issue is invisible to `/td-fly:mailbox`'s recommendations.

---

# Tending the backlog

## Typing — automatic, and safe

Set a type on every open issue that lacks one; **never change a type already set.** That
distinction is the whole safety argument: an untyped issue is an absence of a decision, not
a decision. 31% of open issues (129 of 420, across 42 repos) carry no type, and of the 34
owner-filed ones, 19 predate Issue Types existing at all — median age 236 days. Per-repo
load is trivial: median 2, p90 6, max 11.

Bug if something is broken, Task otherwise — the same two types the agent is allowed to
file. Resolve the org's type IDs once (they are org-level and reusable across every repo),
then `updateIssue`. This is reversible and improves every later digest, so it does not ask.

## Close these, without asking

Both are reversible (`gh issue reopen`) and both require **positive evidence**, never age.

- **Resolved** — `git log --grep="#<N>" --oneline` shows a commit implementing it. Cite
  the sha: `gh issue close <N> --reason completed --comment "Done in <sha> — <one line>. — <project-name>"`.
- **Obsolete** — the premise no longer holds, **verified**: `test -e` the path it names,
  read the doc it cites, confirm the superseding decision. A guess is not obsolescence.
  `gh issue close <N> --reason "not planned" --comment "<why it no longer applies>. — <project-name>"`.

Always `--reason "not planned"` for anything retired rather than shipped. Closing a stale
item as `completed` hides it from `--search 'reason:not-planned'`, which is how the sweep in step 2
finds what was already declined — get this wrong and it gets re-flagged forever.

## Stale — propose, never auto-close

Age alone is not evidence, and an earlier version of this file got that wrong. A backtest
of the "Idea, 60+ days, untouched → close" rule against 10 real issues judged **6 of 10
closes wrong**, because:

- **The type field is unreliable as a trigger** — 25% of open agent-filed issues are
  untyped and real pending work had been filed as "Idea". Two issues in the sample were
  active scope migrated from an older system, mistyped. Staleness is judged on the issue's
  own text and links, never on its type.
- **It ignored structure** — it would have closed an open child of an open Epic (which the
  rules elsewhere protect), and an issue another *open* issue depends on ("Pairs with #37").
- **The safety argument was survivorship bias.** "Only 6 of 903 closed issues lived past
  60 days (0.7%)" is doubly misleading: only 325 of those 903 were created early enough to
  *possibly* show a 60-day life, making the real rate **1.8%** — and the statistic only
  ever measures issues that already resolved. It cannot say whether an open issue would
  have resolved on day 70, because the rule being justified would prevent that from ever
  being observed. The oldest agent-filed issue is 105 days old, so no threshold near 90
  days has completed a single cycle in this corpus.

So: **list stale candidates in the report and let the owner decide in one reply.** A
candidate needs all of: agent-filed, 60+ days old, no comments, no referencing commits, not
referenced by another open issue, not a child of an open Epic, and speculative on its own
text. An owner-filed Idea is never a candidate — they meant it.

## Leave alone

- Anything with an open discussion.
- Anything human-filed — no `**From:**` marker — unless provably resolved by a commit.
  The agent's backlog is the agent's to tidy; the owner's is not.
- **Epics**, and any issue an open issue references.

## Never silent, and capped

Every close carries a one-line comment saying why. **Cap at 10 closes per run** — if more
qualify, close the 10 oldest and report how many remain.
