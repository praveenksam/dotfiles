# dotfiles

A keyboard-driven, terminal-first development environment for two kinds of machine:

- **macOS** — a MacBook on Apple Silicon running Tahoe. Full setup: tiling WM, custom menu bar, GUI terminal.
- **Linux servers** — headless Ubuntu 24.04 VPS boxes. Shell, editor, multiplexer and data tooling only.

One repo, one shell config, loaded conditionally per OS and per host.

## What's included

| Tool              | Purpose                            | macOS | Server |
| ----------------- | ---------------------------------- | :---: | :----: |
| Ghostty           | Terminal emulator                  |   ✓   |        |
| Aerospace         | Tiling window manager              |   ✓   |        |
| Sketchybar        | Custom menu bar                    |   ✓   |        |
| JankyBorders      | Window borders                     |   ✓   |        |
| zsh + Starship    | Shell and prompt                   |   ✓   |   ✓    |
| tmux              | Terminal multiplexer               |   ✓   |   ✓    |
| Neovim (LazyVim)  | Editor                             |   ✓   |   ✓    |
| Git               | Version control, multi-account SSH |   ✓   |   ✓    |
| uv                | Python toolchain                   |   ✓   |   ✓    |
| euporie + jupysql | Terminal notebooks and SQL cells   |   ✓   |   ✓    |
| dbt               | SQL transformation and testing     |   ✓   |   ✓    |
| Docker            | Containers                         |   ✓   |   ✓    |

---

## How multi-host works

`.zshrc` is a loader. The real config lives in `~/.config/zsh/` and is sourced in a fixed order:

```
common.zsh    →  works everywhere
data.zsh      →  works everywhere (uv, euporie, dbt)
cheat.zsh     →  works everywhere
darwin.zsh  |  linux.zsh          →  by `uname`
hosts/<hostname>.zsh              →  by `hostname -s`
zsh-autosuggestions
zsh-syntax-highlighting           →  must be last
```

Two mechanisms keep machines apart:

1. **Package selection.** Stow only what belongs on that machine — GUI packages are simply never stowed on a server.
2. **Conditional sourcing.** Within `.zshrc`, OS and host files load only when they match.

Every external tool call is guarded with `command -v`, so a missing binary degrades one alias rather than breaking the shell. That matters most during bootstrap, when the shell is needed and half the tools aren't installed yet.

Host files key off the short hostname. `hosts/cairn.zsh` loads only on the machine named `cairn`.

---

# Part 1 — macOS installation

Follow in order. All tools first, then clone and stow in one pass, then per-tool configuration that needs the tools present.

### Step 1 — Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Apple Silicon path setup is handled by the stowed `.zshrc`, so nothing to append manually. Verify:

```sh
brew doctor
```

### Step 2 — Install all tools

Add the required taps first:

```sh
brew tap FelixKratz/formulae
brew tap nikitabobko/tap
```

> Aerospace and Ghostty each live in their own tap, not the main cask repo. JankyBorders and Sketchybar share the FelixKratz tap.

CLI tools:

```sh
brew install stow git neovim tmux lazygit ripgrep fd node nvm uv \
             starship zsh-autosuggestions zsh-syntax-highlighting \
             fzf zoxide eza bat glow sketchybar borders fastfetch
```

GUI apps:

```sh
brew install --cask ghostty aerospace
```

Fonts:

```sh
brew install --cask font-jetbrains-mono-nerd-font font-sketchybar-app-font
```

> Both are required. `font-jetbrains-mono-nerd-font` is used by Ghostty, Starship, Sketchybar and Neovim. `font-sketchybar-app-font` provides the app icons in Sketchybar workspace pills. Without them you get broken squares and missing icons throughout.

Python data tooling, installed as uv tools rather than into a project:

```sh
uv tool install euporie
uv tool install dbt-postgres
uv tool install jupyter-core
```

### Step 3 — Clone and stow

Back up anything that would conflict:

```sh
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null
mv ~/.gitconfig ~/.gitconfig.bak 2>/dev/null
mv ~/.zshrc ~/.zshrc.bak 2>/dev/null
```

Clone:

```sh
git clone git@mygit:praveenksam/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Stow the macOS set:

```sh
stow zsh tmux ghostty sketchybar aerospace starship nvim git gh fastfetch
```

This symlinks from `~/dotfiles/<tool>/` into `~` and `~/.config/`.

> If you are **restowing** over an existing setup rather than installing fresh, use `stow --restow zsh`. Plain `stow` on an already-stowed package can leave stale symlinks behind when the directory structure has changed.

### Step 4 — Post-stow configuration

#### Ghostty

No setup required. Launch it and it picks up the stowed config.

#### Fonts

Open Font Book and confirm both are present:

- `JetBrainsMono Nerd Font Mono`
- `sketchybar-app-font`

If either is missing:

```sh
brew reinstall --cask font-jetbrains-mono-nerd-font font-sketchybar-app-font
```

#### Shell

Reload:

```sh
source ~/.zshrc
```

Optional Starship preset (pick one from [starship.rs/presets](https://starship.rs/presets)):

```sh
starship preset catppuccin-powerline -o ~/.config/starship.toml
```

> `zsh-syntax-highlighting` must be sourced last. The stowed `.zshrc` handles this — do not reorder the loader.

#### tmux — plugins

Clone TPM if not present:

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Start tmux and install:

```
Ctrl+a + I
```

> Capital `I`. Wait for it to finish before using tmux.

`tmux-resurrect` and `tmux-continuum` are enabled, so sessions survive reboots on both machines.

#### Aerospace

Launch from Spotlight, then grant permissions:

**System Settings → Privacy & Security → Accessibility → enable Aerospace**

> Without accessibility permissions Aerospace cannot manage windows.

#### Sketchybar

Download the icon map (not stowed — fetched fresh per machine):

```sh
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/latest/download/icon_map.sh \
  -o ~/.config/sketchybar/icon_map.sh
chmod +x ~/.config/sketchybar/icon_map.sh
```

Hide the native menu bar:

**System Settings → Control Center → Automatically hide and show the menu bar → Always**

Start the service:

```sh
brew services start sketchybar
```

> JankyBorders needs no service — Aerospace launches it via `after-startup-command` in `.aerospace.toml`.

##### ⚠️ Conflicting requirement: "Displays have separate Spaces"

Aerospace tiles more reliably with this **off**; Sketchybar's workspace pills expect it **on**. They genuinely conflict, so pick based on which you care about more:

- **Multi-monitor tiling matters most** → turn it **off**, accept degraded Sketchybar workspace display.
- **Sketchybar workspace pills matter most** → turn it **on**, accept Aerospace quirks across displays.

Setting lives at **System Settings → Desktop & Dock → Displays have separate Spaces**.

#### Git — multi-account

Set the email addresses:

```sh
nvim ~/dotfiles/git/.gitconfig          # name and default email
nvim ~/dotfiles/git/.gitconfig-work     # work email
nvim ~/dotfiles/git/.gitconfig-personal # personal email
```

Generate a key per account:

```sh
ssh-keygen -t ed25519 -C "personal@email.com" -f ~/.ssh/id_personal
ssh-keygen -t ed25519 -C "work@email.com" -f ~/.ssh/id_work
```

Create `~/.ssh/config`:

```
Host mygit
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_personal
  AddKeysToAgent yes
  UseKeychain yes

Host bizgit
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_work
  AddKeysToAgent yes
  UseKeychain yes
```

Add the public keys to the matching GitHub accounts:

```sh
cat ~/.ssh/id_personal.pub
cat ~/.ssh/id_work.pub
```

Clone with the right alias:

```sh
git clone git@mygit:username/repo.git     # personal
git clone git@bizgit:orgname/repo.git     # work
```

> The `includeIf` directives apply the correct email based on directory. Personal repos must live under `~/personal/`, work repos under `~/work/`, and server projects under `~/invest/`. Anywhere else falls through to the default identity.

#### Neovim

LazyVim installs plugins on first launch:

```sh
nvim
```

Then:

```
:MasonInstall html-lsp css-lsp powershell-editor-services
:TSUpdate
```

> The brogrammer colorscheme installs automatically on first launch. `dbtpal` provides dbt model running and a Telescope picker — see the DBT cheat section.

#### Node

```sh
nvm install --lts
nvm use --lts
```

#### Python

```sh
uv python install 3.12
uv python pin 3.12
```

#### Claude Code (optional)

```sh
npm install -g @anthropic-ai/claude-code
```

Three profiles are configured via `CLAUDE_CONFIG_DIR`: `claude-personal`, `claude-work`, `claude-invest`.

#### BMAD Method (optional, per project)

```sh
cd your-project
npx bmad-method@latest install
# select Claude Code when prompted
```

---

# Part 2 — Server installation

For a headless Ubuntu 24.04 VPS. Assumes the box is provisioned, a non-root user exists, and SSH key auth works.

**Prerequisite:** the macOS side must be committed and pushed first. The server clones this repo — if the config isn't pushed, there's nothing to clone.

### Step 1 — Copy the bootstrap script over

It does the cloning, so it has to arrive before the repo does:

```sh
# from the Mac
scp ~/dotfiles/scripts/bootstrap-server.sh <host>:~/
```

### Step 2 — Give the server GitHub access

```sh
ssh <host>
ssh-keygen -t ed25519 -C "<hostname>"
cat ~/.ssh/id_ed25519.pub          # add to GitHub

cat >> ~/.ssh/config <<'EOF'
Host mygit
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
EOF

ssh -T git@mygit                   # should greet you by username
```

> Generate a fresh key rather than copying the Mac's private key across. One machine can then be revoked without touching the other.

### Step 3 — Run the bootstrap

```sh
chmod +x ~/bootstrap-server.sh
./bootstrap-server.sh
```

It sets the hostname, installs apt packages, starship, glow, uv, the data stack, Claude Code, `postgres-mcp` and TPM, then clones this repo and stows the server set:

```sh
stow zsh tmux git starship nvim
```

Five packages. `sketchybar`, `aerospace`, `ghostty`, `fastfetch`, `gh` and `claude` are deliberately skipped.

> The hostname set here must match a file in `zsh/.config/zsh/hosts/`, or no host config loads. Rename both together if you change it.

### Step 4 — Manual steps

```sh
# 1. pick up zsh as default shell and the new PATH
exit && ssh <host>

# 2. tmux plugins
tmux new -As main
# Ctrl+a then I (capital)

# 3. nvim plugins on first launch
nvim

# 4. register a project kernel for euporie
cd ~/<project> && kernel-add <project>
```

### Step 5 — Place secrets

Never in the repo:

| Secret              | Location                              |
| ------------------- | ------------------------------------- |
| `POSTGRES_PASSWORD` | project `.env`                        |
| SMTP app password   | `~/.msmtp-pass` (chmod 600)           |
| `DBT_PASSWORD`      | exported from a file outside the repo |
| MCP `DATABASE_URI`  | the MCP server's own `env` block      |

### Step 6 — Verify

```sh
hostname -s        # must match a hosts/*.zsh filename
cheat              # cheatsheet renders
timers             # systemd timers
memory             # free-based version, not vm_stat
```

The tmux status bar is **red** on remote hosts and navy locally — the fastest guard against running something on the wrong machine. If it's navy on a server, `.tmux.conf` didn't restow.

---

## Repo structure

```
~/
├── work/           # Work projects and repos
├── personal/       # Personal projects and repos
├── inbox/          # Everything lands here first — process weekly
└── dotfiles/
    ├── zsh/
    │   ├── .zshrc                     # loader only
    │   └── .config/zsh/
    │       ├── common.zsh             # ls/ll/lt/lta, cat, claude profiles, fzf, zoxide
    │       ├── data.zsh               # kernel-*, euporie, dbt
    │       ├── cheat.zsh              # the cheat function
    │       ├── darwin.zsh             # brew, vm_stat memory, Tableau, thought pipeline
    │       ├── linux.zsh              # ss, free, systemd, apt
    │       └── hosts/
    │           └── cairn.zsh          # per-machine config
    ├── tmux/.tmux.conf
    ├── ghostty/.config/ghostty/
    ├── sketchybar/.config/sketchybar/
    ├── aerospace/.aerospace.toml
    ├── starship/.config/starship.toml
    ├── nvim/.config/nvim/
    ├── gh/.config/gh/
    ├── fastfetch/.config/fastfetch/
    ├── git/
    │   ├── .gitconfig
    │   ├── .gitconfig-work
    │   └── .gitconfig-personal
    └── scripts/
        └── bootstrap-server.sh
```

> Set Downloads and Screenshots to save into `~/inbox/` to stop them accumulating.

### Adding a new machine

1. Create `zsh/.config/zsh/hosts/<hostname>.zsh` with machine-specific aliases.
2. Commit and push.
3. Run `scripts/bootstrap-server.sh` on the new box, adjusting the hostname it sets.

---

## Quick reference

```sh
cheat              # full cheatsheet
cheat tmux         # tmux keys
cheat neovim       # neovim keys
cheat aerospace    # aerospace keys
cheat ipython      # kernels, euporie, SQL magics
cheat dbt          # dbt commands
cheat invest       # server project commands
cheat bmad         # BMAD commands
cheat claude       # Claude Code commands
cheat docker       # docker commands
```

---

## Updating

Pull and restow if the structure changed:

```sh
cd ~/dotfiles
git pull
# macOS
stow --restow zsh tmux ghostty sketchybar aerospace starship nvim git gh fastfetch
# server
stow --restow zsh tmux git starship nvim
```

Packages:

```sh
brew update && brew upgrade        # macOS
sudo apt update && sudo apt upgrade -y   # server (aliased to `update`)
uv tool upgrade --all
```

Plugins:

```
:Lazy update      # neovim
:TSUpdate         # treesitter
Ctrl+a + U        # tmux
```

---

## What does not belong in this repo

The `.gitignore` covers these, but worth stating plainly:

- **Claude Code runtime state** — `projects/`, `history.jsonl`, `plugins/`, caches, transcripts. Only `settings.json`, your own `skills/`, and `project-init.zsh` are worth versioning; marketplace plugins reinstall from `extraKnownMarketplaces`.
- **Secrets** — `.env`, `*.pem`, `*.key`, SSH private keys, `.msmtp-pass`, dbt `profiles.yml`.
- **Machine state** — `lazy-lock.json`, dbt `target/` and `logs/`, `gh/hosts.yml` (regenerate per machine with `gh auth login`).

Ignoring a file does not remove it from history. If something sensitive was already committed, it needs `git-filter-repo` and a force-push.
