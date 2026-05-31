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

## Status: prototype

- [x] plugin + self-marketplace manifest
- [x] `/td-fly:close` (lean close ceremony)
- [ ] `/td-fly:mailbox` (cross-repo issue digest)
- [ ] the `@import` contract / rendezvous convention
- [ ] agents/workflows playbook (`/ship-watch` first)
