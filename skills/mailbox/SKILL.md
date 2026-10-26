---
name: mailbox
description: Cross-repo check — issues other repos filed into this one, and issues this repo filed into others, as one digest with a recommended action each. One reply decides; reversible actions just run.
when_to_use: 'any new issues? · anything in the mailbox? · did they reply? · what did the other repos file? · who is waiting on us? · new issues from <repo>? · check the inbox'
allowed-tools: Bash(gh repo view *), Bash(gh api graphql *), Bash(gh issue *), Bash(git log *), Bash(cat *), Bash(date *), Bash(mkdir *), Bash(tmux list-*), Bash(tmux send-keys *), Bash(tmux capture-pane *)
---

One digest, one decision, one batch. Never walk issues one at a time. Files nothing — it comments, closes, starts, and talks. Load `td-fly:protocol` before any cross-repo write or live message.

# 1. Facts
`gh repo view --json name,owner` → `<name>`, `<owner>/<name>`. Fails → stop: "No GitHub remote or `gh` not authenticated."
Last run stamp: `cat "${CLAUDE_PLUGIN_DATA}/last-mailbox-<owner>-<name>"` (ISO time; missing → everything is new). Items updated after it carry a `new` label.
Ours vs theirs: a comment ending `— <name>` is ours; anything else is theirs.

# 2. Inbound — open issues here
```
gh api graphql -f query='query($o:String!,$n:String!){repository(owner:$o,name:$n){issues(first:100,states:OPEN,orderBy:{field:UPDATED_AT,direction:DESC}){nodes{number title body url createdAt updatedAt issueType{name} parent{number} comments(last:5){totalCount nodes{author{login} body createdAt}} timelineItems(itemTypes:[CROSS_REFERENCED_EVENT],first:1){totalCount}}}}}' -F o=<owner> -F n=<name>
```
Parse `**From:** <who>@<branch>` (absent = hand-filed; no `@` = main). Branch is a label, never a filter. For each: anchored grep `git log -E --grep='(^|[^/A-Za-z0-9])#<N>([^0-9]|$)' --oneline -5`; **read a hit before calling it a fix.**
GraphQL fails → `gh issue list --state open --limit 100 --json number,title,body,issueType,createdAt,comments`, skip outbound, say so.

# 3. Outbound — what we filed elsewhere
Slugs = lines under `## Cross-repo` in this repo's `CLAUDE.md`. None → `Outbound: no ## Cross-repo repos declared.` Else two bounded searches, keep only bodies starting `**From:** <name>`:
- open: `search(query:"repo:<a> repo:<b> \"From: <name>\" type:issue state:open", type:ISSUE, first:100)` — number title url body updatedAt repository{nameWithOwner} issueType{name} comments(last:5){nodes{author{login} body}}
- closed in the last 14 days: same with `state:closed closed:>=<date>`, first:50, plus `stateReason closedAt`. Report-only.

# 4. Peers — who is live right now
`ListAgents`. A peer session whose name or cwd matches a slug in 2 or 3 is **live**; mark its items `● live: <session>`. No tool, no peers, no tmux → skip silently.

# 5. Digest
Number continuously. Inbound newest first, Epics last. Outbound bucketed by who holds the ball. Type is a label; recommendations key on evidence.
Inbound, first match wins: Epic → report-only · a read commit resolves it → "close?" + draft · concrete, no commit → "start, or leave?" · **stale** (all of: agent-filed, 60+ days, 0 comments, no commit, 0 cross-refs, no parent, speculative on its own text) → "close?" + draft · else "leave?".
Outbound: last comment theirs → "answer?" + draft · ours/none < 14 d → "leave" · 14–60 d → "ping?" + draft · > 60 d → "leave", or "withdraw?" only with the dead premise named.
Live items add one option: **"tell <session>?"** + the one-line message (protocol shape: ask, issue URL, what we checked).
```
Mailbox: <I> inbound + <O> outbound   (new since <stamp>: <k>)
📥 Inbound
  1. #N  Type  title   from <who>@<branch>   <age>  [new] [● live: <session>]
       → <recommendation>   "<draft — <name>>"
📤 Outbound (into: <slugs>)
  2. <repo>#N  Type  title   <ball>   <age>
       → <recommendation>   "<draft — <name>>"
✅ Resolved elsewhere (14 d): <repo>#N  title  done|declined  <date>
Decide in one line — e.g. "close 1, ping 2, tell 3, start 4, skip rest". `show N` expands, `edit N: <text>` swaps a draft.
```
Nothing actionable → print ✅ if any, then `Nothing needs a call — all quiet. ✓`, write the stamp (step 7), stop.

# 6. One reply, one batch
Actions — inbound: start / comment / close / tell / skip. Outbound: comment / ping / withdraw / tell / skip. Unnamed = skip. Drafts shown were approved by the reply; only **withdraw** confirms once more (it closes their issue).
- close: `gh issue close <N> --reason <completed|"not planned"> --comment "<text> — <name>"` — `not planned` for anything retired, `completed` only for shipped.
- comment / ping: `gh issue comment <N> [--repo <slug>] --body "<text> — <name>"`.
- start: make it the active piece; the first commit says `Closes #<N>`.
- tell: protocol tier 1 (`SendMessage`), else tier 2 (tmux), else say "no live peer" and leave the issue as the record.
- withdraw: `gh issue close <N> --repo <slug> --reason "not planned" --comment "<why the premise is dead> — <name>"`.

# 7. Stamp and summary
`mkdir -p "${CLAUDE_PLUGIN_DATA}" && date -u +%FT%TZ > "${CLAUDE_PLUGIN_DATA}/last-mailbox-<owner>-<name>"`.
`Mailbox done: <n> reviewed — <c> closed, <k> commented/pinged, <t> told live, <s> started, <w> withdrawn, rest left. <r> resolved elsewhere.`

Rules: never close an outbound issue because we think it shipped — theirs to close. A finished inbound issue needs no extra notice: `/td-fly:close` closes it on commit evidence with a signed comment, and that is the report. The ✅ section lives here only. Never file an Idea or an Epic; never retype one.
