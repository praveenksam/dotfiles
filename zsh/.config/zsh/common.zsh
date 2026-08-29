# Config that works identically on macOS and Linux.

# --- eza listing ---

if command -v eza >/dev/null; then
  alias ls="eza --icons"
  alias ll="eza --icons --long --git"
  alias lla="eza --icons --long --git --all"
fi

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

# --- markdown ---
command -v glow >/dev/null && alias md='glow -p'

# --- docker (identical on both) ---
alias services="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"

# --- cat: glow for markdown, bat otherwise, plain cat as fallback ---
function cat() {
  if [[ "$1" == *.md ]] && command -v glow >/dev/null; then
    glow -p "$1"
  elif command -v bat >/dev/null; then
    bat "$@"
  else
    command cat "$@"
  fi
}

# --- Claude config profiles ---
alias claude-personal="CLAUDE_CONFIG_DIR=~/.claude-personal claude"
alias claude-work="CLAUDE_CONFIG_DIR=~/.claude-work claude"
alias claude-invest="CLAUDE_CONFIG_DIR=~/.claude-invest claude"

# --- tmux: attach if exists, create if not ---
alias t="tmux new -As main"

# --- fzf ---
command -v fzf >/dev/null && eval "$(fzf --zsh)"

# --- zoxide (smarter cd) — must load before lt/lta, which call zoxide query ---
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd cd)"
