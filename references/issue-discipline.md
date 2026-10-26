# Issue discipline — what earns a record, what ends one

Loaded by `close` (file, tend) and `mailbox` (close actions). Filing and closing are one
lifecycle: an issue nobody closes is the same noise as one nobody should have filed.

## The bar — both gates, or don't file
1. **Name who is hurt, now.** A user hitting an error, a broken deploy, a wrong number
   in production, mate asking directly. "A future maintainer" is an invented victim.
2. **Point at evidence a reader can re-run.** A stack trace, an HTTP status, a failing
   command, a count from prod, a quoted ask.

**Source test, outranks wording.** Found by *looking at the repo* instead of *doing the
work* → not filed, however phrased. Sweep output is fixed inline or dropped.

**Duplicate check, cited.** Search the open list first; write `searched: <terms>` in the
body. Near-duplicate → comment on the existing one instead.

### File
- a bug with a reproduction · work blocked on a named obstacle · security, data-loss or
  money risk with the mechanism and the asset named · a fork only mate can decide

### Do not file
- a someday improvement · meta-work about the process · a fact a repo doc already holds
- a sweep finding · a reminder ("waiting on someone")

### Ceiling and cap
- **3 deferrable issues per close**; most closes file 0. Over 3 → one issue naming the
  theme, the rest as a checklist. Things actually broken do not count against it.
- **Backlog cap 20.** Count open issues with `**From:**` in the body. At 20+ file only
  Bugs and security risks.

### Type
`Bug` if broken, `Task` otherwise, set at creation (`--type`). Never `Idea`, never
`Epic` — mate's. Neither fits → re-read the gates.

---

# Tending

## Type — automatic
Every open issue without a type gets one; never change a set one. `gh issue edit <N>
--type <Bug|Task>`. Cap 15.

## Close — automatic, on positive evidence, never on age
- **Resolved** — a commit implements it. Candidates from the anchored grep
  `git log -E --grep='(^|[^/A-Za-z0-9])#<N>([^0-9]|$)' --oneline`; read the commit before
  citing it. `--reason completed --comment "Done in <sha> — <line>. — <name>"`.
- **Obsolete** — the premise is verified dead: `test -e` the path, read the doc, confirm
  the superseding decision. `--reason "not planned" --comment "<why>. — <name>"`.

`not planned` for anything retired, `completed` only for shipped — the sweep reads
`stateReason` to know what was declined. **Withdraw** is Obsolete seen from the filing
side: premise dead, or it stays open.

## Stale — mailbox proposes, mate decides
All seven, or it is not a candidate:
1. agent-filed (`**From:**`) — mate's own issues are never stale
2. `createdAt` 60+ days
3. no comments
4. no referencing commit (anchored grep)
5. no other open issue mentions `#<N>`
6. no `parent`
7. speculative on its own text — read it; the type field is not the trigger

## Leave alone
Open discussion · hand-filed unless a commit resolved it · Epics and whatever an open
issue references.

## Never silent, always capped
Every close carries a one-line signed comment. 10 closes per run — oldest first, report
the rest.
