# Issue discipline — what earns an issue, and what ends one

Loaded by `/td-fly:close` steps 3 and 5, and canonical for `/td-fly:mailbox`'s close
actions. Filing and closing are one lifecycle: an issue nobody ever closes is the same
noise as one nobody should have filed. Only the rules live here; the census and the
backtests they rest on are in `docs/evidence.md`, which is not loaded at run time.

## The bar — both gates, or don't file

**Gate 1 — name who is hurt, right now.**
A user hitting an error, a broken deploy, a wrong number in production, the owner asking
directly. The victim must be **current and identifiable**. "A future maintainer", "the
next dev", "whoever reads this" is an invented victim and fails.

**Gate 2 — point at evidence a reader could re-run.**
A stack trace, an HTTP status, a failing command, a count measured on prod, a quoted ask.
The tell for the other kind is prose about the repo itself, with no victim and nothing
to re-run.

**Source test, and it outranks wording.** If the finding came from *looking at the repo*
rather than from *doing the work*, it does not get filed — however it is phrased.
Rewording "found by a doc sweep" to "verified:" changes nothing. Sweep output is fixed
inline or dropped.

**Before filing, search the open list for a duplicate and say you did** — cite it in
the body (`searched: <terms>`). An uncited duplicate check is not a check.

## File

- **Bugs with a reproduction** — a command that fails, a wrong output, a broken deploy.
- **Blocked work** — started, then stopped on a named obstacle. "Waiting on someone to
  get round to it" is a reminder, not an issue.
- **Security, data-loss and money risk** — the one Gate 2 exception, and it is narrow:
  name the **concrete mechanism and the asset at risk**. If invoking it feels
  convenient, it does not apply.
- **A decision only the owner can make** — a real fork, not a preference.

## Do not file

- **Speculative improvements** — "we could someday generalise X".
- **Meta-work about the process** — "consider documenting the sweep", "add tests for the
  helper". Work that exists because the agent thought of it.
- **Anything already written down.** A repo doc carrying the fact makes the issue a
  duplicate of the doc.
- **Sweep findings** — the source test above.
- **Near-duplicates of an open issue** — comment on the existing one.

## Ceiling — severity-aware

**At most 3 non-urgent issues per close**, and most closes should file zero. Over that,
file ONE issue naming the theme with the rest as a checklist.

**The ceiling does not apply to things that are actually broken.** Bugs, security defects
and anything blocking a release are filed individually however many there are. Count
only the deferrable items against the ceiling, and say so in the report when collapsing.

**Backlog cap.** Before filing, count this repo's open agent-filed issues (`**From:**`
in the body). **At 20 or more, file nothing that is not a Bug or a security risk** until
the backlog is back under 20. The per-session ceiling is gameable across sessions; this
is not.

## Type it, and only ever Bug or Task

**Never file an `Idea`. Never file an `Epic`.** Those are the owner's to create — file
one only when the owner asks for it in so many words. That leaves two types: **Bug** if
something is broken, **Task** otherwise. Neither → re-read the gates; it probably should
not be filed. Set it at creation (`gh issue create --type`). The type is the label the
mailbox digest shows; recommendations key on evidence, not on it.

---

# Tending the backlog

## Typing — automatic, and safe

Set a type on every open issue that lacks one; **never change a type already set.** An
untyped issue is an absence of a decision, not a decision. Bug if something is broken,
Task otherwise. `gh issue edit <N> --type <Bug|Task>`; reversible, so it does not ask.

## Close these, without asking

Both are reversible (`gh issue reopen`) and both require **positive evidence**, never age.

- **Resolved** — a commit implements it. Candidates come from an anchored grep,
  `git log -E --grep='(^|[^/A-Za-z0-9])#<N>([^0-9]|$)' --oneline` — unanchored, `#1`
  matches `#10` and `other-repo#1` — and the commit is **read before it is cited**.
  `gh issue close <N> --reason completed --comment "Done in <sha> — <one line>. — <project-name>"`.
- **Obsolete** — the premise no longer holds, **verified**: `test -e` the path it names,
  read the doc it cites, confirm the superseding decision. A guess is not obsolescence.
  `gh issue close <N> --reason "not planned" --comment "<why it no longer applies>. — <project-name>"`.

Always `--reason "not planned"` for anything retired rather than shipped — the sweep in
`references/sweep-criteria.md` reads `stateReason` to learn what was already declined,
and a retired item closed as `completed` gets re-flagged forever. **Withdrawing** an
outbound issue is the same Obsolete test from the other side: the premise is verified
dead, or it stays open.

## Stale — propose, never auto-close

Age alone is not evidence: a backtest of "60+ days, untouched → close" was wrong 6 times
in 10 (`docs/evidence.md`). **List candidates in the report and let the owner decide in
one reply.** A candidate needs **all** of:

1. agent-filed (`**From:**` marker) — an owner-filed issue is never a candidate, they meant it;
2. `createdAt` 60+ days ago;
3. no comments;
4. no referencing commit (the anchored grep above);
5. not referenced by another open issue (`#<N>` in no other open body);
6. not a child of an open Epic (`parent` empty);
7. speculative on its own text — read it; the type field is not the trigger.

## Leave alone

- Anything with an open discussion.
- Anything human-filed — no `**From:**` marker — unless provably resolved by a commit.
- **Epics**, and any issue an open issue references.

## Never silent, and capped

Every close carries a one-line comment saying why. **Cap at 10 closes per run** — if
more qualify, close the 10 oldest and report how many remain. Typing caps at 15.
