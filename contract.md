# td-fly — shared work contract

Imported into each project's `CLAUDE.md` via `@~/.claude/td-fly.md`. One file, every
repo points at it — edit once, it propagates everywhere. Keep it short. This is the
*interface* (how repos rendezvous), not a per-project rulebook — project structure is
yours to decide per repo.

## Rhythm
Work conversationally. No mandated doc scaffold — durable facts go to memory, leftover
TODOs go to GitHub issues. Two commands carry the rhythm:
- `/td-fly:close` — wrap a session: remember facts → fresh-eyes reality check → park TODOs to issues → commit → push.
- `/td-fly:mailbox` — cross-repo check: issues filed *into* this repo + issues this repo
  filed *into others*, as one digest.

## Work mode
Default: work in this repo only; commit and push when asked. Don't push or open PRs
unprompted. Prefer acting automatically on small, reversible things rather than asking —
and don't raise the same suggestion every session; mention it once, then let it rest.

## Cross-repo protocol
The one real interface contract — the rest is yours. When a project files an issue into
another repo (or reads ones filed into it):
- **Declare connected repos** in this project's own `CLAUDE.md` under a `## Cross-repo`
  heading — one `owner/name` slug per line. That list *is* the scope of `/td-fly:mailbox`
  outbound. Not listed = not seen, by design; declaring a new one is a one-line edit.
- **Every cross-repo issue body opens with** `**From:** <repo-name>` — the canonical
  sender marker, the only thing that identifies a filing as ours.
- **Sign every cross-repo comment and closure** with `— <repo-name>`. Never address
  GitHub usernames in cross-repo prose.
- `<repo-name>` = this repo's short name (the `name` in `owner/name`).
