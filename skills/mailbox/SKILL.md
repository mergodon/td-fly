---
name: mailbox
description: Cross-repo check — issues filed into this repo and issues this repo filed into others, one digest with a recommended action each, one decision, one batch. Talks to a peer session when one is running here.
when_to_use: any new issues? · did they reply? · what did the other repos file? · anything in the mailbox · what's waiting on us
---

One digest, one decision, one batch. Never walk issues one by one. Rules:
`${CLAUDE_PLUGIN_ROOT}/contract.md` §2–§4; close/stale rules:
`${CLAUDE_PLUGIN_ROOT}/references/issue-discipline.md` ("Tending"). This skill files
nothing — it comments, closes, starts, relays.

# 1. Facts
- `gh repo view --json name,owner` → `<owner>/<name>`; `<name>` signs and is our marker.
  Fails → stop: "No GitHub remote or gh not authenticated."
- outbound scope: `owner/name` lines under `## Cross-repo` in `CLAUDE.md`. None → say
  `Outbound: no ## Cross-repo repos declared` and skip step 3.
- ours vs theirs: a comment ending `— <name>` is ours; anything else is theirs.
- peers: `ListAgents` once. A row whose name starts with a scoped repo's short name is a
  live peer (§3).

# 2. Inbound
```
gh api graphql -f query='query($o:String!,$n:String!){repository(owner:$o,name:$n){
 issues(first:100,states:OPEN,orderBy:{field:UPDATED_AT,direction:DESC}){nodes{
  number title body url createdAt issueType{name} parent{number}
  comments(last:5){totalCount nodes{author{login} body}}
  timelineItems(itemTypes:[CROSS_REFERENCED_EVENT],first:1){totalCount}}}}}' -F o=<owner> -F n=<name>
```
Parse `**From:** repo@branch` (absent = hand-filed). Per issue, anchored grep
`git log -E --grep='(^|[^/A-Za-z0-9])#<N>([^0-9]|$)' --oneline -5`; read a hit before
calling it a fix. GraphQL fails → `gh issue list --state open --limit 100 --json
number,title,body,issueType,createdAt,comments`, skip outbound, say so.

# 3. Outbound — two bounded queries, never one unbounded
Open: `search(query:"repo:<a> repo:<b> \"From: <name>\" type:issue state:open", type:ISSUE, first:100)`
with `number title url state body createdAt updatedAt repository{nameWithOwner}
issueType{name} comments(last:5){nodes{author{login} body}}`.
Closed in the last 14 days, `first:50`, add `closed:>=<date>` and `stateReason closedAt`.
Keep only bodies starting `**From:** <name>`. `issueCount` > 100 → say truncated.

# 4. Digest
Number continuously. Inbound newest first, Epics last. Type is a label; recommendations
key on evidence. Under every non-leave line print the draft it would post, signed.

Inbound, first match wins:
- Epic → report only: "planning surface — work its children".
- read commit implements it → "resolved — close?" + draft citing the sha.
- a live peer for the filing repo exists → "they're running here — relay?" + the message.
- concrete, no commit → "start, or leave?".
- stale (all seven conditions, issue-discipline) → "stale — close?" + draft.
- else → "leave?".

Outbound, by who holds the ball:
- live peer for that repo → "they're running here — relay instead of ping?" + message.
- last comment theirs → "they replied — answer?" + draft.
- ours or none, <14d → "leave — no time yet". 14–60d → "ping?" + draft.
  >60d → "no movement — leave"; "withdraw" only with the premise verified dead and
  what you checked.

Resolved (closed ≤14d) is a trailing report-only section: `done` (COMPLETED) or
`declined` (NOT_PLANNED). It never makes the digest actionable.

```
Mailbox: <I> inbound + <O> outbound
📥 1. #N  Type  title   from <marker|unmarked>  <age>  → <recommendation>  "<draft — name>"
📤 2. repo#N  Type  title  <ball>  <age>  → <recommendation>  "<draft — name>"
✅ repo#N  title  done|declined  <date>
Decide in one line: "close 1, relay 2, ping 3, skip rest". `show N` expands, `edit N: <text>` swaps a draft.
```
Nothing actionable → print ✅ if any, then `Nothing needs a call — all quiet. ✓`, stop.
Nothing at all → `Mailbox empty. ✓ (inbound: none; outbound scope: <slugs|none>)`.

# 5. One reply
Inbound: `start` `comment` `close` `relay` `skip`. Outbound: `comment` `ping` `relay`
`withdraw` `skip`. Unnamed = skip.

# 6. Batch
Every text ends `— <name>`. Drafts the digest showed just run — the reply approved them.
- close inbound: `gh issue close <N> --reason <completed|"not planned"> --comment "<text>"`
  — `not planned` for anything retired, `completed` only for shipped.
- comment: `gh issue comment <N> [--repo <slug>] --body "<text>"`.
- start: pick it up as the active piece; first commit says `Closes #<N>`.
- relay: run `/td-fly:relay <repo> <message>` — it finds the peer, talks, and writes the
  outcome on the issue.
- withdraw: the one second confirm — show the text, "withdraw N? (yes/edit/drop)", then
  `gh issue close <N> --repo <slug> --reason "not planned" --comment "<text>"`.

# 7. One line
`Mailbox done: <n> reviewed — <c> closed, <k> commented/pinged, <r> relayed, <s> started, <w> withdrawn, rest left. <x> outbound resolved since last check.`
