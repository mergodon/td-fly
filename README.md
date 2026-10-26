# td-fly

Two skills for a lean work rhythm, as a self-contained Claude Code plugin. This folder is also its own marketplace.

- `/td-fly:close` — end a session: capture the core into a repo doc, fresh-eyes sweep, file only what clears the bar, commit, push, tend the backlog. Unattended, no questions.
- `/td-fly:mailbox` — cross-repo check: issues filed into this repo and issues this repo filed into others, one digest, one decision, one batch. Talks to a running peer session when one exists.
- Protocol between repos: an issue whose body opens `**From:** <repo>@<branch>`, signed `— <repo>`; the `## Cross-repo` list in a project's `CLAUDE.md` scopes its outbound view; each side closes its own.
- Memory belongs to the harness. Repo docs belong to the repo. The sweep keeps the line between them.

## Install

```
/plugin marketplace add mergodon/td-fly
/plugin install td-fly@td-fly
```

## Deploy a change

The marketplace pulls from GitHub, not from this folder. A change reaches a box only as a new version:

1. Edit. Bump `version` in `.claude-plugin/plugin.json` in the same commit. Tag it `vX.Y.Z`.
2. Push.
3. On each box: `claude plugin marketplace update td-fly && claude plugin update td-fly`.
4. Restart the session. A running session keeps the skill text it started with.

`claude plugin validate .` checks the manifests. `claude plugin details td-fly` shows the token cost.
