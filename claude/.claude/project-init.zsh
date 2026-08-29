#!/usr/bin/env zsh
# ============================================================
#  project-init — scaffold a new project in the CURRENT directory.
#  Creates:
#    <slug>.project.md   the canonical, self-identifying context file
#    AGENTS.md  -> symlink to it  (Codex, Cursor, Pi, Gemini CLI, ...)
#    CLAUDE.md  -> symlink to it  (Claude Code)
#  so the project context auto-loads on every prompt, in any tool.
#
#  Usage:  cd ~/work/clients
#          project-init "Roche POC"
# ============================================================

if [[ -z "$1" ]]; then
  echo "Usage: project-init \"Project Name\""
  exit 1
fi

# Shared work instructions (role, conventions). Imported into each project's CLAUDE.md
# if the file exists, so the work context loads ONLY in project folders — not in one-off
# script folders. Override by exporting PROJECT_INSTRUCTIONS.
PROJECT_INSTRUCTIONS="${PROJECT_INSTRUCTIONS:-$HOME/work/_shared/project-instructions.md}"

name="$1"
# slugify: lowercase, non-alphanumerics -> hyphens, trim leading/trailing hyphens
slug=$(echo "$name" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')
dir="$PWD/$slug"
today=$(date +%F)

if [[ -d "$dir" ]]; then
  echo "Project already exists: $dir"
  exit 1
fi

mkdir -p "$dir"
projfile="$slug.project.md"

cat > "$dir/$projfile" <<EOF
---
title: $name
type: project
---

# Project: $name

## Metadata
- **Status:** active
- **Priority:** medium
- **Owner:** me
- **Started:** $today
- **Last updated:** $today
- **Next deadline:** YYYY-MM-DD — [what is due]

## Context  (stable — write once, rarely change)
- **What this is:**
- **Client / stakeholders:**
- **Definition of done:**
- **Scope boundaries:**

## Current Status  (volatile — update every session)
- **Where things stand:**
- **In flight right now:**
- **Blocked on:**
- **Next concrete actions:**
  - [ ]
- **Open questions / decisions needed:**

## Risks & Blindspots
- **Known risks:**
- **Might be missing:**

## Workstreams
<!-- Add one with the workstream-init skill: "init workstream [name] for [project]".
     Each line: name — rolled-up status. -> $slug.workstream-[wsslug].md -->

## Decision Log  (append-only, newest first)
- $today: Project created.

## Key Links
-
EOF

# Tool-agnostic always-on context.
# AGENTS.md = content symlink (Codex, Cursor, Pi, Gemini CLI read it literally, every prompt).
ln -s "$projfile" "$dir/AGENTS.md"
# CLAUDE.md = (optional) shared work instructions + manifest + @import of the project content.
# The shared import is added ONLY if the instructions file exists, so non-project work never pulls it.
{
  [[ -f "$PROJECT_INSTRUCTIONS" ]] && echo "@$PROJECT_INSTRUCTIONS"
  echo "<!-- manifest: project_file=$projfile  workstream_glob=$slug.workstream-*.md -->"
  echo "@$projfile"
} > "$dir/CLAUDE.md"

echo "Created $dir/$projfile"
echo "  + AGENTS.md -> $projfile  (content symlink: Codex, Cursor, Pi, Gemini CLI, ...)"
if [[ -f "$PROJECT_INSTRUCTIONS" ]]; then
  echo "  + CLAUDE.md  (imports shared instructions + manifest + $projfile: Claude Code)"
else
  echo "  + CLAUDE.md  (manifest + @import of $projfile: Claude Code)"
  echo "    note: shared instructions not found at $PROJECT_INSTRUCTIONS — skipped import"
fi
