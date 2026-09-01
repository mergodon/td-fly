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

## `references/` — the criteria the commands load on demand

The commands stay short; the judgement lives in `references/`, loaded via
`${CLAUDE_PLUGIN_ROOT}` only at the step that needs it. Two files today:

| file | loaded by | what it settles |
|---|---|---|
| `issue-discipline.md` | `close` steps 3 + 4 | when an issue is worth filing, when to close one |
| `sweep-criteria.md` | `close` step 2 | what counts as doc/memory drift — and what not to flag |

Both are evidence-led rather than opinion: the thresholds in `issue-discipline.md` come
from a census of all 1534 issues across the 162 `mergodon` repos plus a hand
classification of 110 filings, and the file shows its working.

## Status

- [x] plugin + self-marketplace manifest
- [x] `/td-fly:close` (lean close ceremony)
- [x] `/td-fly:mailbox` (cross-repo issue digest)
- [x] cross-repo rendezvous convention (self-contained commands; `contract.md` = reference)
- [x] `references/` — filing bar + auto-close + sweep criteria (v0.10.0)

td-fly is feature-complete and lean by design. The agents/workflows playbook (a parked backlog of future ideas) was retired to keep it that way; it lives in git history if ever revived.
