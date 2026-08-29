# Starship prompt
eval "$(starship init zsh)"

# Aliases
alias ls="eza --icons"
alias ll="eza --icons --long --git"
alias lla="eza --icons --long --git --all"
# alias lt="eza --icons --tree --level=2"
_lt_core() {
  local show_all=$1; shift
  local depth=2
  local perms=1 owner=1 group=0 octal=0 showtime=0
  local -a opts

  while (( $# )); do
    case "$1" in
      --)                     shift; break ;;
      -p|--no-permissions)    perms=0;    shift ;;
      -N|--no-user)           owner=0;    shift ;;
      -g|--group)             group=1;    shift ;;
      -o|--octal-permissions) octal=1;    shift ;;
      -t|--time)              showtime=1; shift ;;
      -*)                     opts+=("$1"); shift ;;
      *)  if [[ "$1" =~ ^[0-9]+$ ]]; then depth=$1; shift; else break; fi ;;
    esac
  done

  (( perms ))    || opts+=(--no-permissions)
  (( owner ))    || opts+=(--no-user)
  (( showtime )) || opts+=(--no-time)
  (( group ))    && opts+=(--group --smart-group)
  (( octal ))    && opts+=(--octal-permissions)

  local -a ig
  if (( show_all )); then
    opts+=(--all)
    [[ -n "${LT_IGNORE:-}" ]] && ig=(--ignore-glob "$LT_IGNORE")
  else
    ig=(--ignore-glob "${LT_IGNORE:-.git|node_modules|.venv|.DS_Store}")
  fi

  local dir="${1:-.}"
  [[ -d "$dir" ]] || dir=$(zoxide query -- "$@") || return 1

  command eza --tree --level="$depth" --long --total-size --header \
      --no-git --icons --group-directories-first --sort=size --reverse \
      "${ig[@]}" "${opts[@]}" -- "$dir"
}

lt()  { _lt_core 0 "$@" }
lta() { _lt_core 1 "$@" }

# claude setup
alias claude-personal="CLAUDE_CONFIG_DIR=~/.claude-personal claude"
alias claude-work="CLAUDE_CONFIG_DIR=~/.claude-work claude"
# Tableau Desktop debug shortcut
alias tableau-debug='open -a /Applications/Tableau\ Desktop\ \(Apple\ silicon\)\ 2026.1.app --args --webEngineArgs --remote-debugging-port=8696 & sleep 3 && open "http://localhost:8696" && echo "\n ✅ Tableau Desktop has been opened in debugging mode\n and the console is available at http://localhost:8696\n"'
# chordpro cli setup
alias chordpro="/Applications/ChordPro.app/Contents/MacOS/chordpro"
# glow specifically for markdown
alias md='glow -p'
# what's listening on which port
alias ports="lsof -iTCP -sTCP:LISTEN -P -n"
# docker services specifically  
alias services="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
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

# fzf
eval "$(fzf --zsh)"


function cat() {
  if [[ "$1" == *.md ]]; then
    glow -p "$1"
  else
    bat "$@"
  fi
}

function cheat() {
  local content=$(cat << 'EOF'
# CHEATSHEET

## TMUX  (prefix: Ctrl+a)
| Key                | Action                        |
|--------------------|-------------------------------|
| prefix + |         | Vertical split                |
| prefix + -         | Horizontal split              |
| prefix + r         | Reload config                 |
| prefix + [         | Scroll mode (q to exit)       |
| prefix + d         | Detach session                |
| prefix + $         | Rename session                |
| prefix + w         | View all windows              |
| prefix + n         | Next window                   |
| prefix + p         | Previous window               |
| prefix + ,         | Rename window                 |
| Ctrl+h/j/k/l       | Navigate panes / nvim splits  |
| t                  | New/attach tmux session       |

## NEOVIM
| Key                | Action                        |
|--------------------|-------------------------------|
| Space+e            | Toggle snacks explorer        |
| Space+ff           | Find files                    |
| Space+fg           | Live grep                     |
| Space+gg           | Lazygit                       |
| Space+gd           | Git diff current file         |
| ]h / [h            | Next/prev git hunk            |
| Space+db           | Toggle breakpoint             |
| Space+dc           | Start debugger                |
| gd                 | Go to definition              |
| gr                 | Go to references              |
| K                  | Hover docs                    |
| Space+ca           | Code actions                  |
| Space+wd           | Close split                   |
| Ctrl+h/j/k/l       | Navigate splits               |
| gt / gT            | Next / prev tab               |
| :tabc              | Close tab                     |

## SNACKS EXPLORER
| Key                | Action                        |
|--------------------|-------------------------------|
| Space+e            | Toggle explorer               |
| Enter / o          | Open file                     |
| |                  | Open in vertical split        |
| -                  | Open in horizontal split      |
| t                  | Open in new tab               |
| Ctrl+v             | Open in vertical split        |
| Ctrl+s             | Open in horizontal split      |
| a                  | Add file                      |
| d                  | Delete file                   |
| r                  | Rename file                   |
| y                  | Yank file                     |
| p                  | Paste file                    |
| m                  | Move file                     |
| Space+/            | Search in explorer            |
| ?                  | Show all keymaps              |
| q / Esc            | Close explorer                |

## AEROSPACE
| Key                | Action                        |
|--------------------|-------------------------------|
| Alt+1-5            | Switch workspace              |
| Alt+b/c/p          | Switch named workspace        |
| Alt+Shift+1-5      | Move window to workspace      |
| Alt+h/j/k/l        | Focus window                  |
| Alt+Shift+h/j/k/l  | Move window                   |
| Alt+Shift+m        | Fullscreen                    |
| Alt+Tab            | Previous workspace            |
| Alt+Shift+Tab      | Move to next monitor          |

## GIT
| Key                | Action                        |
|--------------------|-------------------------------|
| git@mygit          | Personal GitHub               |
| git@bizgit         | Work GitHub                   |
| gh auth switch     | Switch GitHub account         |

## ZSH
| Key                | Action                        |
|--------------------|-------------------------------|
| cd <name>          | Jump to directory (zoxide)    |
| Ctrl+r             | Fuzzy search history          |
| t                  | New/attach tmux session       |
| cheat              | Show this cheatsheet          |
| cheat <tool>       | Show section for tool         |
| lt                 | Visible files, 2 levels tree  |
| lta                | +hidden, 2 levels tree        |
| lt | lta n         | View n levels tree            |
| lt | lta ~/.       | View specific folder (home)   |
| lt | lta --git     | Extra eza flags pass through  |
| lt | lta -o        | Add octal permissions         |
| lt | lta -t        | Add the modified timestamp    |
| lt | lta -p        | Drop the permissions column   |
| lt | lta -N        | Drop the owner column         |
| lt | lta -g        | Add group only when differs   |

## SKETCHYBAR
| Command               | Action                     |
|-----------------------|----------------------------|
| sketchybar --reload   | Reload sketchybar          |

## HOMEBREW
| Command               | Action                     |
|-----------------------|----------------------------|
| brew update           | Update Homebrew            |
| brew upgrade          | Upgrade all packages       |
| brew list             | List installed packages    |

## IPYTHON
| Command                                   | Action                                                     |
|-------------------------------------------|------------------------------------------------------------|
| kernel-add                                | Create new kernal based on project name and add SQL capab. |
| kernel-ls                                 | List kernals available                                     |
| kernel-rm                                 | Remove kernal                                              |
                            ************ EUPORIE ************ 
| euporie-notebook                          | Create euporie notebook                                    |
| euporie-console                           | Access console in euporie                                  |
| euporie-preview                           | Preview notebook in euporie                                |
                      ************ MAGICS FOR IPYTHON ************ 
| %%sql                                     | To enter at start of cell to make it a SQL cell            |
| %load_ext sql                             | Load sql extension in Notebook via Python cell             |
| %sql postgresql://user:pass@host/mydb     | Login to SQL DB via Python cell                            |
| %sql                                      | Run SQL command within a Python cell to use result for code|
| !                                         | Prefix to run command as bash command                      |
| %%bash                                    | Magic to set whole cell as a bash cell                     |

## BMAD
| Command                                   | Action                                                     |
|-------------------------------------------|------------------------------------------------------------|
| npx bmad-method install                   | Init BMAD in current repo                                  |
| claude                                    | Open Claude Code                                           |

                  ************ MODULE 1: BMM (Product Development) ************ 
| /bmad-bmm-document-project                | Analyse existing codebase, produce docs (brownfield)       |
| /bmad-bmm-generate-project-context        | Scan codebase -> lean project-context.md                   |
| /bmad-bmm-quick-spec                      | Fast one-page spec for small changes                       |
| /bmad-bmm-quick-dev                       | Implement small tasks without full planning                |
| /bmad-bmm-correct-course                  | Handle mid-sprint pivots or major blockers                 |
                                **** Phase 1: Analysis ****
| /bmad-brainstorming                       | Facilitated brainistorming                                 |
| /bmad-bmm-market-research                 | Competitive landscape, customer/market trends              |
| /bmad-bmm-domain-research                 | Deep dive into domain terminology                          |
| /bmad-bmm-technical-research              | Tech feasibility, architecture options                     |
| /bmad-bmm-create-product-brief            | Crystallise product idea into brief                        |
                                **** Phase 2: Planning ****
| /bmad-bmm-create-prd                      | Produces the PRD                                           |
| /bmad-bmm-validate-prd                    | Checks PRD is comprehensive and cohesive                   |
| /bmad-bmm-edit-prd                        | Improve and enhance existing PRD                           |
| /bmad-bmm-create-ux-design                | UX patterns and design specifications                      |
                               **** Phase 3: Solutioning ****
| /bmad-bmm-create-architecture             | Documents all technical decisions                          |
| /bmad-bmm-create-epics-and-stories        | Breaks requirements into epics + stories                   |
| /bmad-bmm-check-implementation-readiness  | Validates PRD, UX, arch, stories are aligned               |
                             **** Phase 4: Implementation ****
| /bmad-bmm-sprint-planning                 | Generates sprint plan from epics                           |
| /bmad-bmm-sprint-status                   | Summarises sprint status, routes to next workflow          |
| /bmad-bmm-create-story                    | Prepares next story with full context                      |
| /bmad-bmm-dev-story                       | Executes story implementation + tests                      |
| /bmad-bmm-code-review                     | Adversarial review; routes back to dev if issues           |
| /bmad-bmm-retrospective                   | Post-epic review, lessons learned                          |
| /bmad-bmm-dev-story                       | Executes story implementation + tests                      |
| /bmad-bmm-code-review                     | Adversarial review; routes back to dev if issues           |

                ************ MODULE 2: CIS (Creative Innovation Suite) ************ 
| /bmad-cis-innovation-strategy             | Disruption opportunities, business model innovation        |
| /bmad-cis-problem-solving                 | Systematic methods for complex challenges                  |
| /bmad-cis-design-thinking                 | Human-centered, empathy-driven design process              |
| /bmad-cis-brainstorming                   | Structured brainstorming with proven techniques            |
| /bmad-cis-storytelling                    | Narrative frameworks for pitches and comms                 |

                    ************ MODULE 3: Core (Universal tools) ************ 
| /bmad-help                                | Shows next recommended workflow                            |
| /bmad-party-mode                          | Multi-agent discussion with all installed agents           |
| /bmad-index-docs                          | Lightweight doc index for fast LLM scanning                |
| /bmad-shard-doc                           | Split large docs into smaller section files (>500 lines)   |
| /bmad-editorial-review-prose              | Review prose for clarity and tone                          |
| /bmad-editorial-review-structure          | Propose cuts, reorganization, simplification               |
| /bmad-review-adversarial-general          | Find issues and weaknesses in any deliverable              |
| /bmad-review-edge-case-hunter             | Hunt unhandled edge cases in code or content               |

## CLAUDE CODE
| Command                        | Action                              |
|--------------------------------|-------------------------------------|
| claude                         | Start Claude Code session           |
| claude --continue              | Continue last session               |
| claude --resume                | Resume a specific session           |
| /init                          | Generate CLAUDE.md for project      |
| /clear                         | Clear current context               |
| /cost                          | Show token usage for session        |
| /doctor                        | Check Claude Code installation      |
| /help                          | Show available commands             |
| Ctrl+c                         | Cancel current operation            |
| Ctrl+d                         | Exit Claude Code                    |

## DOCKER
| Command                                      | Action                                      |
|----------------------------------------------|---------------------------------------------|
| docker ps                                    | List running containers                     |
| docker ps -a                                 | List all containers (incl. stopped)         |
| docker images                                | List local images                           |
| docker pull <image>                          | Pull image from registry                    |
| docker build -t <name> .                     | Build image from Dockerfile in current dir  |
| docker run -it <image>                       | Run container interactively                 |
| docker run -d -p <host>:<cont> <image>       | Run detached with port mapping              |
| docker run --rm -it <image> sh               | Run throwaway container with shell          |
| docker exec -it <container> sh               | Shell into running container                |
| docker stop <container>                      | Stop running container                      |
| docker rm <container>                        | Remove stopped container                    |
| docker rmi <image>                           | Remove image                                |
| docker logs <container>                      | View container logs                         |
| docker logs -f <container>                   | Follow container logs                       |
| docker inspect <container>                   | Detailed container info (JSON)              |
| docker cp <container>:<path> <dest>          | Copy file from container to host            |
| docker volume ls                             | List volumes                                |
| docker volume rm <volume>                    | Remove volume                               |
| docker network ls                            | List networks                               |
| docker system prune                          | Remove stopped containers + dangling images |
| docker system prune -a                       | Remove everything unused                    |
| docker compose up -d                         | Start services in background                |
| docker compose down                          | Stop and remove containers                  |
| docker compose down -v                       | Stop, remove containers + volumes           |
| docker compose logs -f                       | Follow logs for all services                |
| docker compose ps                            | List compose service status                 |
| docker compose exec <svc> sh                 | Shell into a compose service                |
| docker compose build                         | Rebuild images                              |
| docker compose restart <svc>                 | Restart a specific service                  |

EOF
)

  if [ -z "$1" ]; then
    echo "$content" | bat --style=plain --paging=always --language=markdown
  else
    local section=$(echo "$content" | awk -v section="## $(echo $1 | tr '[:lower:]' '[:upper:]')" '
      $0 ~ section { found=1; print; next }
      found && /^## / { exit }
      found { print }
    ')
    if [ -z "$section" ]; then
      echo "Section '$1' not found. Available sections:"
      echo "$content" | grep "^## " | sed 's/## /  /' | tr '[:upper:]' '[:lower:]'
    else
      echo "$section" | bat --style=plain --paging=never --language=markdown
    fi
  fi
}

# zoxide (smarter cd)
eval "$(zoxide init zsh --cmd cd)"
export PATH="/opt/homebrew/bin:$PATH"

# Syntax highlighting (must be last)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
