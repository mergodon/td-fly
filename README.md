# td-fly

A lean work rhythm — two commands (`close`, `mailbox`) plus the cross-repo GitHub-issues protocol, shipped as a **self-contained** native Claude Code plugin (no `@import`, no symlink).

This folder is **both the plugin and its own marketplace** — `.claude-plugin/marketplace.json` lists the plugin and points its `source` at the public `mergodon/td-fly` github repo, so it installs on any machine with no extra repo.

## Install

```
/plugin marketplace add mergodon/td-fly
/plugin install td-fly@td-fly
```

Commands land namespaced under the plugin: `/td-fly:close`, `/td-fly:mailbox`.

Because the marketplace source is the GitHub repo (not this local folder), iterating on a command is: edit → commit → push → `/plugin marketplace update td-fly` → `/reload-plugins`. Local-only edits won't show until pushed.

## Cross-repo rendezvous

The plugin is **self-contained** — the `close` / `mailbox` commands carry their own protocol, so there is no `@import` and no symlink. `contract.md` stays as the canonical human-readable reference for the rhythm. A project only declares its cross-repo connections under a `## Cross-repo` heading in its own `CLAUDE.md`; that list scopes `/td-fly:mailbox` outbound.

## Status

- [x] plugin + self-marketplace manifest
- [x] `/td-fly:close` (lean close ceremony)
- [x] `/td-fly:mailbox` (cross-repo issue digest)
- [x] cross-repo rendezvous convention (self-contained commands; `contract.md` = reference)

td-fly is feature-complete and lean by design. The agents/workflows playbook (a parked backlog of future ideas) was retired to keep it that way; it lives in git history if ever revived.
