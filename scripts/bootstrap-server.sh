#!/usr/bin/env bash
# Bootstrap a fresh Ubuntu 26.04 LTS VPS to match the Mac environment.
# Run as the working user, after doc 01 (hardening) is done.
set -euo pipefail

HOSTNAME_WANTED="gotthard"
PYTHON_PIN="3.12" # dbt lags new Python releases; 26.04 defaults to 3.14

echo "==> Setting hostname (host-specific zsh config keys off this)"
sudo hostnamectl set-hostname "$HOSTNAME_WANTED"

# --- 26.04: reclaim RAM reserved by the default crash-dump tooling ---------
# kdump-tools and linux-crashdump ship by default on 26.04 server installs and
# reserve a few hundred MB via crashkernel. Useful for debugging kernel panics,
# wasteful on a small VPS. Remove unless you specifically want crash dumps.
echo "==> Removing kdump (reclaims reserved RAM)"
sudo apt remove -y kdump-tools linux-crashdump 2>/dev/null || true

# --- 26.04: /tmp is a tmpfs, i.e. RAM ------------------------------------
# Anything writing large intermediates to /tmp now consumes memory. Give the
# project its own on-disk scratch dir and point the standard vars at it.
echo "==> On-disk scratch dir (since /tmp is now RAM-backed)"
mkdir -p "$HOME/invest/tmp"
if ! grep -q 'INVEST_TMP' "$HOME/.profile" 2>/dev/null; then
  cat >>"$HOME/.profile" <<'EOF'

# /tmp is a tmpfs on Ubuntu 26.04+. Keep large intermediates on disk.
export INVEST_TMP="$HOME/invest/tmp"
export TMPDIR="$INVEST_TMP"
EOF
fi

echo "==> apt packages"
sudo apt update
sudo apt install -y \
  zsh git stow tmux curl unzip \
  neovim ripgrep fd-find bat fzf zoxide eza \
  zsh-autosuggestions zsh-syntax-highlighting \
  build-essential libpq-dev

# On 26.04 both eza and a current Neovim are in the repos, so no extra repos
# are needed. On Debian 12 they are not — see README for that path.

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

echo "==> Pinned Python $PYTHON_PIN (system default on 26.04 is 3.14)"
uv python install "$PYTHON_PIN"

echo "==> Terminal data stack, pinned to Python $PYTHON_PIN"
# uv ships its own interpreter, so these are unaffected by the system default.
# dbt: the `dbt` executable lives in dbt-core. Since dbt-core 1.8 the adapters
# were decoupled, so dbt-postgres alone provides no entrypoint and uv rejects
# it ("No executables are provided by package"). Install core, add the adapter.
uv tool install --python "$PYTHON_PIN" --with dbt-postgres dbt-core
uv tool install --python "$PYTHON_PIN" euporie
uv tool install --python "$PYTHON_PIN" jupyter-core # jupyter kernelspec

echo "==> Claude Code"
curl -fsSL https://claude.ai/install.sh | bash

echo "==> Postgres MCP server"
uv tool install --python "$PYTHON_PIN" postgres-mcp

echo "==> TPM for tmux plugins"
[ -d ~/.tmux/plugins/tpm ] ||
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "==> Clone dotfiles"
[ -d ~/dotfiles ] || git clone git@mygit:praveenksam/dotfiles.git ~/dotfiles

echo "==> Backing up distro default dotfiles that would block stow"
# Ubuntu ships its own ~/.zshrc (and sometimes others). Stow refuses to
# overwrite a real file and aborts the whole operation. Move them aside.
# NOT `stow --adopt` — that pulls the distro's file INTO the repo, replacing
# your version and staging it for commit.
cd "$HOME"
for f in .zshrc .tmux.conf .gitconfig .gitconfig-work .gitconfig-personal; do
  if [ -e "$f" ] && [ ! -L "$f" ]; then
    mv "$f" "$f.orig"
    echo "    moved $f -> $f.orig"
  fi
done
for f in .config/nvim .config/starship.toml .config/zsh; do
  if [ -e "$f" ] && [ ! -L "$f" ]; then
    mv "$f" "$f.orig"
    echo "    moved $f -> $f.orig"
  fi
done

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

echo
echo "==> Verifying the 26.04-specific fixes"
printf '  crashkernel reserved : %s\n' "$(cat /sys/kernel/kexec_crash_size 2>/dev/null || echo 0)"
printf '  /tmp filesystem      : %s\n' "$(findmnt -no FSTYPE /tmp 2>/dev/null || echo unknown)"
printf '  dbt                  : %s\n' "$(dbt --version 2>/dev/null | head -2 | tail -1 | xargs || echo 'check manually')"

cat <<'EOF'

Done. Remaining manual steps:

  1. Log out and back in (picks up zsh, PATH, and TMPDIR).
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

Note: crashkernel should read 0 above. If it still shows a reservation,
reboot to release it.

EOF
