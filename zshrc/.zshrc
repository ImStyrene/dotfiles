if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =================
# ZSH CONFIGURATION
# =================

# Editor Settings
export EDITOR="nvim"
export VISUAL="$EDITOR"

# History Configuration
HISTSIZE=100
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space

# Path Configuration
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/opt/go/bin:$PATH"

# ======================
# PLUGIN MANAGER (ZINIT)
# ======================

# Zinit home directory
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if not installed
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Load Zinit
source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light romkatv/powerlevel10k

# Load completions
autoload -U compinit && compinit

# ============
# INTEGRATIONS
# ============

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

# ====================
# COMPLETION & STYLING
# ====================

# Case-insensitive completion
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Colorized completion menu
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# FZF tab preview for cd command
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# =======
# ALIASES
# =======

alias ls="ls --color"
alias xvim="~/.nix-profile/bin/nvim"
alias xvim-update="nix profile upgrade nixvim/.config/nixvim"
alias nixos-generation-list="sudo nix-env --list-generations --profile /nix/var/nix/profiles/system/"
alias arkenfox-update="~/.config/mozilla/firefox/mbz0g7ku.default/updater.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

fpath+=~/.zfunc; autoload -Uz compinit; compinit
