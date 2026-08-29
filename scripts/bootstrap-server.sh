#!/usr/bin/env bash
# Bootstrap a fresh Ubuntu 24.04 VPS to match the Mac environment.
# Run as the 'invest' user, after doc 01 (hardening) is done.
set -euo pipefail

HOSTNAME_WANTED="gotthard"

echo "==> Setting hostname (host-specific zsh config keys off this)"
sudo hostnamectl set-hostname "$HOSTNAME_WANTED"

echo "==> apt packages"
sudo apt update
sudo apt install -y \
  zsh git stow tmux curl unzip \
  neovim ripgrep fd-find bat fzf zoxide eza \
  zsh-autosuggestions zsh-syntax-highlighting \
  build-essential libpq-dev

# eza is in the Ubuntu 24.04 repos; if that failed, use the upstream repo:
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
curl -fsSL https://repo.charm.sh/apt/gpg.key |
  sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" |
  sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install -y glow

echo "==> uv"
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"

echo "==> Terminal data stack (euporie, jupysql, dbt) as uv tools"
uv tool install euporie
uv tool install dbt-postgres
uv tool install jupyter-core # provides `jupyter kernelspec` for kernel-ls/rm

echo "==> Claude Code"
curl -fsSL https://claude.ai/install.sh | bash

echo "==> Postgres MCP server"
uv tool install postgres-mcp

echo "==> TPM for tmux plugins"
[ -d ~/.tmux/plugins/tpm ] ||
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "==> Clone dotfiles"
[ -d ~/dotfiles ] || git clone git@mygit:praveenksam/dotfiles.git ~/dotfiles

echo "==> Stow server packages only"
cd ~/dotfiles
stow zsh tmux git starship nvim
# Deliberately NOT stowed on a server:
#   sketchybar aerospace ghostty fastfetch gh claude

echo "==> dbt profiles skeleton (password filled in by hand)"
mkdir -p ~/.dbt
[ -f ~/.dbt/profiles.yml ] || cat >~/.dbt/profiles.yml <<'YAML'
invest:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      port: 5432
      user: claude_agent
      password: "{{ env_var('DBT_PASSWORD') }}"
      dbname: invest_db
      schema: invest
      threads: 4
YAML
chmod 600 ~/.dbt/profiles.yml

echo "==> Default shell"
sudo chsh -s "$(which zsh)" "$USER"

cat <<'EOF'

Done. Remaining manual steps:

  1. Log out and back in (picks up zsh + PATH).
  2. Start tmux, press Ctrl+a then I to install plugins.
  3. Open nvim once to let LazyVim install plugins, including dbtpal.
  4. Place secrets by hand (never in the repo):
       ~/invest/.env       POSTGRES_PASSWORD
       ~/.msmtp-pass       SMTP app password
       export DBT_PASSWORD in a file sourced outside the repo
       MCP DATABASE_URI    see doc 03
  5. Register the project kernel for euporie:
       cd ~/invest && kernel-add invest
  6. Verify: `cheat invest` and `cheat dbt` should print their tables.

EOF
