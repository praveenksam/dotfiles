---
name: workstream-init
description: Create a new workstream inside a project, seeded with inherited context from the parent project rather than from a blank template. Use whenever the user wants to spin off, split out, or carve a sub-effort, sub-task, or chunk of work out of a project into its own separately tracked workstream. Triggers include "init workstream", "spin off [X] into a workstream", "make [X] its own workstream", "split out [X]". Use it whenever part of a project has grown big enough to track on its own, even if phrased casually.
---

# Workstream — Init

A workstream is a large sub-effort within a project, stored in the project folder. Its filename
follows the parent's `workstream_glob` (declared in the folder's `CLAUDE.md`/`AGENTS.md`),
i.e. `<project-slug>.workstream-<wsslug>.md` — prefix with the parent slug so the name is unique
(e.g. `roche-poc.workstream-user-remapping.md`). It shares the standard file structure and is
rolled up as one line in the parent project file's Workstreams section, which is the source of
truth for its own detail.

## Procedure — "init workstream [name] for [project]"

Do NOT copy a blank template. Instead:

1. Find the parent project file (via the folder's manifest `project_file`, else glob `*.project.md`)
   and read it, especially Context and Current Status. Note the parent slug for the filename.
2. Identify the Current Status items — in-flight work, blockers, open questions, next actions —
   that belong to this new workstream.
3. Create `<project-slug>.workstream-<wsslug>.md` in the project folder, seeded with:
   - **Context:** inherit the parent's client/stakeholders and goal, narrowed to this remit.
   - **Current Status:** move the relevant items here from the parent (verbatim first, then refine).
   - **Metadata:** today's date for Started and Last updated; carry priority/deadline if known.
4. In the parent: add a Workstreams line with a one-line rolled-up status and a pointer to the new
   file, and REMOVE the now-migrated detail from the parent's Current Status so it stays lean.
5. Show the seeded workstream file and the updated parent Workstreams section before saving.
