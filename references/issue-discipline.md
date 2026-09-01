# Issue discipline — what earns an issue, and what ends one

Loaded by `/td-fly:close` steps 3 and 4. Filing and closing are one lifecycle: an issue
nobody ever closes is the same noise as one nobody should have filed.

## Filing

The default is **don't file**. An issue is a claim on someone's attention
forever; the transcript and git history are already the archive.

## Why this exists (measured, not felt)

Across the 162 `mergodon` repos on 2026-09-01, all 1534 issues ever filed:

| | |
|---|---|
| Filed by the close ceremony | **1278 of 1534 — 83%** |
| Filed by the owner | 256 |
| Per month | 323 (Jun) → 314 (Jul) → **541 (Aug)** |
| August: agent vs owner | **541 vs 30 — 95%, at 17.5/day** |
| Worst single day into one repo | **25 issues** |
| Same-day batches of 3+ into one repo | **168** |
| Still open, agent-filed | 375, across 60 repos |
| Never closed, every cohort | ~30% (Jun 33%, Jul 24%, Aug 34%) |
| Filed with no Issue Type set | 39% |

The ceremony out-filed the owner 18:1 in August and a third of it is never touched again.
That is the problem this file fixes.

Boundary: the `**From:**` marker is the only way to tell agent filings from human ones,
and it only appears from 2026-05-21 — so these figures cover a ~3-month window, not all
time. Two marker forms exist (`**From:** name@branch`, and an older `**From:** name`
without the branch); both are counted here, which is why a branch-only count returns the
smaller 1008.

## What the backtest found

110 agent-filed issues, stratified across 30 repos, classified by hand:

| | | |
|---|---|---|
| **A** load-bearing — real bug, security, data-loss, blocking gap | 30 | 27% |
| **B** real but deferrable | 42 | 38% |
| **C** speculative idea | 18 | 16% |
| **D** noise | 20 | 18% |

**C + D = 35% should never have been filed.** A + B = 65% was legitimate — so the problem
is not that the filings are worthless, it is that a third are, and the volume buries the
two-thirds that matter.

**The single measured discriminator**, and the one test that matters:

> An A/B issue cites **reproducible, measured evidence of a currently-wrong live state,
> and names who is hurt by it** — a stack trace, an HTTP status, a repro command, a
> count measured on prod, a stakeholder's verbatim ask.
> A C/D issue's only artifact is **prose about the repo itself** — no victim, no
> reproduction.

Real A/B openers from the corpus: *"Measured on prod (2026-08-24, --dry-run)… 1,700
leaks withdrawn"*; an exact `IndexError` traceback; *"Admin 'Send password reset' 500s —
Route [password.reset] not defined"*.

🚩 **Most D issues literally begin "Found by a fresh-eyes doc sweep."** That phrase is a
reliable marker of an issue that should not exist. `/td-fly:close` step 2 was feeding
step 3 — the sweep generated findings, and the findings became tickets. It stops here:
**sweep output is fixed inline or dropped. Drift is never a ticket.**

## The bar — file only if it clears BOTH gates

**Gate 1 — is something actually wrong right now, and who is hurt?**
Name the victim: a user hitting an error, a broken deploy, a wrong number in production,
a person who asked. "The docs are inconsistent" has no victim. If you cannot name who is
worse off, do not file.

**Gate 2 — can you point at the evidence?**
A stack trace, an HTTP status, a failing command, a measured count, a quoted request.
Something a reader could re-run or re-read. "Could be improved", "consider adding",
"might be worth" are prose, not evidence, and never clear this gate.

**Before filing, check for a duplicate.** The backtest found 5 self-admitted duplicate
clusters in a 110-issue sample — issues whose own comments say *"Duplicate of #7"*,
*"Supersedes #5, which covered the same drift from an earlier close sweep."* Search open
issues first; comment on the existing one instead of opening a twin.

## File

- **Bugs with a reproduction** — a command that fails, a wrong output, a broken deploy.
- **Blocked work** — something genuinely started and stopped on a named obstacle.
- **Security, data-loss and money risks** — always, even speculative. The one exception
  to Gate 2: here a credible mechanism counts as evidence.
- **A decision that needs the owner** — a real fork in the road, not a preference.

## Do not file

- **Speculative improvements.** "We could someday generalise X." No trigger, no filing.
- **Meta-work about the process.** "Consider documenting the sweep", "add tests for the
  helper" — self-generated work that exists only because the agent thought of it.
- **Anything already written down.** If a repo doc now carries the fact, the issue is a
  duplicate of the doc.
- **One-off fixes already applied.** Git has it.
- **Sweep findings.** Step 2's output is fixed inline or dropped. Drift is not a ticket.
- **A near-duplicate of an open issue.** Check first; comment on the existing one instead.

## Volume ceiling — hard

**At most 3 issues per close.** Not a target; a ceiling — most closes should file zero.

If more than 3 clear both gates, that is a signal the session found a *theme*, not a
list: file ONE issue naming the theme, with the specifics as a checklist in its body.
Never open a fourth. The 168 same-day batches — worst case 25 into one repo in a day — are what this rule exists to stop.

If you are about to exceed the ceiling, say so in the step-6 report — "5 candidates, filed
the 3 that cleared, dropped 2 as speculative" — so the ceiling stays visible rather than
silently swallowing work.

## Always set the Issue Type

Measured defect: **39% of agent filings arrive untyped.** 32 repos are "mixed" — the type
demonstrably works there, yet 3–83% of filings skip it (`gnucashcli` 83%,
`fw-scanner-app` 72%, `mwk-cms` 71%). Control: **zero** repos with 5+ agent issues are
all-untyped, so the type was always available; the ceremony was just skipping it. Resolve the type ID and set it in the same `createIssue` mutation — an
untyped issue is invisible to `/td-fly:mailbox`'s type-based recommendations.

---

# Closing — the other half

Measured on the same corpus: **~30% of every monthly cohort of agent-filed issues is
still open** (Jun 33%, Jul 24%, Aug 34%), and **135 are 55+ days old across 23 repos**.
The 903 that *did* close had a median lifetime of 2 days, p90 of 17 and p95 of 24 — and
only **6 of 903 (0.7%)** ever closed after living past 60 days. So an agent-filed issue
still open at 60 days sits outside the envelope of essentially everything that ever
actually completed. Same ~3-month boundary as above.

**The ceremony itself is the asymmetry.** Across 62 `/td-fly:close` invocations in the
local transcript history: **1.87 issues created per run, 0.35 closed** — a 5:1 ratio.
81% of runs filed at least one issue. 67% of all issue creation happened inside a close
window, but only 18% of all closing did. The ceremony was a net issue *generator*; this
step is what makes it a net-zero one. (Boundary: local transcripts retain ~5 weeks,
2026-07-30 onward, so this measures the ceremony's *rate*, not the org-wide total.)

Closing is reversible (`gh issue reopen`), so it runs without asking — like every other
reversible action in this rhythm.

## Close these

- **Resolved** — `git log --grep="#<N>" --oneline` shows a commit implementing it, or the
  work landed this session.
  `gh issue close <N> --comment "Done in <sha> — <one line>. — <project-name>"`
- **Obsolete** — the premise no longer holds: the file or feature it names is gone, a
  later decision superseded it, or a repo doc now contradicts it.
  `gh issue close <N> --reason "not planned" --comment "<why it no longer applies>. — <project-name>"`
  **Verify the premise first** — `test -e` the path it names, read the doc it cites. A
  guess is not obsolescence, and a wrongly closed issue costs more than a stale one.
- **Stale Idea, 60+ days, untouched** — no comments, no referencing commits, no movement.
  `gh issue close <N> --reason "not planned" --comment "Stale — no movement in <N>d, closing to keep the list honest. Reopen if it matters. — <project-name>"`

## Leave alone

- Anything with an open discussion (a human commented and is waiting).
- Anything human-filed — no `**From:**` marker — unless it is *provably* resolved by a
  commit. The agent's backlog is the agent's to tidy; the owner's is not.
- **Epics** — their open children are the work.

## Never silent, and capped

Every close carries a one-line comment saying why. **Cap at 10 closes per run** so this
stays a checkpoint, not an audit — if more qualify, close the 10 oldest and report how
many remain.
