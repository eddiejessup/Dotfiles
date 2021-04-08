# Helpers for this script.
function command_exists () {
  type "$1" &> /dev/null
}

function source_if_exists () {
  [[ -s "$1" ]] && source "$1"
}

# Am I on a Mac?
[[ $OSTYPE == darwin* ]] && on_mac=1 || on_mac=0
# Am I on an SSH connection?
[[ -n $SSH_CONNECTION ]] && on_ssh=1 || on_ssh=0

if [[ $on_ssh = 1 ]]; then
  export EDITOR='vim'
  export VISUAL='vim'
  export EDITOR_ASYNC=$EDITOR
else
  export EDITOR='nvim'
  export VISUAL='nvim'
  export EDITOR_ASYNC=$EDITOR
  # export EDITOR='code -w'
  # export VISUAL='code -w'
  # # Want to be able to edit a file in the background.
  # export EDITOR_ASYNC='code'
fi

export CLICOLOR=1

export HOMESHICK_DIR=$HOME/.homesick/repos/homeshick

path+=(
  $HOME/.cargo/bin
  $HOME/.cabal/bin
  $HOME/.local/bin
  $HOME/.fzf/bin
  $HOME/elmo/bin
  $HOME/.yarn/bin
  $HOME/.config/yarn/global/node_modules/.bin
  $HOME/.pyenv/bin
  /usr/local/opt/fzf/bin
)

fpath+=(
  $HOME/.homesick/repos/homeshick/completions
)

if [[ $on_mac = 1 ]]; then
  path+=(
    /Library/TeX/texbin
  )
fi

if command_exists go; then
  path+="$(go env GOPATH)/bin"
fi

# ---
# --- Configure Zsh itself
# ---

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
# Append every command to the history file once it is executed
setopt inc_append_history
# Reload the history whenever you use it
setopt share_history

# Changing directories
setopt auto_cd
setopt auto_pushd
unsetopt pushd_ignore_dups
setopt pushdminus

# Completion
setopt auto_menu
setopt always_to_end
setopt complete_in_word
unsetopt flow_control
unsetopt menu_complete
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# Other
setopt prompt_subst

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^X" edit-command-line

# # ---
# # --- ZPlug
# # ---

# Initialize zplug.
export ZPLUG_HOME=/usr/local/opt/zplug
source "$ZPLUG_HOME/init.zsh"

# List plugins.

# Add completions for the commands available within apps, with descriptions, triggered with <tab>.
zplug "zsh-users/zsh-completions"

# Tab-complete fasd's `z` command using fzf.
zplug "wookayin/fzf-fasd"

# Prompt.
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure", use:pure.zsh, as:theme

zplug "ael-code/zsh-colored-man-pages"

# Use fzf for completion selection.
# From https://github.com/Aloxaf/fzf-tab:
# > fzf-tab must be loaded after compinit, but before zsh-autosuggestions or fast-syntax-highlighting
# From https://github.com/zplug/zplug
# > If defer >= 2, run after compinit
zplug "Aloxaf/fzf-tab", defer:2

# Suggest previously run commands as you type, based on history and completions.
zplug "zsh-users/zsh-autosuggestions", defer:3

# Color commands as you type them, making errors easy to spot.
zplug "zsh-users/zsh-syntax-highlighting", defer:3

# Search through history entries that contain the input string anywhere, rather than with the exact prefix.
zplug "zsh-users/zsh-history-substring-search", defer:3

# Install plugins if some plugins haven't been installed.
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then echo; zplug install; fi
fi

# Load zplug
zplug load

# Configure: zsh-history-substring-search
# Key bindings.
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Configure: zsh-autosuggestions
# https://github.com/zsh-users/zsh-autosuggestions/#disabling-suggestion-for-large-buffers
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"

# Configure: pure prompt.
autoload -U promptinit; promptinit
prompt pure


# # ---
# # --- Configure tools
# # ---

# /// fasd ///
eval "$(fasd --init auto)"

# /// bat ///
export BAT_STYLE="numbers,changes"

# # /// fzf ///
# Auto-completion
source "/usr/local/opt/fzf/shell/completion.zsh"
# Key bindings
source "/usr/local/opt/fzf/shell/key-bindings.zsh"
export FZF_COMPLETION_OPTS='--preview "bat --style=changes --color=always --line-range :100 {}"'
export FZF_CTRL_T_OPTS="$FZF_COMPLETION_OPTS"
# Use `fd` as the default source for fzf
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ---
# --- Functions, bindings and helpers
# ---

function mnt () {
    # Unmount directory in case it's already mounted, ignoring the error output
    # if it isn't.
    umount $2 2> /dev/null
    # `follow_symlinks` to be able to access, for example, remote NFS mounts.
    # `reconnect` to survive disconnections: https://serverfault.com/a/6849.
    # `Server*` options to make IO errors happen fast, rather than hanging for
    # too long: https://serverfault.com/a/639735.
    sshfs -o follow_symlinks,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 $1 $2
}

# ---
# --- Aliases
# ---

# Identity.
alias -g mn="Elliot Marsden"
alias -g me="elliot.marsden@gmail.com"

# Misc.
alias -g v="bat --wrap=never"
alias -g wl="wc -l"
#   ls.
alias l="ls -1"
alias la="l -a"
alias ll="l -alh"
#   / ls.
alias md="mkdir -p"
alias cpr="cp -R"
alias e="$EDITOR_ASYNC"
alias ee="e . &"
alias d="nvim"
alias dc="d $HOME/.config/nvim/init.vim"
alias tm="tmux"
alias tma="tmux a"
alias chux="chmod u+x"
alias rd="rmdir"
alias "..."="cd ../.."
alias -- -="cd -"

# Python.
# This choice is explained at https://adamj.eu/tech/2020/02/25/use-python-m-pip-everywhere/
alias pip='python -m pip'
alias py="python"
alias ipy="ipython"
alias wo="pyenv activate"
alias de="source deactivate"
alias pi="pip install"

# Yarn.
alias y="yarn"
alias yw="yarn watch"

alias sai="sudo apt install"

# Git.
alias gs="git status"
alias gig="e .gitignore"
alias gclazy='git commit -m"Update"'
alias gr='git rebase'
alias grm='git rebase master'
alias gl='git log'
alias gcom='git checkout master'
alias gfm='git pull'
alias gfr='git pull --rebase'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
# Show status after doing an `add`.
function ga { git add "$@" && gs }
alias gap='ga --patch'
alias gd='git diff'
alias gdca='git diff --cached'
alias gcl='git clone'
alias gp='git push'
alias gb='git branch'
alias gba='git branch --all'
alias grh='git reset HEAD'
alias gtp='git stash pop'
alias gt='git stash'
alias gts='git stash show'
alias gtl='git stash list'
alias gta='git stash apply'
alias grv='git remote -v'

# Configuration.
alias zc="e $HOME/.zshrc"
alias zr="source $HOME/.zshrc"
alias vc="d $HOME/.config/nvim/init.vim"

# Apps.
alias skim='/Applications/Skim.app/Contents/MacOS/Skim'

if [[ $on_mac = 1 ]]; then
    alias o="open"
    alias oo="open ."
    alias tra="trash"
    alias fo="f -e open"
    alias sfo="sf -e open"
else
    alias o="xdg-open"
    alias oo="xdg-open ."
    alias tra="trash"
    alias fo="f -e xdg-open"
    alias sfo="sf -e xdg-open"
fi

source_if_exists "$HOME/.iterm2_shell_integration.zsh"
source_if_exists "$HOME/.nix-profile/etc/profile.d/nix.sh"
source_if_exists "$HOME/.ghcup/env"
source_if_exists "$HOMESHICK_DIR/homeshick.sh"

# Check dotfiles are up to date.
homeshick --quiet refresh

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Source local changes I don't want to track.
source_if_exists "$HOME/.zshrc.local"

autoload bashcompinit && bashcompinit
complete -C /usr/local/bin/aws_completer aws
