---
name: task-pickup
description: Help the user decide what to work on next, or break a long-term goal into concrete next steps. Use whenever the user asks what to pick up, what to do next, what to tackle, or asks to break down, plan, or decompose a project or goal into actions. Triggers include "what should I pick up", "what's next", "what should I work on", "break down [goal]", "plan out [project]". Use it even when phrased casually.
---

# Task Pick-up & Breakdown

## Finding the files

The relevant project's context file (and any workstream files) are named in that folder's
`CLAUDE.md`/`AGENTS.md` manifest (`project_file`, `workstream_glob`); if there's no manifest,
glob `*.project.md` and `*.workstream-*.md`. Read fresh.

## Pick-up

Surface the Next concrete actions across the relevant projects, ranked by impact and
unblock-value — prefer actions that unblock others or hit a near deadline. Suggest one to
start with, and say why.

## Breakdown

Decompose the named goal into the next 3–5 concrete, sequenced actions, small enough to start
immediately. Write them into the project file's Next concrete actions section, showing the
change before saving.
