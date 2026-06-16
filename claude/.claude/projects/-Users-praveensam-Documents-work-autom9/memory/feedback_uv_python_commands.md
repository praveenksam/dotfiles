---
name: Use uv for Python commands
description: All Python commands in the autom9 project must use uv, not python/python3 directly
type: feedback
originSessionId: 3a1cec98-4f9f-456a-9e4c-07268ede6f3a
---
Always use `uv run` for Python commands in this project. Never use `python`, `python3`, or `.venv/bin/python` directly.

**Why:** User explicitly requires uv as the Python runner for this project.

**How to apply:**
- Tests: `uv run pytest tests/ -v` (not `python -m pytest`)
- Scripts: `uv run python script.py` (not `python script.py`)
- Any other Python execution: prefix with `uv run`
- Run from `autom9-backend/` directory
