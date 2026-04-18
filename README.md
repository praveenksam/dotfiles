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

## Installation

Follow these steps in order. All tools are installed first, then the dotfiles repo is cloned and stowed in one pass. Per-tool configuration steps that require the tools to already be installed (services, plugins, system settings) come last.

---

### Step 1 — Install Homebrew

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

---

### Step 2 — Install all tools

**Add required Homebrew taps first:**

```sh
brew tap FelixKratz/formulae
brew tap nikitabobko/tap
```

> Both Aerospace and Ghostty are in their own taps, not the main Homebrew cask repo. Both JankyBorders and Sketchybar share the FelixKratz tap.

**Install all CLI tools:**

```sh
brew install stow git neovim tmux lazygit ripgrep fd node nvm uv \
             starship zsh-autosuggestions zsh-syntax-highlighting \
             fzf zoxide eza bat glow sketchybar borders fastfetch
```

**Install GUI apps:**

```sh
brew install --cask ghostty aerospace
```

**Install fonts:**

```sh
brew install --cask font-jetbrains-mono-nerd-font font-sketchybar-app-font
```

> Both fonts are required. `font-jetbrains-mono-nerd-font` is used by Ghostty, Starship, Sketchybar and Neovim. `font-sketchybar-app-font` provides the app icons in Sketchybar workspace pills. Without these you will see broken squares and missing icons throughout the setup.

---

### Step 3 — Clone dotfiles and stow

Back up any existing configs that might conflict:

```sh
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null
mv ~/.gitconfig ~/.gitconfig.bak 2>/dev/null
```

Clone the repo:

```sh
git clone git@github.com:yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Stow everything at once:

```sh
stow zsh tmux ghostty sketchybar aerospace starship nvim git gh fastfetch
```

This creates symlinks from `~/dotfiles/<tool>/` to the expected locations in `~` and `~/.config/`. All tool configs are now active.

---

### Step 4 — Post-stow configuration

These steps require the tools to be installed and configs to be active.

#### Ghostty

No additional setup required. Launch Ghostty and it will use the stowed config.

---

#### Fonts — verify install

Open Font Book and confirm both of these are present:

- `JetBrainsMono Nerd Font Mono`
- `sketchybar-app-font`

If either is missing, reinstall:

```sh
brew reinstall --cask font-jetbrains-mono-nerd-font font-sketchybar-app-font
```

---

#### Shell

Set up Starship preset (optional — pick one from [starship.rs/presets](https://starship.rs/presets)):

```sh
starship preset catppuccin-powerline -o ~/.config/starship.toml
```

Reload your shell:

```sh
source ~/.zshrc
```

> `zsh-syntax-highlighting` must always be sourced last in `.zshrc`. The stowed `.zshrc` already handles this correctly — do not reorder.

---

#### tmux — install plugins

Start a tmux session:

```sh
tmux
```

Install all plugins with TPM:

```
Ctrl+a + I
```

> Capital `I`. Wait for the install to complete before using tmux.

Clone TPM if not already present:

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

---

#### Aerospace

Launch Aerospace from Spotlight or Finder, then grant accessibility permissions:

**System Settings → Privacy & Security → Accessibility → enable Aerospace**

> Without accessibility permissions Aerospace cannot manage windows.

---

#### Sketchybar

Download the icon map for app icons (not stowed — downloaded fresh per machine):

```sh
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/latest/download/icon_map.sh \
  -o ~/.config/sketchybar/icon_map.sh
chmod +x ~/.config/sketchybar/icon_map.sh
```

Enable the required system setting:

**System Settings → Desktop & Dock → Displays have separate Spaces → ON**

> Sketchybar will not work correctly without this setting enabled.

Hide the native macOS menu bar:

**System Settings → Control Center → Automatically hide and show the menu bar → Always**

Start sketchybar as a service:

```sh
brew services start sketchybar
```

> JankyBorders does not need a separate service — it launches automatically via Aerospace's `after-startup-command` in `.aerospace.toml`.

---

#### Git — multi-account setup

Update email addresses in the stowed gitconfig files:

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
cat ~/.ssh/id_personal.pub   # paste into personal GitHub SSH settings
cat ~/.ssh/id_work.pub       # paste into work GitHub SSH settings
```

Clone repos using the correct host alias:

```sh
git clone git@mygit:username/repo.git     # personal
git clone git@bizgit:orgname/repo.git     # work
```

> The gitconfig conditional includes automatically apply the correct email based on which directory the repo lives in. Personal repos must be cloned into `~/personal/` and work repos into `~/work/` for this to work correctly.

---

#### Neovim — first launch

Open Neovim — LazyVim will auto-install all plugins on first launch:

```sh
nvim
```

Wait for the plugin install to complete, then install remaining language servers:

```
:MasonInstall html-lsp css-lsp powershell-editor-services
```

Update treesitter parsers:

```
:TSUpdate
```

> The brogrammer colorscheme is installed automatically by LazyVim on first launch.

---

#### Node — install LTS

```sh
nvm install --lts
nvm use --lts
```

---

#### Python — pin a version

```sh
uv python install 3.12
uv python pin 3.12
```

---

#### Claude Code (optional)

```sh
npm install -g @anthropic-ai/claude-code
```

---

#### BMAD Method (optional, per project)

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

> Set Downloads and Screenshots to save to `~/inbox/` to prevent accumulation.

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

```
:Lazy update
:TSUpdate
```

Update tmux plugins:

```
Ctrl+a + U
```
