---
description: Cross-repo work check — issues filed INTO this repo (inbound) and issues this repo filed INTO others (outbound), as one digest with a recommended action each. Decide in one reply; reversible actions just run.
---

You are running the mailbox check: gather cross-repo work both directions, show ONE digest with a recommended action per item, take decisions in a single reply, execute the batch. No walking issues one at a time. Lean — act on the obvious; only pause for the genuinely destructive.

# 1. Setup
- `gh repo view --json name,owner` → hold `<owner>/<name>`. If it fails: abort, "No GitHub remote or `gh` not authenticated."
- `<project-name>` = `<name>` (the repo's short name). This signs comments and is the `**From:**` marker to filter on.

# 2. Inbound — open issues in this repo
Issue Type isn't exposed by `gh issue list`, so fetch via GraphQL (no preview header needed):
```
gh api graphql -f query='query($owner:String!,$name:String!){
  repository(owner:$owner,name:$name){
    issues(first:50,states:OPEN,orderBy:{field:UPDATED_AT,direction:DESC}){
      nodes{ number title body updatedAt url author{login} issueType{name} }
    }
  }
}' -F owner=<owner> -F name=<name>
```
For each, grab related commits to judge "looks resolved": `git log --grep="#<N>" --oneline -5`.

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
Keep only issues whose body starts with `**From:** <project-name>`. That set is outbound. (Search index lags new issues a few seconds — a just-filed one may show next run.)

# 4. Digest — one numbered list
Inbound bucketed by Issue Type (Epic, Bug, Task, Idea, untyped), newest first within each. Outbound bucketed by who holds the ball. Number continuously across both so "close 3" is unambiguous.

Recommendation per item (one line, first match wins):

Inbound:
- Bug/Task with a commit referencing `#<N>` that looks like a fix → "looks resolved — close?"
- Epic → report-only: "planning surface — work its open children." Never nudge `start` on an Epic.
- Idea untouched > 60d → "stale — close?"
- Bug/Task, no referencing commits → "concrete piece — start, or leave?"
- else → "leave open?"

Outbound:
- last comment theirs / none, < 14d → "they haven't had time — leave?"
- awaiting reply 14–60d, no movement → "gentle ping?"
- awaiting reply > 60d → "stale — withdraw (close not-planned)?"
- ball with them (last comment ours) → "leave, check back later?"

```
Mailbox: <I> inbound + <O> outbound

📥 Inbound (this repo)
  1. #<N>  <Type>  <title>   from <From-marker or "unmarked">   <age>
         → <recommendation>

📤 Outbound (filed into: <slugs>)
  2. <repo>#<N>  <Type>  <title>   <ball-state>   <age>
         → <recommendation>

Decide in one line — e.g. "close 1, ping 2, start 3, skip rest". `show N` expands an item.
```

Both empty → print `Mailbox empty. ✓  (inbound: none; outbound scope: <slugs or "none declared">)` and exit.

# 5. One decision point
Wait for the single reply. Actions — inbound: `start` / `comment` / `close` / `promote` (Idea→Task) / `skip`; outbound: `comment` / `ping` / `withdraw` / `skip`. `show N` expands one item then the digest stands again. Anything unnamed = skip.

# 6. Execute the batch
Draft any needed text, each signed `— <project-name>`. Every cross-repo filing/closure keeps the `**From:** <project-name>` / sign-off convention.

- **Reversible actions just run — no second confirm round.** Comments and closes-with-comment are reversible (`gh issue comment --edit`, `gh issue reopen`); post them and show the text in the summary.
- **Confirm once only when** the directive is bare *and* you're inventing material content the user hasn't seen, OR the action is destructive (withdrawing/reopening another repo's issue). Show those drafts together, "post all? (yes / edit N / drop N)".

Commands:
- inbound close: `gh issue close <N> --comment "<text>"` (always a short closing note).
- inbound comment: `gh issue comment <N> --body "<text>"`.
- inbound promote (Idea→Task): resolve the org's Task issue-type ID, then `gh api graphql -f query='mutation($id: ID!, $t: ID!){ updateIssue(input:{id:$id, issueTypeId:$t}){ issue{number} } }' -F id=<node-id> -F t=<task-type-id>`.
- inbound start: pick it up as the active piece — note it however this project tracks state; first commit on it includes `Closes #<N>`.
- outbound comment/ping: `gh issue comment <N> --repo <slug> --body "<text>"`.
- outbound withdraw: `gh issue close <N> --repo <slug> --reason "not planned" --comment "<withdrawal — text>"` (never silent).

# 7. Summary — one line
`Mailbox done: <I+O> reviewed — <C> closed, <Co> commented/pinged, <St> started, <W> withdrawn, rest left.`

# Rules
- One digest, one decision point, one batch. No issue-by-issue walking. This command covers both directions — don't suggest a second one.
- Outbound scope is the `## Cross-repo` list in CLAUDE.md. Widen by editing that, not by bypassing it.
- Epics are reported, never `start`ed — their open children are the work.
- Don't re-nudge the same stale item every run; the recommendation is a once-in-a-while reminder, not a recurring prompt.
- If GraphQL errors (rate limit/auth), surface it and fall back to a degraded inbound-only listing.
