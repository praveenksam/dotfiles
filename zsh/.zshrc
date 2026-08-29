# ~/.zshrc — loader only. Real config lives in ~/.config/zsh/
# Order matters: common -> os -> host -> autosuggestions -> syntax highlighting last.

ZSH_CONFIG="${HOME}/.config/zsh"

# --- Homebrew (macOS) must come before anything that uses brew binaries ---
if [[ "$(uname)" == "Darwin" && -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- Local bins (uv, claude, cargo, starship) ---
export PATH="$HOME/.local/bin:$PATH"

# --- Prompt ---
command -v starship >/dev/null && eval "$(starship init zsh)"

# --- Shared config ---
[[ -f "$ZSH_CONFIG/common.zsh" ]] && source "$ZSH_CONFIG/common.zsh"
[[ -f "$ZSH_CONFIG/data.zsh"   ]] && source "$ZSH_CONFIG/data.zsh"
[[ -f "$ZSH_CONFIG/cheat.zsh"  ]] && source "$ZSH_CONFIG/cheat.zsh"

# --- OS-specific ---
case "$(uname)" in
  Darwin) [[ -f "$ZSH_CONFIG/darwin.zsh" ]] && source "$ZSH_CONFIG/darwin.zsh" ;;
  Linux)  [[ -f "$ZSH_CONFIG/linux.zsh"  ]] && source "$ZSH_CONFIG/linux.zsh"  ;;
esac

# --- Host-specific (matches short hostname) ---
HOST_CONFIG="$ZSH_CONFIG/hosts/$(hostname -s).zsh"
[[ -f "$HOST_CONFIG" ]] && source "$HOST_CONFIG"

# --- Autosuggestions (installed via brew but never sourced in the old .zshrc) ---
for p in \
  /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
do
  [[ -f "$p" ]] && source "$p" && break
done

# --- Syntax highlighting MUST be last ---
for p in \
  /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
do
  [[ -f "$p" ]] && source "$p" && break
done
