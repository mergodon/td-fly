---
description: Cross-repo work check — issues filed INTO this repo (inbound) and issues this repo filed INTO others (outbound), as one digest with a recommended action each. Decide in one reply; reversible actions just run.
---

You are running the mailbox check: gather cross-repo work both directions, show ONE digest with a recommended action and its draft text per item, take decisions in a single reply, execute the batch. No walking issues one at a time. Lean — act on the obvious; only pause for the genuinely destructive.

# 1. Setup
- `gh repo view --json name,owner` → hold `<owner>/<name>`. If it fails: abort, "No GitHub remote or `gh` not authenticated."
- `<project-name>` = `<name>`. It signs comments and is the `**From:**` marker to filter on.
- **This command files nothing** — it comments, closes and starts. So it needs no branch of its own; `<branch>` here only ever means the one parsed out of *their* marker. **Nothing is filtered by branch** — a marker's `@<branch>` is shown as a label, never used to hide.
- **"Ours" vs "theirs"** — every login on both sides is usually the same person, so key on the sign-off: a comment whose body ends `— <project-name>` is ours; anything else is theirs.

# 2. Inbound — open issues in this repo
```
gh api graphql -f query='query($owner:String!,$name:String!){
  repository(owner:$owner,name:$name){
    issues(first:100,states:OPEN,orderBy:{field:UPDATED_AT,direction:DESC}){
      nodes{ number id title body url createdAt updatedAt author{login} issueType{name}
        parent{number} comments(last:5){totalCount nodes{author{login} body createdAt}}
        timelineItems(itemTypes:[CROSS_REFERENCED_EVENT],first:1){totalCount} }
    }
  }
}' -F owner=<owner> -F name=<name>
```
Parse each body's `**From:** name@branch` marker (absent = hand-filed; no `@` part = `main`). For each issue, find implementing commits with the **anchored** grep — `git log -E --grep='(^|[^/A-Za-z0-9])#<N>([^0-9]|$)' --oneline -5` (unanchored, `#1` matches `#10` and `other-repo#1`) — and **read a hit before treating it as a fix**.

GraphQL error (rate limit / auth) → `gh issue list --state open --limit 100 --json number,title,body,issueType,createdAt,comments` for inbound, skip outbound, say so in the header.

# 3. Outbound — issues this repo filed into others
Read this project's `CLAUDE.md` for a `## Cross-repo` heading and parse the `owner/name` slugs under it.
- **No section / no slugs** → outbound is empty. Say `Outbound: no ## Cross-repo repos declared in CLAUDE.md`. Skip the query.
- **Slugs present** (`repo:a repo:b` ORs them):
```
gh api graphql -f query='query($q: String!) {
  search(query: $q, type: ISSUE, first: 100) {
    issueCount
    nodes { ... on Issue {
      number title url state body createdAt updatedAt
      repository { nameWithOwner } issueType { name }
      comments(last: 5) { nodes { author { login } body createdAt } }
    } }
  }
}' -F q='repo:<slug1> repo:<slug2> "From: <project-name>" type:issue state:open'
```
Keep only issues whose body starts with `**From:** <project-name>`. `issueCount` > 100 → say the list is truncated. (The search index lags a few seconds — a just-filed one may show next run.)

**Then the closed ones — a second, bounded query.** An outbound issue the other repo finished just *disappears* from a `state:open` list: we never learn it landed. So ask for the recently-closed ones too, as a separate call — never by dropping `state:` from the query above, which would let old closed issues eat the 100-item cap and silently hide an open one.
```
gh api graphql -f query='query($q: String!) {
  search(query: $q, type: ISSUE, first: 50) {
    nodes { ... on Issue {
      number title url state stateReason closedAt
      repository { nameWithOwner } issueType { name }
      comments(last: 1) { nodes { author { login } body } }
    } }
  }
}' -F q='repo:<slug1> repo:<slug2> "From: <project-name>" type:issue state:closed closed:>=<YYYY-MM-DD, 14 days ago>'
```
Same `**From:**` filter. These are **report-only** — the other repo already decided; there is nothing here to approve.

# 4. Digest — one numbered list
Inbound newest first, Epics last. Outbound bucketed by who holds the ball. Number continuously across both so "close 3" is unambiguous. Show the type as a label, never bucket by it — recommendations key on **evidence, not type**.

Resolved outbound goes in its own trailing section — **no recommendation, no draft, and it never makes the digest actionable.** `stateReason` says which it was: `COMPLETED` → they shipped it; `NOT_PLANNED` → they declined or withdrew it. Report both the same way; re-filing a declined one is a fresh trip through the filing bar, not a mailbox action.

Recommendation per item (one line, first match wins). **Under every non-`leave` recommendation, print the draft text it would post** — the one reply approves the text too.

Inbound:
- Epic → report-only: "planning surface — work its open children." Never nudge `start` on an Epic. (Checked first so a referencing commit can't shadow it.)
- A read commit implements it → "looks resolved — close?" + draft closing note citing the sha.
- No referencing commits, concrete and actionable → "concrete piece — start, or leave?"
- Stale — **all seven conditions** in `references/issue-discipline.md` ("Stale"): agent-filed, `createdAt` 60+ days, `comments.totalCount` 0, no referencing commit, `timelineItems.totalCount` 0, `parent` empty, speculative on its own text → "stale — close?" + draft note. Owner-filed (no marker) is never stale.
- else → "leave open?"

Outbound (by the sign-off rule in §1):
- last comment **theirs** → "they replied — answer?" at any age + draft reply.
- last comment ours / none, < 14d → "they haven't had time — leave?"
- last comment ours / none, 14–60d → "gentle ping?" + draft.
- last comment ours / none, > 60d → "no movement — leave?"; recommend **withdraw** only if you verified the premise is dead (the Obsolete test in the reference), and say what you checked.

```
Mailbox: <I> inbound + <O> outbound

📥 Inbound
  1. #<N>  <Type>  <title>   from <From-marker or "unmarked">   <age>
         → <recommendation>
           "<draft text — <project-name>>"

📤 Outbound (filed into: <slugs>)
  2. <repo>#<N>  <Type>  <title>   <ball-state>   <age>
         → <recommendation>
           "<draft text — <project-name>>"

✅ Resolved (closed in the last 14 days — nothing to do)
     <repo>#<N>  <title>   <done | declined>   <closed date>

Decide in one line — e.g. "close 1, ping 2, start 3, skip rest". `show N` expands an item; `edit N: <text>` replaces a draft.
```

If **no item is actionable** (every recommendation is "leave" or a report-only Epic line), don't stage a decision point — print the ✅ Resolved section if it has anything, then close with `Nothing needs a call — all quiet. ✓` and stop. Nothing open either direction and nothing resolved → `Mailbox empty. ✓  (inbound: none; outbound scope: <slugs or "none declared">)` and exit.

# 5. One decision point (only if something's actionable)
Wait for the single reply. Actions — inbound: `start` / `comment` / `close` / `skip`; outbound: `comment` / `ping` / `withdraw` / `skip`. `show N` expands one item, `edit N: <text>` swaps its draft, then the digest stands again. Anything unnamed = skip.

# 6. Execute the batch
Every draft is signed `— <project-name>`. Nothing here files a new issue, so no `**From:**` marker is written — the marker is only ever read.

- **Everything the digest showed a draft for just runs** — the reply approved the text. Comments and closes are reversible (`gh issue comment --edit-last`, `gh issue reopen`).
- **`withdraw` is the one second confirm** — it closes another repo's issue. Show the closing text, "withdraw N? (yes / edit / drop)", then run.

Commands:
- inbound close: `gh issue close <N> --reason "<completed|not planned>" --comment "<text>"`. **`not planned` for anything retired rather than done** — `completed` only for work that shipped. `references/sweep-criteria.md` reads `stateReason` to learn what was already declined; get this wrong and the item is re-flagged forever.
- inbound comment: `gh issue comment <N> --body "<text>"`.
- inbound start: pick it up as the active piece — note it however this project tracks state; first commit on it includes `Closes #<N>`.
- outbound comment/ping: `gh issue comment <N> --repo <slug> --body "<text>"`.
- outbound withdraw: `gh issue close <N> --repo <slug> --reason "not planned" --comment "<withdrawal — text>"` (never silent).

# 7. Summary — one line
`Mailbox done: <I+O> reviewed — <C> closed, <Co> commented/pinged, <St> started, <W> withdrawn, rest left. <R> outbound resolved since last check.`

# Rules
- One digest, one decision point, one batch. No issue-by-issue walking. This command covers both directions — don't suggest a second one.
- Outbound scope is the `## Cross-repo` list in CLAUDE.md. Widen by editing that, not by bypassing it.
- **Closing rules are shared, not duplicated** — `references/issue-discipline.md` ("Tending the backlog") is canonical for resolved / obsolete / stale / withdraw and for what to leave alone. This command decides *with* the user; `/td-fly:close` applies the same rules unattended. Same triggers, same commands, different confirmation model — don't let the two drift.
- **Never close an outbound issue because *we* think the work is done** — it lives in their repo and is theirs to close. `withdraw` is the only exception and it means the premise is dead, not that it shipped. Our side of a finished outbound issue is reading the ✅ Resolved section.
- **Reporting a finished *inbound* issue needs nothing extra** — `/td-fly:close` 5b already closes it on commit evidence with a comment signed `— <project-name>`, and that comment on the thread *is* the report back to the repo that filed it. Don't add a second notification.
- **The ✅ Resolved section lives here, not in `/td-fly:close`** — outbound state is a network query into other repos, and `close` step 5 tends *this* repo's backlog only.
- **The agent never files an `Idea` or an `Epic`** — those are the owner's to create. Retyping one is not a mailbox action; a stale Idea is closed or left, never reclassified.
