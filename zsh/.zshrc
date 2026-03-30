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

# Syntax highlighting (must be last)
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
