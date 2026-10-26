# td-fly

A lean work rhythm as a self-contained Claude Code plugin.
- `contract.md` — the protocol, written once: what is kept, the record (GitHub issues),
  the channel (live sessions), the leader rule.
- `/td-fly:close` — checkpoint a session, unattended.
- `/td-fly:mailbox` — cross-repo digest, one decision.
- `/td-fly:relay` — one message to another repo's running session, outcome on the issue.

## Install

```
/plugin marketplace add mergodon/td-fly
/plugin install td-fly@td-fly
```

This folder is the plugin and its own marketplace; `source` points at the GitHub repo.

## Deploy — a change is not live until all five happen

1. Edit.
2. Bump `version` in `.claude-plugin/plugin.json` on the same commit. No bump → no box
   ever sees it: `claude plugin update` is version-gated.
3. Commit, tag `vX.Y.Z` on that commit, push with the tag.
4. On each box: `claude plugin marketplace update td-fly && claude plugin update td-fly`.
5. Restart the session. A running session keeps the skill text it started with.

Installed version: `~/.claude/plugins/installed_plugins.json`. Check: `claude plugin
validate .` and `claude plugin details td-fly` (token cost per skill).

## Files

| file | role |
|---|---|
| `contract.md` | the rules — §1 keep, §2 record, §3 channel, §4 leader, §5 rhythm |
| `skills/close/SKILL.md` | steps; loads `skills/close/sweep.md` for the sweep subagent |
| `skills/mailbox/SKILL.md` | steps and queries |
| `skills/relay/SKILL.md` | the channel executor |
| `references/issue-discipline.md` | the filing bar and the tending rules, shared by close and mailbox |

Skills point at the contract by section; a rule lives in one file only.
