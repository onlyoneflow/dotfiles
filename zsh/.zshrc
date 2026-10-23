# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change the frequency the auto-updater is run (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line to set how old an update must be before it's applied, manually or via the auto-updater (in days).
# zstyle ':omz:update' cooldown 10

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Modern shell integrations. Keep these after Oh My Zsh so they can provide
# the final prompt and keybindings.
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"
source <(fzf --zsh)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
alias omz="mate ~/.oh-my-zsh"
#

alias v="nvim"
alias n="yazi"

# Modern replacements with familiar commands still available.
alias ls='eza -lah --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'
alias tree='eza --tree --icons'
alias cat='bat --paging=never'
alias c='clear'
alias reload='source ~/.zshrc'

# Atuin: local searchable history; Ctrl-r opens its history UI.
export ATUIN_NOBIND="false"
export ATUIN_SYNC_FREQUENCY="0"

# Comfortable native macOS shell defaults.
export EDITOR="nvim"
export VISUAL="$EDITOR"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
setopt AUTO_CD
setopt CORRECT
setopt INTERACTIVE_COMMENTS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
bindkey -e
bindkey '^U' backward-kill-line
bindkey '^W' backward-kill-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

# Useful shortcuts.
alias ..='cd ..'
alias ...='cd ../..'
alias d='cd ~/Downloads'
alias desk='cd ~/Desktop'
alias docs='cd ~/Documents'
alias ports='lsof -nP -iTCP -sTCP:LISTEN'
alias ip='curl -4 -s https://api.ipify.org; echo'
alias untar='tar -xvf'

# Omarchy-inspired quality-of-life shortcuts for macOS.
alias c='clear'
alias g='git'
alias gs='git status --short --branch'
alias gl='git log --oneline --decorate --graph -15'
alias dc='docker compose'
alias ports='lsof -nP -iTCP -sTCP:LISTEN'
alias venv='python3 -m venv .venv && source .venv/bin/activate'
alias ..='cd ..'
alias ...='cd ../..'

# Fast project navigation with zoxide.
function zproj() { cd "$(zoxide query -i "$@")" }

# Open the current directory in Finder or the default editor.
alias o='open .'
alias code='zed'

# Live command syntax highlighting. Valid commands are accented in green,
# while unknown commands turn red before execution. Keep this last so it wraps
# the final line editor widgets installed by Atuin and fzf.
if [[ -r "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  typeset -g ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)
  typeset -gA ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan,bold'
  ZSH_HIGHLIGHT_STYLES[function]='fg=cyan,bold'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=blue,bold'
  ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green,bold'
  ZSH_HIGHLIGHT_STYLES[unknown-command]='fg=red,bold'
  ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=magenta'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
  ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=yellow'
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=yellow'
  ZSH_HIGHLIGHT_STYLES[redirection]='fg=magenta'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=bright-black'
  source "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Optional fastfetch startup display can be configured locally.

# Rotating inline alpaca photo + fastfetch system summary.
if [[ -o interactive && -z "$TMUX" && -z "$SSH_CONNECTION" && -x "$(command -v alpaca-fetch 2>/dev/null)" ]]; then
  alpaca-fetch fastfetch
fi
