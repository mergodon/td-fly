# td-fly

A lean work rhythm — two commands (`close`, `mailbox`) plus the cross-repo GitHub-issues protocol, shipped as a **self-contained** native Claude Code plugin (no `@import`, no symlink).

This folder is **both the plugin and its own marketplace** — `.claude-plugin/marketplace.json` lists the plugin and points its `source` at the public `mergodon/td-fly` github repo, so it installs on any machine with no extra repo.

## Install

```
/plugin marketplace add mergodon/td-fly
/plugin install td-fly@td-fly
```

Commands land namespaced under the plugin: `/td-fly:close`, `/td-fly:mailbox`.

Because the marketplace source is the GitHub repo (not this local folder), iterating on a command is: edit → commit → **push** → update → **restart the session**. Local-only edits never show; the marketplace pulls from GitHub.

Non-interactive equivalents exist and are scriptable — no slash commands needed:

```
claude plugin marketplace update td-fly
claude plugin update td-fly          # bumps the installed cache to the new version
claude plugin validate .             # checks plugin.json + marketplace.json
claude plugin details td-fly         # component inventory + projected token cost
```

⚠️ **A running session keeps the command text it started with.** `claude plugin update`
says "restart to apply" and means it — invoking `/td-fly:close` in a session started before
the update runs the *old* ceremony, silently. Verify with
`grep '^# ' ~/.claude/plugins/cache/td-fly/td-fly/<version>/commands/close.md` against the
repo when behaviour looks a version behind. Note the cache keeps every version side by
side, so `ls | tail -1` sorts `0.9.0` after `0.13.0` — read the version from
`~/.claude/plugins/installed_plugins.json` instead.

## Cross-repo rendezvous

`contract.md` is the canonical reference for the rhythm and owns the architecture explanation. A project declares its cross-repo connections under a `## Cross-repo` heading in its own `CLAUDE.md`; that list scopes `/td-fly:mailbox` outbound.

## `references/` — the criteria the commands load on demand

The commands stay short; the judgement lives in `references/`, loaded via
`${CLAUDE_PLUGIN_ROOT}` only at the step that needs it. Two files today:

| file | loaded by | what it settles |
|---|---|---|
| `issue-discipline.md` | `close` steps 3 + 5 | when an issue is worth filing, when to close one |
| `sweep-criteria.md` | `close` step 2 | what counts as doc/memory drift — and what not to flag |

Both are evidence-led rather than opinion: the thresholds in `issue-discipline.md` come
from a census of all 1534 issues across the 162 `mergodon` repos plus a hand
classification of 110 filings, and the file shows its working.

## Status

- [x] plugin + self-marketplace manifest
- [x] `/td-fly:close` (lean close ceremony)
- [x] `/td-fly:mailbox` (cross-repo issue digest)
- [x] cross-repo rendezvous convention (self-contained commands; `contract.md` = reference)
- [x] `references/` — filing bar, sweep criteria, evidence-based closing (v0.11.0)
- [x] agent files `Bug`/`Task` only — `Idea` and `Epic` are the owner's to create (v0.12.0)
- [x] `close` step 5 tends the backlog: auto-type, evidence-close, one batched HIL (v0.13.0)

Lean by design — but not frozen. The `references/` split is a deliberate, bounded exception: judgement that would bloat a command file lives in a file loaded only by the step that needs it, so the always-on cost stays ~143 tokens (measure it with `claude plugin details td-fly`). The agents/workflows playbook (a parked backlog of future ideas) was retired and lives in git history if ever revived.
