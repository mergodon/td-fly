# td-fly contract

The protocol. Written once, here. Skills execute it and point at a section by number;
they never restate it. Project structure is the repo's own business — this is only the
interface between sessions and between repos.

## §1 What is kept, and where
- **Repo doc** — the few facts that constrain the code: invariants, deploy discipline,
  the gotcha that bit, the decision that holds. Nearest file wins (a module's own
  `CLAUDE.md` over the root one). Rules for a write:
  1. Replace, never append. A new rule takes the place of the line it changes; the old
     rule, the date and the quote go in the commit message.
  2. Point at the executable truth. If `--help`, a config file or a script header carries
     the fact, the doc gets a pointer, not a copy.
  3. No war stories. The rule stays; the incident lives in git.
  4. A `CLAUDE.md` over 200 lines is drift.
- **Memory** belongs to the harness (auto memory). td-fly never writes it. A fact that
  governs code and sits in memory is drift — move it to a repo doc.
- **Neither** → not written down. Transcripts and git are the archive.

## §2 The record — a GitHub issue
Durable, signed, readable by someone who saw nothing else.
- Body opens `**From:** <repo>@<branch>` — `<repo>` is the short name from
  `owner/name`, `<branch>` from `git branch --show-current`, `@main` included. No marker
  = hand-filed. The branch is a label, never a filter.
- Every comment and closure ends `— <repo>`. Never address GitHub logins.
- Each side closes its own. An inbound issue closes here on commit evidence. An outbound
  issue is theirs; the one reach into another repo is **withdraw**, and it means the
  premise is dead, not that it shipped.
- `## Cross-repo` in this repo's `CLAUDE.md`, one `owner/name` per line, is the outbound
  scope. Not listed = not seen. Widen it by editing the list.
- Types: the agent files **Bug** or **Task**. `Idea` and `Epic` are mate's.
- What earns one, what ends one: `references/issue-discipline.md`.

## §3 The channel — two live sessions, now
The record stays the record. The channel is faster, and optional. Try in order, stop at
the first that works:
1. **Peer session** — `ListAgents` lists the Claude sessions on this box with their tmux
   pane. `SendMessage({to: "<name>", message: "..."})`. A send proves delivery to the
   session, not that it read it.
2. **tmux pane** — only when the peer is not a listed session:
   `tmux send-keys -t <session> -l "<text>" && tmux send-keys -t <session> Enter`, then
   `tmux capture-pane -p -t <session> | tail -20` to read.
3. **None** — the issue alone. tmux and peers are often absent; absence is never an error.

Every exchange on the channel ends on the record: the outcome, as a signed comment on
the issue, so a reader of the issue alone knows what happened.

## §4 Leader
Two sessions on one problem: mate names the **leader** once. The leader relays mate's
decisions and owns the issue thread. The follower works on without waiting on mate and
reports back on the channel. A relayed message opens
`from <repo> session (mate's words: "<quote>")`. No leader named → ask mate once; until
then, both sides only report, neither decides for the other.

## §5 Rhythm
- `/td-fly:close` — checkpoint a session: capture (§1) → fresh-eyes sweep → file what
  clears the bar (§2) → commit, push → tend the backlog. Unattended. Starts no new work.
- `/td-fly:mailbox` — one digest of inbound + outbound records (§2), one decision, one
  batch. Uses the channel (§3) when the other side is running here.
- `/td-fly:relay` — one message over the channel (§3), outcome on the record.
- Work mode: this repo only; commit freely, push when done, no PRs. Act on the small and
  reversible; ask once for the destructive. Say a suggestion once, then let it rest.
