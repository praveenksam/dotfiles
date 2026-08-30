# Linux only. Equivalents for the macOS-specific bits.

# --- Ubuntu renames these binaries to avoid collisions ---
if command -v batcat >/dev/null && ! command -v bat >/dev/null; then
  bat() { command batcat "$@"; }
fi
if command -v fdfind >/dev/null && ! command -v fd >/dev/null; then
  fd() { command fdfind "$@"; }
fi

# --- what's listening (ss replaces lsof) ---
alias ports="ss -tlnp"
alias listening="ss -tlnp | sort -k4"

# --- memory (free replaces vm_stat) ---
alias memory='ps aux --sort=-%mem | head -25 | awk '\''
BEGIN {
  printf "%-10s %-35s %6s %10s\n", "USER", "PROCESS", "MEM%", "RAM"
  printf "%-10s %-35s %6s %10s\n", "----------", "-----------------------------------", "------", "----------"
}
NR>1 {
  split($11, path, "/")
  name = path[length(path)]
  printf "%-10s %-35s %5.1f%% %8.1fMB\n", $1, name, $4, $6/1024
}'\'' && echo "" && free -h'

# --- disk, since a VPS fills up quietly ---
alias disk="df -h / /home 2>/dev/null | grep -v tmpfs"

# --- systemd (see doc 07) ---
alias timers="systemctl list-timers --all"
alias failed="systemctl --failed"
function logs()  { journalctl -u "$1" -n "${2:-50}"; }
function logsf() { journalctl -u "$1" -f; }

# --- apt ---
alias update="sudo apt update && sudo apt upgrade -y"

# --- clipboard: fail loudly rather than silently on a headless box ---
if ! command -v xclip >/dev/null; then
  alias pbcopy='echo "no clipboard on this host — pipe to a file instead" >&2; false'
  alias pbpaste='echo "no clipboard on this host" >&2; false'
fi
