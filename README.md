# td-fly

A lean work rhythm as a self-contained Claude Code plugin. Three skills, one hook, one eval suite.

- `/td-fly:close` — checkpoint a session: capture the core into a repo doc, fresh-eyes sweep, file only what clears the bar, commit, push, tend the backlog. Unattended; asks nothing.
- `/td-fly:mailbox` — cross-repo digest, both directions, one decision, one batch. Says "tell" when the other repo's session is live on this box.
- `protocol` — the cross-repo contract (issue marker, signing, who closes what, the live channel and the leader rule). Model-loaded, not typed.
- `hooks/` — at session start, one line if other repos have open issues filed into this one. Silent otherwise.
- `evals/` — `claude plugin eval .` checks that plain phrases such as "any new issues?" start the mailbox and unrelated requests do not.

This folder is both the plugin and its marketplace: `.claude-plugin/marketplace.json` points at the public `mergodon/td-fly` repo.

## Install

```
/plugin marketplace add mergodon/td-fly
/plugin install td-fly@td-fly
```

## Deploy discipline

The marketplace pulls from GitHub, and `claude plugin update` is version-gated. A change reaches a box only through all five:

1. edit → 2. bump `version` in `.claude-plugin/plugin.json` → 3. commit → 4. push → 5. on each box `claude plugin update td-fly`, then **restart the session**.

A running session keeps the skill text it started with; after an update it runs the old text, silently. The installed version is in `~/.claude/plugins/installed_plugins.json`. Tag the bumping commit `vX.Y.Z`; docs-only commits do not bump.

```
claude plugin validate .        # manifest, hooks, skills frontmatter
claude plugin details td-fly    # component inventory + token cost
claude plugin eval .            # the suite (real model calls; --ablation none halves the cost)
```

## Files

```
.claude-plugin/plugin.json      manifest, version, license
.claude-plugin/marketplace.json this repo as its own marketplace
skills/close/SKILL.md           the checkpoint
skills/close/sweep.md           what the sweep subagent verifies, flags and leaves alone
skills/mailbox/SKILL.md         the digest; stamps its last run under ${CLAUDE_PLUGIN_DATA}
skills/protocol/SKILL.md        the cross-repo contract + live channel (user-invocable: false)
hooks/hooks.json                SessionStart → scripts/inbox.sh
scripts/inbox.sh                one line or nothing; exits 0 on every failure
evals/<case>/prompt.md          a user phrase; graders/ check whether the Skill tool fired
```

## Cross-repo

A project declares its connected repos in its own `CLAUDE.md` under `## Cross-repo`, one `owner/name` per line. That list scopes the mailbox's outbound side. The protocol skill carries the rest.
