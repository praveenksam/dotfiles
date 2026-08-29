#!/usr/bin/env bash
# Bootstrap a fresh Ubuntu 24.04 VPS to match the Mac environment.
# Run as the 'invest' user, after doc 01 (hardening) is done.
set -euo pipefail

echo "==> Setting hostname (host-specific zsh config keys off this)"
sudo hostnamectl set-hostname invest-vps

echo "==> apt packages"
sudo apt update
sudo apt install -y \
  zsh git stow tmux curl unzip \
  neovim ripgrep fd-find bat fzf zoxide eza \
  zsh-autosuggestions zsh-syntax-highlighting \
  build-essential

# eza is in the Ubuntu 24.04 repos; if the install above failed for it,
# fall back to the upstream deb repo:
#   sudo mkdir -p /etc/apt/keyrings
#   wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
#     | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
#   echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
#     | sudo tee /etc/apt/sources.list.d/gierens.list
#   sudo apt update && sudo apt install -y eza

echo "==> starship (not in apt)"
curl -sS https://starship.rs/install.sh | sh -s -- -y

echo "==> glow (not in apt)"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key \
  | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" \
  | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install -y glow

echo "==> uv"
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "==> Claude Code"
curl -fsSL https://claude.ai/install.sh | bash

echo "==> TPM for tmux plugins"
[ -d ~/.tmux/plugins/tpm ] || \
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "==> Clone dotfiles"
[ -d ~/dotfiles ] || git clone git@mygit:praveenksam/dotfiles.git ~/dotfiles

echo "==> Stow server packages only"
cd ~/dotfiles
stow zsh tmux git starship nvim
# Deliberately NOT stowed on a server:
#   sketchybar aerospace ghostty fastfetch gh claude

echo "==> Default shell"
sudo chsh -s "$(which zsh)" "$USER"

cat <<'EOF'

Done. Remaining manual steps:

  1. Log out and back in (picks up zsh + PATH).
  2. Start tmux, press Ctrl+a then I to install plugins.
  3. Open nvim once to let LazyVim install plugins.
  4. Place secrets by hand (never in the repo):
       ~/invest/.env             POSTGRES_PASSWORD
       ~/.msmtp-pass             SMTP app password
       MCP DATABASE_URI          see doc 03
  5. Verify: `cheat invest` should show the VPS command table.

EOF
