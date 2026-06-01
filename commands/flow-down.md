---
description: Migrate THIS project off td-flow onto lean td-fly — swap the contract @import, migrate the real .td-flow content (backlog → issues, cross-repo registry → CLAUDE.md, in-flight work surfaced), then remove the scaffold. Previews the whole plan first; destructive and one-way, runs only on confirm.
---

You are migrating this project from td-flow to td-fly: retire the old scaffold while preserving everything real. This is a big, **one-way, destructive** step — it deletes files and files issues. **Always present the full plan first and act only after the user confirms.** The scan pass changes nothing.

# 1. Scan the footprint (read-only)
- **Contract import** — find a `@~/.claude/td-flow-contract.md` line in `CLAUDE.md`. Note every OTHER `@import` line too (e.g. `@~/.claude/td-rider-contract.md`) — those are NOT td-flow; never touch them.
- **`.td-flow/` dir** — if present, inventory everything in it: `PROJECT.md`, `STATE.md`, `WORKWAY.md`, `BACKLOG.md`, `work/`, `health.sh`, `voice-guide.md`, `frameworks/`, and anything else.
- **Project-real CLAUDE.md content** — anything below the import lines that's this project's own writing (not td-flow boilerplate). It stays.
- `gh repo view --json name,owner` for the slug + `<project-name>` (short name); `git status --short` to note a dirty tree.
- No `@td-flow-contract` import AND no `.td-flow/` → "Not a td-flow project — nothing to migrate." Stop.
- `~/.claude/td-fly.md` missing → the td-fly contract isn't installed; stop and say to run td-fly's `install.sh` first.

# 2. Classify each piece — swap / migrate / surface / keep? / drop
- **Contract import** → **swap** `@~/.claude/td-flow-contract.md` → `@~/.claude/td-fly.md`.
- **`.td-flow/BACKLOG.md`** → **migrate**: open lines get parked to GitHub issues (same mechanics as `/td-fly:close` park — consolidate related lines, body opens `**From:** <project-name>`, right Issue Type).
- **`.td-flow/PROJECT.md § Cross-repo`** → **migrate**: fold the connected-repo slugs into a `## Cross-repo` heading in `CLAUDE.md` (the new outbound scope for `/td-fly:mailbox`, one `owner/name` per line).
- **`.td-flow/STATE.md` + `work/`** → **surface**: if there's an in-flight piece (Topic ≠ idle, or an open `work/<slug>.md`), list it and let the user choose finish-now / park-to-issue / drop. Never silently delete in-flight work.
- **`.td-flow/WORKWAY.md`, `voice-guide.md`, `health.sh`, other docs** → **keep-decision**, per file: fold into `CLAUDE.md` (small + durable), keep as a plain repo doc (e.g. move `voice-guide.md` → `docs/`), or drop (pure td-flow boilerplate, e.g. WORKWAY framework-awareness). Recommend `health.sh` → keep (it's the input for a future `/ship-watch`).
- **`frameworks/`, empty STATE/PROJECT/WORKWAY scaffolding** with no real content → **drop**.
- **Everything outside `.td-flow/` and the one import line** → **untouched** (code, other imports, project docs).

# 3. Present the plan — ONE preview
```
flow-down plan — <project-name>  (<dirty-tree warning if any>)

SWAP    CLAUDE.md import: @td-flow-contract.md → @~/.claude/td-fly.md
        (preserved: <other @import lines>)
MIGRATE BACKLOG → N issues: <one line each: type + title>
        Cross-repo → CLAUDE.md ## Cross-repo: <slugs, or "none found">
SURFACE in-flight: <piece + recommendation, or "none — idle">
KEEP?   <file → recommendation> (per WORKWAY/voice-guide/health.sh/etc.)
DROP    .td-flow/ scaffold: <list the boilerplate files going away>

Proceed? (yes / adjust). Nothing changes until you say go.
```

# 4. Execute on confirmation — migrate BEFORE delete
1. Park BACKLOG → file the issues (show results).
2. Write `## Cross-repo` into CLAUDE.md from PROJECT.md.
3. Apply keep-decisions (move/fold the docs the user kept).
4. Swap the import line in CLAUDE.md.
5. `git rm -r .td-flow` — only after 1–4 succeed.
6. Commit `chore: migrate <project-name> from td-flow to td-fly`. Push only if the user asks or runs close.

# 5. Report
One block: import swapped, N issues filed, cross-repo migrated, docs kept/moved/dropped, `.td-flow/` removed. Suggest `/td-fly:mailbox` to confirm the cross-repo registry reads right.

# Rules
- **Preview-then-confirm, always.** One-way and deletes files — never act in the scan pass.
- **Never touch non-td-flow `@import`s** (td-rider etc.) or any code/docs outside `.td-flow/`.
- **Migrate before delete.** Backlog and in-flight work are real — park them, don't drop them.
- **Don't recreate td-flow under a new name.** Target = one import line + a `## Cross-repo` section + whatever docs genuinely earn a plain-file home. Lean by default.
