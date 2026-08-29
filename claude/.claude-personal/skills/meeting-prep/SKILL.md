---
name: meeting-prep
description: Prepare the user for a specific meeting by pulling the relevant project context and producing a tight briefing — background, what is at stake, likely questions with suggested answers, and the one outcome to aim for. Use this whenever the user mentions preparing for, getting ready for, or walking into a meeting, call, review, or client conversation, even if they do not say the word "prep". Triggers include "meeting prep", "prep me for", "I have a call with", "getting ready for the [client] meeting".
---

# Meeting Prep

## Finding the files

Locate the relevant project's folder. Its context file is named in that folder's
`CLAUDE.md`/`AGENTS.md` manifest (`project_file`); if there's no manifest, glob `*.project.md`
in the folder. `CLAUDE.md`/`AGENTS.md` are pointers to the project file, not separate content.
Also read a meeting note in the folder if present. Read fresh.

## Procedure

Produce a tight, skimmable brief:

- **Background** — what this is and where it stands (from Context + Current Status).
- **What's at stake** in this meeting specifically.
- **Likely questions** the user will face, each with a suggested answer drawn from the project state.
- **Desired outcome** — the one thing to walk out having achieved.

If the relevant project is ambiguous, ask which one before proceeding.
