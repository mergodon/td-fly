---
name: protocol
description: The cross-repo protocol — how repos and live Claude sessions talk. Load before filing an issue into another repo, answering one filed here, or messaging another session.
when_to_use: filing an issue into another repo, **From:** marker, signing a cross-repo comment, withdrawing an issue, messaging another Claude session, ListAgents, SendMessage, tmux send-keys, leader session, relaying mate's decision
user-invocable: false
---

# The record, then the channel
1. **The issue is the record.** Every cross-repo ask, answer and outcome lands on a GitHub issue. A live message is a shortcut to the person working it, never a substitute.
2. **The channel is optional.** Use it when a peer session exists; its absence is never an error and never a reason to wait.

# Issues
- **Declare** connected repos in this project's `CLAUDE.md` under `## Cross-repo`, one `owner/name` per line. That list is the whole outbound scope of `/td-fly:mailbox`. Widen it by editing the list, never by bypassing it.
- **Mark** every issue this repo files, anywhere: body opens `**From:** <name>@<branch>` — `<name>` = this repo's short name, `<branch>` = `git branch --show-current`. No marker = hand-filed by the owner. Marker without `@` reads as `main`. The branch is a label, never a filter.
- **Sign** every cross-repo comment and closure `— <name>`. Never address GitHub logins; both sides are usually the same person.
- **Each side closes its own.** An issue filed into this repo is closed here, on commit evidence, with a signed comment — that comment is the report back. An issue we filed elsewhere is theirs to close; we never close it because we believe it shipped.
- **Withdraw** is the one reach into another repo: `gh issue close <N> --repo <slug> --reason "not planned" --comment "<why the premise is dead> — <name>"`. Only when the premise is verified dead.
- **Type Bug or Task only.** Idea and Epic are the owner's.

# Live channel — three tiers, first available wins
1. **Peer session (harness).** `ListAgents` lists other Claude sessions on this box with their tmux pane. `SendMessage({to: "<name>", message: "<first line = the whole point>"})`. A send proves delivery to the session, not that it read it. Add `notify_when_idle: true` to hear once when it finishes; never poll.
2. **tmux pane (no listed session).** Only if `tmux` is on PATH and `tmux list-windows -a` names the target:
   `tmux send-keys -t <target> -l "<text>" && tmux send-keys -t <target> Enter`, then after a pause `tmux capture-pane -p -t <target> | tail -20`. Pass the message as `-l` literal text; never type commands into another agent's prompt.
3. **No peer.** The issue alone. Say so in one line and keep working.

Message shape, every tier: first line states the ask or the answer; then the issue URL; then what you already checked. Relayed decisions open `from <repo> session (mate's words: "<quote>")`.

# Leader rule — two sessions, one problem
- Mate names the **leader** once ("the <repo> session leads"). Until then, the session mate is typing into leads.
- The leader owns the issue thread and relays mate's decisions to the follower, quoted as above.
- The follower acts on relayed decisions as mate's own, keeps working, and never waits on mate directly.
- Permission boundaries stay per session: never ask a peer to run what your session was denied.
- Outcomes land on the issue as a signed comment, by whichever side did the work. The live exchange is not the record.
