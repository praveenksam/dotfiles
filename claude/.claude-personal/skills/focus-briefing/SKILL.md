---
name: focus-briefing
description: Produce a prioritized focus briefing across all of the user's projects — what is time-sensitive, what is at risk, what is blocked on them, and what blindspots they have. Use this whenever the user asks what to focus on, what is urgent, what they are forgetting or missing, or wants a status sweep across projects. Triggers include "focus", "what should I focus on", "what's urgent", "what am I missing", and any request to review or prioritize across multiple projects. Use it even when phrased casually rather than as a request for a "briefing".
---

# Focus Briefing

Reads every project's source-of-truth file and reports what deserves attention now.

## Finding the files

Each project is a folder. Inside, the project context file and its workstream files are named
in that folder's `CLAUDE.md`/`AGENTS.md` manifest (`project_file`, `workstream_glob`). For a
sweep across ALL projects, glob the projects directory for `*.project.md` (the project files)
and `*.workstream-*.md` (workstreams). `CLAUDE.md`/`AGENTS.md` are pointers to the project
file — never separate content. Read all project files fresh; roll up each project's Workstreams
section rather than opening every workstream file (open one only if its rollup needs detail).

## Procedure

1. Read every project file. Note Metadata (Priority, Next deadline, Last updated), Current
   Status (In flight, Blocked on, Open questions), Risks & Blindspots, and Workstreams rollups.
2. Report concisely, grouped:
   - **Time-sensitive** — ranked by Next deadline and Priority.
   - **At risk** — anything not updated recently relative to its pace, or stalled.
   - **Blocked on me** — where the user is the bottleneck (Blocked on + Open questions).
   - **Blindspots** — from each file's Risks & Blindspots, plus anything you notice that the
     user hasn't named. Be direct here, not reassuring.
3. Lead with the single most important thing. Keep it skimmable — this is a scan, not a report.

## Variant: blindspot focus ("what am I missing")

Same inputs, but lead with and expand the Blindspots group, and challenge stale or
long-blocked items harder.
