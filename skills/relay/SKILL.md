---
name: relay
description: Send one message to another repo's running agent session over the live channel (peer session, then tmux, else none) and put the outcome on the GitHub issue. Keeps working while the other side answers.
argument-hint: "<repo or session> <message>"
when_to_use: tell the X session · ask the X repo · relay this to X · let X know · is the X session running?
---

Channel rules: `${CLAUDE_PLUGIN_ROOT}/contract.md` §3 (tiers) and §4 (leader). The
record is the issue; the channel is only faster. `$ARGUMENTS` = `<target> <message>`.

# 1. Find the peer — stop at the first tier that works
1. `ListAgents`. A row whose name starts with `<target>` is the peer. Two rows → use the
   one with ` [ref]`, or the one whose tmux pane path is the target repo.
2. Not listed → `tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} #{pane_current_path} #{pane_current_command}' 2>/dev/null`.
   A pane whose path ends in `/<target>` and runs `claude`/`node` is the peer; keep its
   `session:window.pane`. `tmux` missing or no server → tier 3.
3. No peer → say `no live session for <target>; the issue is the channel`. If an issue is
   named, comment it there (step 4) and stop. Not an error.

# 2. Say it
- Our name: `gh repo view --json name -q .name` → `<name>`.
- Relaying mate's decision? Open with `from <name> session (mate's words: "<quote>")`.
  Otherwise open with `from <name> session:`. One message, first line self-contained,
  the issue URL in it when one exists.
- Tier 1: `SendMessage({to: "<peer name>", message: "<text>", notify_when_idle: true})`.
  A send proves delivery, not reading. Never ask a peer to do what this session was
  denied.
- Tier 2: `tmux send-keys -t <pane> -l "<text>"` then `tmux send-keys -t <pane> Enter`.

# 3. Hear back — without blocking mate's work
- Tier 1: the reply arrives as `<cross-session-message from="…">` or the idle notice.
  Keep working on the current task meanwhile; do not poll `ListAgents`.
- Tier 2: `sleep 20; tmux capture-pane -p -t <pane> | grep -v '^\s*$' | tail -15`.
  Repeat at most 3 times. Still nothing → report "sent, no reply yet", move on.
- A reply that asks for mate's decision → §4: the leader answers; if this session is not
  the leader, bring the question to mate, once.

# 4. Put it on the record
Find the issue: the number in `$ARGUMENTS`, else the open issue in either repo whose
body `**From:**` names the other side and whose title matches. Then
`gh issue comment <N> [--repo <owner/target>] --body "Relayed to the <target> session: <one line>. Reply: <one line | none yet>. — <name>"`.
No issue → say so in one line; do not file one for a relay.

# 5. One line
`Relay → <target> via <peer|tmux|none>: sent · reply <yes|pending|none> · record <repo#N|none>.`
