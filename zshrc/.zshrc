# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" && -s "${ZDOTDIR:-$HOME}/.p10k.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

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

# Remove the line below and remove the ML-COMMENT part if you want to use Zinit

# Zinit home directory
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Load Zinit
source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

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
alias sober-ro="chmod 444 ~/sober.conf.json"
alias sober-rw="chmod 644 ~/sober.conf.json"

# =========
# FUNCTIONS
# =========

# FFF
fm() {
    fff "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
}

# =============
# AUTO-COMMANDS
# =============

# FastFetch
# fastfetch

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
