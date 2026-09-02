# Evidence behind the thresholds

The numbers `references/issue-discipline.md` and `commands/mailbox.md` rest on. Kept
here, not in the references, because nothing at run time branches on them — the
commands load only the rules. Re-measure before changing a threshold; don't argue from
these figures once they are a season old.

## Filing census — all `mergodon` repos, 2026-09-01

162 repos, 1534 issues ever filed.

| | |
|---|---|
| Filed by the close ceremony | **1278 of 1534 — 83%** |
| Filed by the owner | 256 |
| August: agent vs owner | **541 vs 30 — 18:1, at 17.5/day** |
| Worst single day into one repo | 25 |
| Same-day batches of 3+ into one repo | 168 |
| Still open, agent-filed | 375, across 60 repos |
| Never closed, every cohort | ~30% |
| Filed with no Issue Type set | 39% |

Hand classification of 110 agent filings: 27% load-bearing, 38% real-but-deferrable,
16% speculative, 18% noise. A third should never have been filed; two thirds were
legitimate — so the bar cuts the bottom third, not everything.

Boundary: the `**From:**` marker is the only way to separate agent from human filings and
starts 2026-05-19 (in `td-flow`, the predecessor), so agent-side figures cover ~3.5
months. Two marker forms exist — `**From:** name@branch` and older `**From:** name` —
and both are counted; a branch-only count returns 1008 instead of 1278.

The worst day (25 into `anzscofinder-app-web`) was a launch audit spanning five separate
security defects, legal, billing and one urgent blocker — collapsing it would have hidden
the blocker. The same day's other extreme, 13 one-line feature ideas into a test repo, is
what the 3-per-close ceiling is for. Hence *severity-aware*.

## Types

Of 151 Ideas, **116 (77%) were agent-filed**; Idea has the worst close rate of any type
(55% vs 67% for Task). Epics: 15 issues in 5 of 75 repos, and where the owner uses them
they carry real sub-issues. Hence: the agent files Bug/Task only.

39% of agent filings arrive untyped. Among repos with 5+ agent-filed issues, 32 are
"mixed" — the type demonstrably works there yet 3–83% of filings skip it; zero such repos
are all-untyped, so the feature is always available. Of open issues, 31% (129 of 420,
across 42 repos) carry no type; of the 34 owner-filed ones, 19 predate Issue Types
existing at all (median age 236 days). Per-repo load: median 2, p90 6, max 11 — hence
auto-typing is cheap and capped at 15.

## Auto-close backtest — why stale is a question, not an action

"Idea, 60+ days, untouched → close" backtested against 10 real issues: **6 of 10 closes
wrong**.

- The type field is unreliable as a trigger: 25% of open agent-filed issues are untyped,
  and two issues in the sample were active scope migrated from an older system, mistyped.
- It ignored structure: it would have closed an open child of an open Epic, and an issue
  another open issue depended on ("Pairs with #37").
- The safety argument was survivorship bias. "Only 6 of 903 closed issues lived past 60
  days (0.7%)" — only 325 of those 903 were created early enough to *possibly* show a
  60-day life, so the real rate is **1.8%**, and the statistic only ever measures issues
  that already resolved. The oldest agent-filed issue is 105 days, so no threshold near
  90 days has completed a single cycle.

## Branch-scoped mailbox — why it was dropped (v0.14.0)

Of the first 1000 `**From:**` issues, 288 were cross-repo and **61 carried a non-`main`
branch**. The receiving repo almost never has that branch — `td-sops` ←
`rgb-rgbtracker-web@docs/coinpoker-email-ingest` and `rgb-superset` ←
`@feat/hands-as-source-of-truth` were both open and invisible on the receiver's `main`
indefinitely. The only aligned pair in the corpus was `fw-etl-app` ↔ `fw-scanner-app` on
`v3`. Self-filed feature-branch issues (`rgb-analytics` #3–#9, `@idea/leak-training`, 7
of 10 open) vanished from the mailbox on `main` while `close` step 5 saw all of them. The
marker still stamps the branch, as information; nothing filters on it.

## Grep anchoring

`git log --grep='#1'` in `td-fly` matches `d56b5df` via `rgb-analytics#10`; in
`rgb-rgbtracker-web`, `#2` matches 15 commits unanchored and 2 anchored. Hence the
anchored form and "read the commit before citing it".
