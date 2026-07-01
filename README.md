# td-fly

A lean work rhythm — two commands (`close`, `mailbox`) plus the cross-repo GitHub-issues protocol and the `@import` contract, shipped as a native Claude Code plugin.

This folder is **both the plugin and its own marketplace** — `.claude-plugin/marketplace.json` lists the plugin and points its `source` at the public `mergodon/td-fly` github repo, so it installs on any machine with no extra repo.

## Install

```
/plugin marketplace add mergodon/td-fly
/plugin install td-fly@td-fly
```

Commands land namespaced under the plugin: `/td-fly:close`, `/td-fly:mailbox`.

Because the marketplace source is the GitHub repo (not this local folder), iterating on a command is: edit → commit → push → `/plugin marketplace update td-fly` → `/reload-plugins`. Local-only edits won't show until pushed.

## The `@import` contract

`contract.md` is the one shared rhythm file. `install.sh` symlinks it to `~/.claude/td-fly.md`; each project adopts it with one line at the top of its `CLAUDE.md`:

```
@~/.claude/td-fly.md
```

The symlink points back into this repo, so a `git pull` here updates the contract in every project at once — zero drift. A project declares its cross-repo connections under a `## Cross-repo` heading in its own `CLAUDE.md`; that list scopes `/td-fly:mailbox` outbound.

## Status

- [x] plugin + self-marketplace manifest
- [x] `/td-fly:close` (lean close ceremony)
- [x] `/td-fly:mailbox` (cross-repo issue digest)
- [x] the `@import` contract / rendezvous convention (`contract.md` + `install.sh`)
- [ ] agents/workflows playbook (`/ship-watch` first)
