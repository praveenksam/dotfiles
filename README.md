# dotfiles

A keyboard-driven, terminal-first macOS development environment. Built for a MacBook with Apple Silicon running macOS Tahoe.

## What's included

| Tool             | Purpose                                |
| ---------------- | -------------------------------------- |
| Ghostty          | Terminal emulator                      |
| zsh + Starship   | Shell and prompt                       |
| tmux             | Terminal multiplexer                   |
| Neovim (LazyVim) | Editor                                 |
| Aerospace        | Tiling window manager                  |
| Sketchybar       | Custom menu bar                        |
| JankyBorders     | Window borders                         |
| Git              | Version control with multi-account SSH |

---

## Prerequisites

### 1. Install Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After install, add Homebrew to your PATH (Apple Silicon):

```sh
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Verify:

```sh
brew doctor
```

### 2. Install GNU Stow

```sh
brew install stow
```

---

## Installation

### Clone the repo

```sh
git clone git@github.com:yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### Stow all configs

```sh
stow zsh tmux ghostty sketchybar aerospace starship nvim git
```

This creates symlinks from `~/dotfiles/<tool>/` to the expected locations in `~` and `~/.config/`.

---

## Tool setup

### Ghostty

Install via Homebrew:

```sh
brew install --cask nikitabobko/tap/ghostty
```

> Ghostty is in the developer's own tap, not the main cask repository. `brew install --cask ghostty` will not work.

Config lands at `~/.config/ghostty/config` via stow.

---

### Fonts — JetBrainsMono Nerd Font

Required for Ghostty, Starship icons, Sketchybar, and Neovim:

```sh
brew install --cask font-jetbrains-mono-nerd-font
```

Also install the sketchybar app font for workspace app icons:

```sh
brew install --cask font-sketchybar-app-font
```

> Without these two fonts, you will see broken squares and missing icons throughout the setup.

---

### Shell

Install shell plugins and tools:

```sh
brew install starship zsh-autosuggestions zsh-syntax-highlighting fzf zoxide eza bat glow
```

Set up Starship preset (optional — pick one from [starship.rs/presets](https://starship.rs/presets)):

```sh
starship preset catppuccin-powerline -o ~/.config/starship.toml
```

> Note: `zsh-syntax-highlighting` must always be sourced **last** in `.zshrc`. The stowed `.zshrc` already handles this correctly.

---

### tmux

Install tmux and TPM (Tmux Plugin Manager):

```sh
brew install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Start a tmux session and install plugins:

```sh
tmux
```

Then inside tmux:

```
Ctrl+a + I
```

> Capital `I` — this installs all plugins defined in `.tmux.conf`. Wait for the install to complete before using tmux.

---

### Aerospace

Install via the developer's Homebrew tap:

```sh
brew install --cask nikitabobko/tap/aerospace
```

> Like Ghostty, Aerospace is not in the main Homebrew cask repository. The standard `brew install --cask aerospace` will fail.

After launching Aerospace:

1. Open **System Settings → Privacy & Security → Accessibility**
2. Grant Aerospace permissions

Config lands at `~/.aerospace.toml` via stow.

---

### JankyBorders

Install via FelixKratz's Homebrew tap:

```sh
brew tap FelixKratz/formulae
brew install borders
```

> Both `borders` and `sketchybar` are in the same tap. Adding the tap once covers both.

Borders launches automatically via Aerospace's `after-startup-command` in `.aerospace.toml`. No separate service needed.

---

### Sketchybar

Install via FelixKratz's tap (same tap as borders — skip `brew tap` if already added):

```sh
brew tap FelixKratz/formulae
brew install sketchybar
```

Download the icon map for app icons:

```sh
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/latest/download/icon_map.sh \
  -o ~/.config/sketchybar/icon_map.sh
chmod +x ~/.config/sketchybar/icon_map.sh
```

> The `icon_map.sh` is not stowed — it is downloaded fresh on each machine. This ensures you always get the latest app icon mappings.

Enable the required system setting:

**System Settings → Desktop & Dock → Displays have separate Spaces → ON**

> Sketchybar will not work correctly without this setting enabled.

Start sketchybar as a service:

```sh
brew services start sketchybar
```

Hide the native macOS menu bar:

**System Settings → Control Center → Automatically hide and show the menu bar → Always**

---

### Git — multi-account setup

Update the email addresses in the stowed gitconfig files:

```sh
nvim ~/dotfiles/git/.gitconfig          # set your name and default email
nvim ~/dotfiles/git/.gitconfig-work     # set your work email
nvim ~/dotfiles/git/.gitconfig-personal # set your personal email
```

Generate SSH keys for each account:

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

Add public keys to each GitHub account:

```sh
cat ~/.ssh/id_personal.pub   # add to personal GitHub SSH settings
cat ~/.ssh/id_work.pub       # add to work GitHub SSH settings
```

Clone repos using the correct host alias:

```sh
git clone git@mygit:username/repo.git     # personal
git clone git@bizgit:orgname/repo.git     # work
```

> The gitconfig conditional includes automatically apply the correct email based on directory. Personal repos must live under `~/personal/` and work repos under `~/work/` for this to work.

---

### Neovim

Install Neovim and dependencies:

```sh
brew install neovim lazygit ripgrep fd node
```

Back up any existing config:

```sh
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null
```

After stowing, open Neovim — LazyVim will auto-install all plugins on first launch:

```sh
nvim
```

Wait for the plugin install to complete, then install remaining language servers:

```sh
# Inside nvim
:MasonInstall html-lsp css-lsp powershell-editor-services
```

Update treesitter parsers:

```sh
# Inside nvim
:TSUpdate
```

> The brogrammer colorscheme (`marciomazza/vim-brogrammer-theme`) is installed automatically by LazyVim on first launch.

---

### Python tooling

Install uv:

```sh
brew install uv
```

Install a Python version:

```sh
uv python install 3.12
uv python pin 3.12
```

---

### Node tooling

Install nvm:

```sh
brew install nvm
```

Add to `~/.zshrc` (already included in stowed zshrc):

```sh
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
```

Install Node LTS:

```sh
nvm install --lts
nvm use --lts
```

---

### Claude Code

Install globally:

```sh
npm install -g @anthropic-ai/claude-code
```

---

### BMAD Method

BMAD is installed per project, not globally:

```sh
cd your-project
npx bmad-method@latest install
# Select Claude Code when prompted
```

---

## Folder structure

```
~/
├── work/           # Work projects and repos
├── personal/       # Personal projects and repos
├── inbox/          # Everything lands here first — process weekly
└── dotfiles/       # This repo
    ├── zsh/
    │   └── .zshrc
    ├── tmux/
    │   └── .tmux.conf
    ├── ghostty/
    │   └── .config/ghostty/config
    ├── sketchybar/
    │   └── .config/sketchybar/
    ├── aerospace/
    │   └── .aerospace.toml
    ├── starship/
    │   └── .config/starship.toml
    ├── nvim/
    │   └── .config/nvim/
    └── git/
        ├── .gitconfig
        ├── .gitconfig-work
        └── .gitconfig-personal
```

> Configure Downloads and Screenshots to save to `~/inbox/` to prevent accumulation.

---

## Quick reference

```sh
cheat              # full cheatsheet
cheat tmux         # tmux keys
cheat neovim       # neovim keys
cheat aerospace    # aerospace keys
cheat bmad         # BMAD commands
cheat claude       # Claude Code commands
```

---

## Updating

Pull latest dotfiles and restow if structure changed:

```sh
cd ~/dotfiles
git pull
stow --restow zsh tmux ghostty sketchybar aerospace starship nvim git
```

Update all Homebrew packages:

```sh
brew update && brew upgrade
```

Update Neovim plugins:

```sh
# Inside nvim
:Lazy update
:TSUpdate
```

Update tmux plugins:

```sh
# Inside tmux
Ctrl+a + U
```
