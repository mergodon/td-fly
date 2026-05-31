# td-fly

The lean rebuild of td-flow. Three things that earned their keep — `close`, `mailbox`, and the cross-repo GitHub-issues protocol — shipped as a native Claude Code plugin. Everything else from td-flow was cut.

This folder is **both the plugin and its own marketplace** — `.claude-plugin/marketplace.json` lists the plugin and points its `source` at the `mergodon/td-fly` github repo, so it installs with no extra repo.

## Test it locally

```
/plugin marketplace add ~/projects/td-fly   # register this folder as a marketplace
/plugin install td-fly@td-fly
/reload-plugins                             # after editing a command
```

Commands land namespaced under the plugin: `/td-fly:close`.

## Distribution (later)

For cross-machine use, push this folder to a **private** mergodon repo and `/plugin marketplace add mergodon/td-fly`. No public repo needed — Claude Code uses your git credentials.

## The `@import` contract

`contract.md` is the one shared rhythm file. `install.sh` symlinks it to `~/.claude/td-fly.md`; each project adopts it with one line at the top of its `CLAUDE.md`:

```
@~/.claude/td-fly.md
```

The symlink points back into this repo, so a `git pull` here updates the contract in every project at once — zero drift. A project declares its cross-repo connections under a `## Cross-repo` heading in its own `CLAUDE.md`; that list scopes `/td-fly:mailbox` outbound.

## Status: prototype

- [x] plugin + self-marketplace manifest
- [x] `/td-fly:close` (lean close ceremony)
- [x] `/td-fly:mailbox` (cross-repo issue digest — slimmed from td-flow's 284 lines)
- [x] the `@import` contract / rendezvous convention (`contract.md` + `install.sh`)
- [ ] agents/workflows playbook (`/ship-watch` first)
