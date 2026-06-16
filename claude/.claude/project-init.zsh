#!/usr/bin/env zsh
# ============================================================
#  project-init — scaffold a new project folder with a project.md
#  Usage:  project-init "Tableau Server to Cloud Migration"
# ============================================================

# Where your projects live. Override by exporting PROJECTS_DIR in ~/.zshrc.
PROJECTS_DIR="${PROJECTS_DIR:-$HOME/Google Drive/My Drive/Projects}"

if [[ -z "$1" ]]; then
  echo "Usage: project-init \"Project Name\""
  exit 1
fi

name="$1"
# slugify: lowercase, non-alphanumerics -> hyphens, trim leading/trailing hyphens
slug=$(echo "$name" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')
dir="$PROJECTS_DIR/$slug"
today=$(date +%F)

if [[ -d "$dir" ]]; then
  echo "Project already exists: $dir"
  exit 1
fi

mkdir -p "$dir"
cat > "$dir/project.md" <<EOF
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
     Each line: name — rolled-up status. -> workstream-[slug].md -->

## Decision Log  (append-only, newest first)
- $today: Project created.

## Key Links
-
EOF

echo "Created $dir/project.md"
# Uncomment to open it automatically in your editor:
# "${EDITOR:-open}" "$dir/project.md"
