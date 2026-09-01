---
description: Cross-repo work check — issues filed INTO this repo (inbound) and issues this repo filed INTO others (outbound), as one digest with a recommended action each. Decide in one reply; reversible actions just run.
---

You are running the mailbox check: gather cross-repo work both directions, show ONE digest with a recommended action per item, take decisions in a single reply, execute the batch. No walking issues one at a time. Lean — act on the obvious; only pause for the genuinely destructive.

# 1. Setup
- `gh repo view --json name,owner` → hold `<owner>/<name>`. If it fails: abort, "No GitHub remote or `gh` not authenticated."
- `<project-name>` = `<name>` (the repo's short name). This signs comments and is the `**From:**` marker to filter on.
- `git branch --show-current` → hold `<branch>`. **Mailbox is branch-scoped:** it shows only filings tagged for `<branch>`. A marker's branch is the part after `@` in `**From:** name@branch`; absent = `main`. Empty output (detached HEAD) → skip branch filtering and note `branch: detached — not filtered` in the digest header.

# 2. Inbound — open issues in this repo
Fetch via GraphQL — one call covers type, body and author (`gh issue list --json number,title,body,issueType` also exposes Issue Type as of gh 2.98.0, if you ever need a lighter query):
```
gh api graphql -f query='query($owner:String!,$name:String!){
  repository(owner:$owner,name:$name){
    issues(first:50,states:OPEN,orderBy:{field:UPDATED_AT,direction:DESC}){
      nodes{ number title body updatedAt url author{login} issueType{name} }
    }
  }
}' -F owner=<owner> -F name=<name>
```
**Branch filter:** parse each issue's `**From:** name@branch` marker. Keep an issue if it has NO `**From:**` marker (hand-filed — never hide it) OR its marker branch == `<branch>` (marker branch absent = `main`). Set the rest aside as off-branch (counted, not shown).
For each kept issue, grab related commits to judge "looks resolved": `git log --grep="#<N>" --oneline -5`.

# 3. Outbound — issues this repo filed into others
Read this project's `CLAUDE.md` for a `## Cross-repo` heading and parse the `owner/name` slugs under it.
- **No section / no slugs** → outbound is empty. In the digest say `Outbound: no ## Cross-repo repos declared in CLAUDE.md`. Skip the query.
- **Slugs present** → search them, filtered to our filings:
```
gh api graphql -f query='query($q: String!) {
  search(query: $q, type: ISSUE, first: 50) {
    nodes { ... on Issue {
      number title url state body updatedAt
      repository { nameWithOwner } issueType { name }
      comments(last: 5) { nodes { author { login } body } }
    } }
  }
}' -F q='repo:<slug1> repo:<slug2> "<project-name>" type:issue state:open'
```
Keep only issues whose body starts with `**From:** <project-name>` (optionally `@<branch>`) AND whose marker branch == `<branch>` (marker branch absent = `main`). That branch-matched set is outbound; count the rest as off-branch. (Search index lags new issues a few seconds — a just-filed one may show next run.)

# 4. Digest — one numbered list
Inbound newest first, Epics last. Outbound bucketed by who holds the ball. Number continuously across both so "close 3" is unambiguous. Show the type as a label, but don't bucket by it — the type is wrong too often to organise a digest around (39% of agent filings arrive untyped).

Recommendation per item (one line, first match wins). Keyed on **evidence, not type**:

Inbound:
- A commit referencing `#<N>` looks like a fix → "looks resolved — close?"
- Epic → report-only: "planning surface — work its open children." Never nudge `start` on an Epic. (Epics are 1% of issues in 5 of 75 repos, but where the owner uses them they carry real sub-issues, so the guard earns its line.)
- No referencing commits, concrete and actionable → "concrete piece — start, or leave?"
- 60+ days, no comments, no referencing commits, nothing links to it → "stale — close?" Never on an owner-filed issue: no `**From:**` marker means they meant it.
- else → "leave open?"

Outbound:
- last comment theirs / none, < 14d → "they haven't had time — leave?"
- awaiting reply 14–60d, no movement → "gentle ping?"
- awaiting reply > 60d → "stale — withdraw (close not-planned)?"
- ball with them (last comment ours) → "leave, check back later?"

```
Mailbox: <I> inbound + <O> outbound   ·   branch: <branch>

📥 Inbound (branch: <branch>)
  1. #<N>  <Type>  <title>   from <From-marker or "unmarked">   <age>
         → <recommendation>

📤 Outbound (filed into: <slugs> · branch: <branch>)
  2. <repo>#<N>  <Type>  <title>   <ball-state>   <age>
         → <recommendation>

Decide in one line — e.g. "close 1, ping 2, start 3, skip rest". `show N` expands an item.
```

If **no item is actionable** (every recommendation is "leave open?" or a report-only Epic line), don't stage a decision point — close with `Nothing needs a call — all quiet. ✓` and stop. Only wait for a reply when at least one item invites an action.

If branch filtering set anything aside, end the digest with one line: `(off-branch items hidden — checkout that branch to see them)`. No per-item count; just the notice. Omit it when nothing was hidden.

Both kept-lists empty → print `Mailbox empty for branch <branch>. ✓  (inbound: none; outbound scope: <slugs or "none declared">)` and exit — but if items existed yet all were off-branch, say `Mailbox empty for branch <branch> — all items are on other branches. ✓` instead.

# 5. One decision point (only if something's actionable)
When at least one item invites an action, wait for the single reply. Actions — inbound: `start` / `comment` / `close` / `skip`; outbound: `comment` / `ping` / `withdraw` / `skip`. `show N` expands one item then the digest stands again. Anything unnamed = skip. If everything's quiet, you already exited at the end of §4 — don't ask.

# 6. Execute the batch
Draft any needed text, each signed `— <project-name>`. Every cross-repo filing/closure keeps the `**From:** <project-name>@<branch>` / sign-off convention.

- **Reversible actions just run — no second confirm round.** Comments and closes-with-comment are reversible (`gh issue comment --edit`, `gh issue reopen`); post them and show the text in the summary.
- **Confirm once only when** the directive is bare *and* you're inventing material content the user hasn't seen, OR the action is destructive (withdrawing/reopening another repo's issue). Show those drafts together, "post all? (yes / edit N / drop N)".

Commands:
- inbound close: `gh issue close <N> --reason "<completed|not planned>" --comment "<text>"` (always a short closing note). **Use `not planned` for anything retired rather than done** — a stale Idea, a withdrawn ask. `completed` is only for work that actually shipped. This matters beyond tidiness: the step-2 sweep in `/td-fly:close` finds previously-declined items with `--search 'reason:not-planned'`, so an Idea closed as `completed` becomes invisible there and gets re-flagged forever.
- inbound comment: `gh issue comment <N> --body "<text>"`.
- inbound start: pick it up as the active piece — note it however this project tracks state; first commit on it includes `Closes #<N>`.
- outbound comment/ping: `gh issue comment <N> --repo <slug> --body "<text>"`.
- outbound withdraw: `gh issue close <N> --repo <slug> --reason "not planned" --comment "<withdrawal — text>"` (never silent).

# 7. Summary — one line
`Mailbox done: <I+O> reviewed — <C> closed, <Co> commented/pinged, <St> started, <W> withdrawn, rest left.`

# Rules
- One digest, one decision point, one batch. No issue-by-issue walking. This command covers both directions — don't suggest a second one.
- Outbound scope is the `## Cross-repo` list in CLAUDE.md. Widen by editing that, not by bypassing it.
- Branch-scoped: the view is filtered to your current branch via the `@<branch>` marker. Coordinate by keeping branch names aligned across repos. Unmarked (hand-filed) inbound issues are never branch-hidden.
- **Closing rules are shared, not duplicated** — `references/issue-discipline.md` ("Closing") is canonical for what counts as resolved / obsolete / stale, and for what to leave alone. This command decides *with* the user; `/td-fly:close` applies the same rules unattended. Same triggers, same commands, different confirmation model — don't let the two drift.
- **The agent never files an `Idea` or an `Epic`** (`references/issue-discipline.md`) — those are the owner's to create. So retyping one is not a mailbox action; an Idea that has gone stale is closed or left, never reclassified.
- Don't re-nudge the same stale item every run; the recommendation is a once-in-a-while reminder, not a recurring prompt.
- If GraphQL errors (rate limit/auth), surface it and fall back to a degraded inbound-only listing.
