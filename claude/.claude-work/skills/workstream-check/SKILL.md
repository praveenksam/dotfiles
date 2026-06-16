---
name: workstream-check
description: Audit a project's workstreams for consistency and hygiene, catching drift between a parent project's rollup lines and the actual workstream files. Use whenever the user asks to check, audit, verify, or reconcile a project's workstreams, or wants to know whether their files are in sync — typically before a focus briefing or on a periodic review. Triggers include "check [project]", "check all", "are my workstreams in sync", "audit my projects", "reconcile the rollups".
---

# Workstream — Consistency Check

A workstream (`workstream-[slug].md`) is rolled up as one line in its parent `project.md`'s
Workstreams section. **When the parent rollup and a workstream file disagree, the workstream file
is the source of truth and the parent's line is what gets fixed.**

## Procedure — "check [project]" or "check all"

Audit parent/workstream sync and hygiene for the named project (or every project). Check for:

- **Dangling pointer** — a Workstreams line points to a missing file.
- **Orphan file** — a `workstream-*.md` with no line in the parent.
- **Status drift** — the parent rollup doesn't match the workstream's Current Status.
- **Lifecycle mismatch** — done/closing in the file but shown active in the parent (or vice versa).
- **Duplication** — an item appears in both the parent's Current Status and a workstream.
- **Staleness** — a file still marked active whose Last updated is old for its stated status.
  Report findings grouped by issue type, each with the specific fix. Offer to reconcile, but do not
  edit anything until the user confirms.
