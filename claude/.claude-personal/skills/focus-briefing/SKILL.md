---
name: focus-briefing
description: Produce a prioritized focus briefing across all of the user's projects — what is time-sensitive, what is at risk, what is blocked on them, and what blindspots they have. Use this whenever the user asks what to focus on, what is urgent, what they are forgetting or missing, or wants a status sweep across projects. Triggers include "focus", "what should I focus on", "what's urgent", "what am I missing", and any request to review or prioritize across multiple projects. Use it even when phrased casually rather than as a request for a "briefing".
---

# Focus Briefing

Reads every project's source-of-truth file and reports what deserves attention now.

## Files

Projects live as folders in the user's Drive projects directory; each has a `project.md`
(and optional `workstream-*.md`). Read all `project.md` files fresh. Roll up each project's
Workstreams section rather than opening every workstream file — open a workstream file only
if its rollup flags something that needs detail.

## Procedure

1. Read every `project.md`. Note Metadata (Priority, Next deadline, Last updated), Current
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
