---
name: mailbox
description: Cross-repo check — issues other repos filed into this one, issues this repo filed into others, one digest, one decision, one batch. Can talk to a peer session live when one is running.
when_to_use: Plain asks such as "any new issues?", "did they reply?", "what did the other repos file?", "anything from that repo?", "ping them", "tell the other session".
---

Run the mailbox. One digest, one decision point, one batch. Act on the reversible; pause only for the destructive.

# 1. Facts
- `gh repo view --json name,owner` → `<owner>/<name>`. Fails → stop: "no GitHub remote or `gh` not authenticated."
- `<name>` signs every comment (`— <name>`) and is the `**From:**` marker to match.
- Outbound scope = the `owner/repo` lines under `## Cross-repo` in this repo's `CLAUDE.md`. None → outbound is empty; say so.
- Ours vs theirs: a comment ending `— <name>` is ours. Everything else is theirs. Logins do not tell you.
- The marker's `@branch` is a label. Never filter by it.

# 2. Fetch
Inbound: `gh issue list --state open --limit 100 --json number,title,body,url,issueType,createdAt,updatedAt,comments`. Parse `**From:** name@branch` per body (absent = hand-filed).
Outbound, open: `gh search issues --repo <slug> ... "From: <name>" --state open --limit 100 --json number,title,url,repository,updatedAt,createdAt,comments`. Keep bodies that start with `**From:** <name>`.
Outbound, resolved: same search with `--state closed --closed ">=<14 days ago>"`. Report-only.
For every inbound issue: `git log -E --grep='(^|[^/A-Za-z0-9])#<N>([^0-9]|$)' --oneline -5`, read a hit before calling it a fix.

# 3. Live channel
The issue is the record. A running peer session is the fast path.
1. `ListAgents`. A peer whose name matches the repo → `SendMessage({to: "<name>", message: "..."})`.
2. Not listed, tmux present (`type tmux`) → `tmux send-keys -t <session> -l "<text>" && tmux send-keys -t <session> Enter`; read with `tmux capture-pane -p -t <session> | tail -20`. tmux absent → skip; never fail on it.
3. No peer → the issue alone.
Every message opens `from <name> session (mate's words: "...")`. Two sessions on one problem → mate names the LEADER once. The leader relays mate's decisions; the other side keeps working and does not wait on mate. The outcome goes on the issue as a signed comment, every time.

# 4. Digest
Number continuously, inbound first (newest first, Epics last), then outbound by who holds the ball, then Resolved. Show type as a label; recommend on evidence, not type. Under every actionable item print the draft text it would post.

Inbound, first match wins:
- Epic → report-only: "work its open children."
- A read commit implements it → "resolved — close?" + draft citing the sha.
- Concrete, no commit → "start, or leave?"
- Stale, ALL of: `**From:**` marker, 60+ days, no comments, no commit, no `#<N>` in another open body, no parent, speculative on its own text → "stale — close?" + draft. Hand-filed is never stale.
- Else → "leave?"

Outbound:
- Last comment theirs → "they replied — answer?" + draft.
- Ours or none, < 14 d → "leave."
- Ours or none, 14–60 d → "ping?" + draft.
- Ours or none, > 60 d → "leave"; "withdraw?" only if you verified the premise is dead and say what you checked.
- A peer session for that repo is listed → add "live: ask the <repo> session?"

```
Mailbox: <I> inbound + <O> outbound
📥 Inbound
  1. #<N>  <Type>  <title>   from <marker|unmarked>   <age>
         → <recommendation>
           "<draft> — <name>"
📤 Outbound (into: <slugs>)
  2. <repo>#<N>  <Type>  <title>   <ball>   <age>
         → <recommendation>
✅ Resolved (last 14 days)
     <repo>#<N>  <title>   <done|declined>   <date>
Decide in one line: "close 1, ping 2, start 3, live 4, skip rest". `show N` expands, `edit N: <text>` swaps a draft.
```
Nothing actionable → print Resolved if any, then `Nothing needs a call — all quiet. ✓`. Nothing at all → `Mailbox empty. ✓ (outbound scope: <slugs|none>)`.

# 5. Decide, then run the batch
One reply. Unnamed = skip. Actions: inbound `start` / `comment` / `close` / `skip`; outbound `comment` / `ping` / `live` / `withdraw` / `skip`.
- Drafts shown run as approved. Comments and closes are reversible.
- `withdraw` asks once more: it closes another repo's issue, and only because the premise is dead — never because we think it shipped.
- inbound close: `gh issue close <N> --reason <completed|"not planned"> --comment "<text> — <name>"`. `not planned` for anything retired, `completed` only for shipped work.
- comment / ping: `gh issue comment <N> [-R <slug>] --body "<text> — <name>"`.
- start: pick it up now; the first commit says `Closes #<N>`.
- live: send via step 3, wait for the reply, post the outcome on the issue.
- withdraw: `gh issue close <N> -R <slug> --reason "not planned" --comment "<why> — <name>"`.
Each side closes its own issues. Resolved inbound gets closed by `close` on commit evidence; its signed comment is the report back. Nothing more is owed.

# 6. Summary
`Mailbox done: <n> reviewed — <c> closed, <k> commented, <s> started, <l> live, <w> withdrawn, rest left. <r> outbound resolved since last check.`
