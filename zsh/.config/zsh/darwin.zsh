# macOS only. Carried over verbatim from your .zshrc.

# Tableau Desktop debug shortcut
alias tableau-debug='open -a /Applications/Tableau\ Desktop\ \(Apple\ silicon\)\ 2026.1.app --args --webEngineArgs --remote-debugging-port=8696 & sleep 3 && open "http://localhost:8696" && echo "\n ✅ Tableau Desktop has been opened in debugging mode\n and the console is available at http://localhost:8696\n"'

# chordpro cli setup
alias chordpro="/Applications/ChordPro.app/Contents/MacOS/chordpro"

# what's listening on which port
alias ports="lsof -iTCP -sTCP:LISTEN -P -n"

# combined — ports + process name
alias listening="lsof -iTCP -sTCP:LISTEN -P -n | awk 'NR==1 || \$1 != \"rapportd\"' | sort -k9"

# memory consumed
alias memory='ps aux | sort -rk4 | head -25 | awk '\''
BEGIN {
  printf "%-8s %-35s %6s %10s\n", "USER", "PROCESS", "MEM%", "RAM"
  printf "%-8s %-35s %6s %10s\n", "--------", "-----------------------------------", "------", "----------"
}
{
  split($11, path, "/")
  name = path[length(path)]
  printf "%-8s %-35s %5.1f%% %8.1fMB\n", $1, name, $4, $6/1024
}'\'' && echo "" && vm_stat | awk '\''
BEGIN { page=16384 }
/Pages active/                 { active=$3 }
/Pages inactive/               { inactive=$3 }
/Pages wired/                  { wired=$4 }
/Pages free/                   { free=$3 }
/Pages occupied by compressor/ { compressed=$5 }
END {
  used   = (active + wired + compressed) * page / 1073741824
  inactive_gb = inactive * page / 1073741824
  free_gb  = free * page / 1073741824
  total  = used + inactive_gb + free_gb
  printf "%-12s %6.1f GB\n", "Used:",      used
  printf "%-12s %6.1f GB\n", "Inactive:",  inactive_gb
  printf "%-12s %6.1f GB\n", "Free:",      free_gb
  printf "%-12s %6.1f GB\n", "Total:",     total
}'\'''

# ipython kernel in terminal setup
# Register current project's uv venv as a Jupyter kernel
kernel-add() {
  local name="${1:-$(basename $PWD)}"
  local pyver=$(uv run python --version 2>&1 | awk '{print $2}')
  uv add --dev ipykernel
  uv add --dev jupysql
  uv run python -m ipykernel install --user \
    --name "$name" \
    --display-name "$name ($pyver)"
  echo "✓ Kernel '$name' registered for Python $pyver"
}

# Remove a registered kernel
kernel-rm() {
  jupyter kernelspec uninstall "$1"
}

# List all kernels
kernel-ls() {
  jupyter kernelspec list
}

# projects workflow
export PROJECTS_DIR="$HOME/Google Drive/My Drive/Projects"
alias project-init="~/.claude/project-init.zsh"

# Thinking-writing workflow
## Add a new thought
alias think='uv run --project ~/Documents/personal/Local\ AI\ Thought\ Partner/python-thought-pipeline ~/Documents/personal/Local\ AI\ Thought\ Partner/python-thought-pipeline/pipeline.py add'
## List all thoughts saved
alias thoughts='uv run --project ~/Documents/personal/Local\ AI\ Thought\ Partner/python-thought-pipeline ~/Documents/personal/Local\ AI\ Thought\ Partner/python-thought-pipeline/pipeline.py list'
## Syntheiize from my thoughts and play back to me - slow due to big model
alias synthesize='uv run --project ~/Documents/personal/Local\ AI\ Thought\ Partner/python-thought-pipeline ~/Documents/personal/Local\ AI\ Thought\ Partner/python-thought-pipeline/pipeline.py synthesize'
## Have a dialogue against ideas
alias reflect='uv run --project ~/Documents/personal/Local\ AI\ Thought\ Partner/python-thought-pipeline ~/Documents/personal/Local\ AI\ Thought\ Partner/python-thought-pipeline/pipeline.py dialogue'
function tlist() {
  if [ -n "$1" ]; then
    uv run --project ~/Documents/personal/Local\ AI\ Thought\ Partner/python-thought-pipeline ~/Documents/personal/Local\ AI\ Thought\ Partner/python-thought-pipeline/pipeline.py list --tag "$1"
  else
    uv run --project ~/Documents/personal/Local\ AI\ Thought\ Partner/python-thought-pipeline ~/Documents/personal/Local\ AI\ Thought\ Partner/python-thought-pipeline/pipeline.py list
  fi
}

function tsynth() {
  if [ -n "$1" ]; then
    uv run --project ~/Documents/personal/Local\ AI\ Thought\ Partner/python-thought-pipeline ~/Documents/personal/Local\ AI\ Thought\ Partner/python-thought-pipeline/pipeline.py synthesize --tag "$1"
  else
    uv run --project ~/Documents/personal/Local\ AI\ Thought\ Partner/python-thought-pipeline ~/Documents/personal/Local\ AI\ Thought\ Partner/python-thought-pipeline/pipeline.py synthesize
  fi
}

# --- SSH shortcut to the VPS ---
alias vps="ssh cairn"
