---
description: Migrate THIS project off td-flow onto lean td-fly — swap the contract @import, PRESERVE load-bearing knowledge into repo docs, park backlog to issues, fold the cross-repo registry into CLAUDE.md, then remove the scaffold. Previews the whole plan first; destructive and one-way, runs only on confirm.
---

You are migrating this project from td-flow to td-fly: retire the old scaffold while preserving everything real **in the repo**. This is a big, **one-way, destructive** step — it deletes files and files issues. **Always present the full plan first and act only after the user confirms.** The scan pass changes nothing.

**The cardinal rule: load-bearing knowledge is NEVER routed to memory.** PROJECT.md / WORKWAY.md and friends hold invariants, gotchas, deploy discipline, architecture — facts that constrain the code. Those move to **repo docs**, versioned next to the code. Memory is only for working-style/preferences. Losing project knowledge to a private memory store is the failure this command must not cause.

# 1. Scan the footprint (read-only)
- **Contract import** — find a `@~/.claude/td-flow-contract.md` line in `CLAUDE.md`. Note every OTHER `@import` line too (e.g. `@~/.claude/td-rider-contract.md`) — those are NOT td-flow; never touch them.
- **State dir** — td-flow's dir is usually `.td-flow/`, but older projects use `.td/` (check `CLAUDE.md`'s own comment for which). Inventory everything in it: `PROJECT.md`, `STATE.md`, `WORKWAY.md`, `BACKLOG.md`, `work/`, `health.sh`, `voice-guide.md`, `frameworks/`, and anything else.
- **Existing `docs/`** — does the repo already have a `docs/` dir? That's the natural home for migrated knowledge. If not, plan a single `docs/PROJECT-NOTES.md`.
- **Project-real CLAUDE.md content** — anything below the import lines that's this project's own writing. It stays.
- `gh repo view --json name,owner` for the slug + `<project-name>`; `git status --short` to note a dirty tree.
- No `@td-flow-contract` import AND no state dir → "Not a td-flow project — nothing to migrate." Stop.
- `~/.claude/td-fly.md` missing → the td-fly contract isn't installed; stop and say to run td-fly's `install.sh` first.

# 2. Classify each piece — swap / PRESERVE / migrate / surface / drop
- **Contract import** → **swap** `@~/.claude/td-flow-contract.md` → `@~/.claude/td-fly.md`.
- **Load-bearing content in `PROJECT.md` + `WORKWAY.md`** (Hard rules / invariants, Hardened invariants, Architecture, deploy/build discipline, framework gotchas, Notes, Out-of-scope/known-limits) → **PRESERVE as repo docs.** Fold it into the existing `docs/` (match each section to the right file — invariants/architecture → `docs/ARCHITECTURE.md`, test/CI behavior → `docs/TESTING.md`, deploy → `docs/forge-deploy.md`, etc.) or into a single `docs/PROJECT-NOTES.md` if there's no `docs/`. **Never to memory.** Drop ONLY the pure scaffolding prose (locked-header boilerplate, "edit freely" comments, empty templates). When unsure whether a line is load-bearing, keep it — bias to preserve.
- **`BACKLOG.md`** → **park** open lines to GitHub issues (consolidate related ones; body opens `**From:** <project-name>`; right Issue Type).
- **Cross-repo registry** (`PROJECT.md § Cross-repo`) → **migrate** into a `## Cross-repo` heading in `CLAUDE.md`. Extract the `owner/name` slugs **whatever the source format** — a markdown table, bold-bullet list with prose, or plain lines all carry slugs; pull them out and write one slug per line. Keep a short "why we file here" note per slug if the source had one.
- **`STATE.md` + `work/`** → **surface**: if there's an in-flight piece (Topic ≠ idle, or an open `work/<slug>.md`), list it and let the user choose finish-now / park-to-issue / drop. Never silently delete in-flight work.
- **`health.sh`** → **keep** (move to repo root or `scripts/` — it's the input for a future `/ship-watch`).
- **`voice-guide.md` and other real docs** → **keep** as a plain repo doc (e.g. `docs/`).
- **`frameworks/`, empty STATE/PROJECT/WORKWAY scaffolding** with no real content → **drop**.
- **Everything outside the state dir and the one import line** → **untouched**.

# 3. Present the plan — ONE preview
```
flow-down plan — <project-name>  (<dirty-tree warning if any>)

SWAP     CLAUDE.md import: @td-flow-contract.md → @~/.claude/td-fly.md
         (preserved: <other @import lines>)
PRESERVE <state-dir>/PROJECT.md + WORKWAY.md load-bearing content → <docs targets>
         (sections: <invariants / architecture / deploy / notes …>)
MIGRATE  BACKLOG → N issues: <one line each>
         Cross-repo → CLAUDE.md ## Cross-repo: <slugs, or "none found">
SURFACE  in-flight: <piece + recommendation, or "none — idle">
KEEP     health.sh → <dest>; <other real docs → dest>
DROP     scaffold only: <list the boilerplate files going away>

Proceed? (yes / adjust). Nothing changes until you say go.
```

# 4. Execute on confirmation — PRESERVE and migrate BEFORE delete
1. Write the load-bearing knowledge into the repo docs (the preserve step) — this is the load-bearing action; do it first and verify the content landed.
2. Park BACKLOG → file the issues.
3. Write `## Cross-repo` into CLAUDE.md.
4. Move keepers (`health.sh`, other docs).
5. Swap the import line in CLAUDE.md.
6. `git rm -r <state-dir>` — only after 1–5 succeed and the preserved docs are confirmed present.
7. Commit `chore: migrate <project-name> from td-flow to td-fly`. Push only if the user asks or runs close.

# 5. Report
One block: knowledge preserved to <docs>, import swapped, N issues filed, cross-repo migrated, keepers moved, scaffold removed. Suggest `/td-fly:mailbox` to confirm the cross-repo registry reads right.

# Rules
- **Load-bearing knowledge never goes to memory.** It moves to repo docs, versioned with the code. This is the whole point of the command.
- **Preview-then-confirm, always.** One-way and deletes files — never act in the scan pass.
- **Preserve before delete.** Verify the migrated docs exist before `git rm` the scaffold. Bias to keep anything you're unsure about.
- **Never touch non-td-flow `@import`s** (td-rider etc.) or any code/docs outside the state dir.
- **Don't recreate td-flow under a new name.** Target = one import line + a `## Cross-repo` section + the project's knowledge living in `docs/` (or `CLAUDE.md`). Lean, but never lossy.
