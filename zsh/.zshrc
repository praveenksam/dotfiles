# Starship prompt
eval "$(starship init zsh)"

# Aliases
alias ls="eza --icons"
alias ll="eza --icons --long --git"
alias lla="eza --icons --long --git --all"
alias lt="eza --icons --tree --level=2"
alias chordpro="/Applications/ChordPro.app/Contents/MacOS/chordpro"

# Autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# fzf
eval "$(fzf --zsh)"

# zoxide (smarter cd)
eval "$(zoxide init zsh --cmd cd)"

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

## BMAD
| Command                        | Action                              |
|--------------------------------|-------------------------------------|
| npx bmad-method@latest install | Init BMAD in current repo           |
| claude                         | Open Claude Code                    |
| /workflow-init                 | Initialize BMAD workflow            |
| /workflow-status               | Check phase progress                |
| /product-brief                 | Phase 1: define scope               |
| /prd                           | Phase 2: write requirements doc     |
| /architecture                  | Phase 3: design system              |
| /sprint-planning               | Phase 4: plan sprint                |
| /create-story                  | Create a user story file            |
| /dev-story                     | Implement a story                   |
| /brainstorm                    | Structured brainstorming session    |
| bmad-help                      | Get guidance on what to do next     |

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

# Syntax highlighting (must be last)
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
