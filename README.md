# td-fly

A lean work rhythm as a self-contained Claude Code plugin. Three skills, one hook.

- `/td-fly:close` — checkpoint a session: capture the core into a repo doc, fresh-eyes sweep, file only what clears the bar, commit, push, tend the backlog. Unattended; asks nothing.
- `/td-fly:mailbox` — cross-repo digest, both directions, one decision, one batch. Says "tell" when the other repo's session is live on this box.
- `protocol` — the cross-repo contract (issue marker, signing, who closes what, the live channel and the leader rule). Model-loaded, not typed.
- `hooks/` — at session start, one line if other repos have open issues filed into this one. Silent otherwise.

This folder is both the plugin and its marketplace: `.claude-plugin/marketplace.json` points at the public `mergodon/td-fly` repo.

## Install

```
/plugin marketplace add mergodon/td-fly
/plugin install td-fly@td-fly
```

## Deploy discipline

The marketplace pulls from GitHub, and updates are version-gated. A change reaches a box only through:

1. edit → 2. bump `version` in `.claude-plugin/plugin.json` → 3. commit → 4. push → 5. each box: `claude plugin update td-fly`. Left alone, auto-update (`autoUpdate` in `~/.claude/plugins/known_marketplaces.json`) writes it to disk up to ten minutes after the first message of the box's next interactive session.

A running session — the one that fetched the update included — keeps the text it loaded until `/reload-plugins`. `/td-fly:close` says so on its first line when the running and installed versions differ.
Frontmatter trap: `when_to_use` must be ONE plain scalar — a quoted comma list is invalid YAML and silently drops the whole frontmatter; `claude plugin validate .` catches it. The installed version is in `~/.claude/plugins/installed_plugins.json`. Tag the bumping commit `vX.Y.Z`; docs-only commits do not bump.

```
claude plugin validate .        # manifest, hooks, skills frontmatter
claude plugin details td-fly    # component inventory + token cost
```

## Files

```
.claude-plugin/plugin.json      manifest, version, license
.claude-plugin/marketplace.json this repo as its own marketplace
skills/close/SKILL.md           the checkpoint
skills/close/sweep.md           what the sweep subagent verifies, flags and leaves alone
skills/mailbox/SKILL.md         the digest
skills/protocol/SKILL.md        the cross-repo contract + live channel (user-invocable: false)
hooks/hooks.json                SessionStart → scripts/inbox.sh
scripts/inbox.sh                one line or nothing; exits 0 on every failure
```

## Cross-repo

A project lists its connected repos under `## Cross-repo` in its own `CLAUDE.md`; the protocol skill carries the shape and what the list scopes.
