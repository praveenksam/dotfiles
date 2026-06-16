---
name: Use uv for Python commands
description: Always use uv run for Python/pytest commands in this project, never python/python3 directly
type: feedback
originSessionId: 226d6597-0675-48a2-8610-fd43e59139f4
---
Always use `uv run <command>` (e.g. `uv run pytest`) for running Python commands in this project. Do NOT use `python`, `python3`, or bare `pytest`.

**Why:** User explicitly requested it. The project uses uv as its Python environment manager; the system python3 doesn't have project dependencies installed.

**How to apply:** Any time you need to run pytest, a Python script, or any Python tool in the autom9 project, prefix with `uv run`.
