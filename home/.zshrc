# *** Uncomment this and some more at the file's end to enable profiling. ***

# ZSH_DISABLE_COMPFIX="true"

# zmodload zsh/datetime
# setopt PROMPT_SUBST
# PS4='+$EPOCHREALTIME %N:%i> '

# logfile=$(mktemp zsh_profile.XXXXXXXX)
# echo "Logging to $logfile"
# exec 3>&2 2>$logfile

# setopt XTRACE

# *** ***


# Helpers for this script.
function command_exists () {
  type "$1" &> /dev/null
}

# Am I on a mac?
[[ $OSTYPE == darwin* ]] && on_mac=1 || on_mac=0
# Am I on an SSH connection?
[[ -n $SSH_CONNECTION ]] && on_ssh=1 || on_ssh=0

if [[ $on_ssh = 1 ]]; then
  export EDITOR='vim'
  export VISUAL='vim'
  export EDITOR_ASYNC=$EDITOR
else
  export EDITOR='code -w'
  export VISUAL='code -w'
  # Want to be able to edit a file in the background.
  export EDITOR_ASYNC='code'
fi
export PAGER='less'

path+=(
  ~/.cargo/bin
  ~/.cabal/bin
  ~/.local/bin
  ~/.fzf/bin
  ~/projects/hex/support
  ~/.gem/ruby/2.3.0/bin
  ~/elmo/src/ddlog/bin
  ~/elmo/bin
  ~/.homesick/repos/homeshick/completions
  ~/.ebcli-virtual-env/executables  # Elastic beanstalk CLI
  ~/node/node-v14.3.0-darwin-x64/bin
  ~/.yarn/bin
  ~/.config/yarn/global/node_modules/.bin
)

if [[ $on_mac = 1 ]]; then
  path+=(
    /Applications/Sublime\ Text.app/Contents/SharedSupport/bin
    /Library/TeX/texbin
  )
fi

if command_exists go; then
  path+="$(go env GOPATH)/bin"
fi


export HOMESHICK_DIR=$HOME/.homesick/repos/homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
# export HOMESHICK_DIR=/usr/local/opt/homeshick
# source "/usr/local/opt/homeshick/homeshick.sh"

# ---
# --- Configure Zsh itself
# ---

setopt auto_cd
# Q. What is autoload?
# A. Functions are called in the same way as any other command. There can be a
# name conflict between a program and a function. autoload marks a name as
# being a function rather than an external program.
# Q. What are those arguments?
# A. The -U means mark the function 'vcs_info' for autoloading and suppress
# alias expansion. The -z means use zsh (rather than ksh) style.
# Q. What does compinit do?
# A. It initializes completion.
# autoload -Uz compinit
# Only do it once per day, because it's slow:
# https://gist.github.com/ctechols/ca1035271ad134841284#gistcomment-2308206
for dump in ~/.zcompdump(N.mh+24); do
  autoload -Uz compinit
  compinit
done
# compinit -C

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
bindkey "^X^X" edit-command-line

# History.
# Appends every command to the history file once it is executed
setopt inc_append_history
# Reloads the history whenever you use it
setopt share_history

# - _complete: the basic completer.
# - _expand_alias: can be used both as a completer and as a bindable command.
#   It expands the word the cursor is on if it is an alias.
# - regular: used by the _expand_alias completer and bindable command. If
#   ‘true’, regular aliases will be expanded, but only in command position
zstyle ':completion:*' completer _expand_alias _complete
zstyle ':completion:*' regular true

# ---
# --- Zinit
# ---

# Added by Zinit's installer
source ~/.zinit/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
# End of Zinit installer's chunk

# Fish-like history search, where you type in any part of any command from
# history and then press up and down to browse matches.
# Don't add 'wait' as this messes up search for the first prompt.
zinit ice lucid
zinit load zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Bind Ctrl-R to a widget that searches for multiple keywords in AND fashion.
# So you enter multiple words, and entries that match all of them are returned.
# The entries are syntax highlighted.
zinit ice wait lucid
zinit load zdharma/history-search-multi-word

# Provide a man wrapper function to color manpages.
zinit ice wait lucid
zinit load ael-code/zsh-colored-man-pages

# Use fzf to tab-complete cd's argument.
zinit ice wait lucid
zinit load changyuheng/zsh-interactive-cd

# fast-syntax-highlighting: Feature-rich syntax highlighting
# zsh-autosuggestions: Fish-like fast/unobtrusive autosuggestions for zsh. Suggest commands as you type based on history and completions.
zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions
# https://github.com/zsh-users/zsh-autosuggestions/#disabling-suggestion-for-large-buffers
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"

zinit ice pick"/dev/null" multisrc"{async,pure}.zsh" \ atload'!prompt_pure_precmd' nocd
zinit load sindresorhus/pure
# Load the pure theme, with zsh-async library that's bundled with it.

# ---
# --- Configuration of tools
# ---

# /// fasd ///
zinit snippet OMZ::plugins/fasd/fasd.plugin.zsh
# eval "$(fasd --init auto)"

alias sfe="sf -e $EDITOR_ASYNC"
alias de="d -e $EDITOR_ASYNC"
# bindkey '^X^A' fasd-complete    # C-x C-a to do fasd-complete (files and directories)
# bindkey '^X^F' fasd-complete-f  # C-x C-f to do fasd-complete-f (only files)
# bindkey '^X^D' fasd-complete-d  # C-x C-d to do fasd-complete-d (only directories)

# Tab-complete fasd's 'z' using fzf.
zinit ice wait lucid
zinit load wookayin/fzf-fasd

# Press <CTRL-g> to list relevant directories. You can type to filter the list.
# Select one to insert it into the command line. If you started with an
# empty command line, and have enabled the zsh option AUTO_CD, you'll change to
# that directory instantly.
# # z / fzf (ctrl-g)
zinit ice wait lucid
zinit load andrewferrier/fzf-z
# Use 'fasd' instead of 'z'.
FZFZ_RECENT_DIRS_TOOL=fasd

# unalias z
# # Change directory with fasd & fzf:
# # - If given arguments, jump using `fasd`
# # - Otherwise, filter output of `fasd` using `fzf`
# function z() {
#     [ $# -gt 0 ] && fasd_cd -d "$*" && return
#     local dir
#     dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort --no-multi)" && cd "${dir}" || return 1
# }

# /// bat ///

export BAT_STYLE="changes"

# /// fzf ///

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_COMPLETION_TRIGGER='~~'

function fzfe() {
    fzf --bind 'enter:execute($EDITOR_ASYNC {})'
}
function fzfh() {
    FZF_DEFAULT_COMMAND='fd -H' fzfe
}

function fzfu() {
    local match
    # -1: If one match, select it.
    # -0: Exit if no matches.
    # --no-multi: disable multi-select.
    # -i: Case insensitive.
    match=$(fzf -1 -0 -i --no-sort --no-multi) || return 1
    # Escape to play nicely as a path argument.
    echo "$match"
}

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
function fe() {
  local files
  files=($(fzf --query="$1"))
  [[ -n "$files" ]] && $EDITOR_ASYNC "${files[@]}"
}

function fz_func() {fasd -Rfl "$1" | fzfu }
function az_func() {fasd -Ral "$1" | fzfu }
function dz_func() {fasd -Rdl "$1" | fzfu }
alias -g fz='"$(fz_func)"'
alias -g az='"$(az_func)"'
alias -g dz='"$(dz_func)"'

# /// iTerm2 ///

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# ---
# --- Functions, bindings and helpers
# ---

bindkey "^Xa" _expand_alias

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
alias dc="d ~/.config/nvim/init.vim"
alias vim=nvim
alias tm="tmux"
alias tma="tmux a"
alias chux="chmod u+x"
alias rd="rmdir"
alias ex="export"
alias us="unset"
alias "..."="cd ../.."
alias -- -="cd -"

# Python.
# This choice is explained at https://adamj.eu/tech/2020/02/25/use-python-m-pip-everywhere/
alias pip='python -m pip'
alias py="python"
alias ipy="ipython"
alias wo="workon"
alias nb="jupyter notebook --ip=\* --port=8080"
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
function ga {
  git add "$@" && gs
}
alias gap='git add --patch'
alias gd='git diff'
alias gdc='git diff --cached'
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

# Notes.
function nn {
    title=$1
    datestr=$(date -u +"%Y-%m-%d")
    pth=~/elmo/notes/$datestr-$1.md
    echo $title, $datestr, $pth
    if [[ ! -f "$pth" ]]; then
        echo "# $title\n\n" >> "$pth"
    fi
    d -c "+3" $pth
}

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

# Nix.
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

if [[ -s "${ZDOTDIR:-$HOME}/.zshrc.local" ]]; then
  source "${ZDOTDIR:-$HOME}/.zshrc.local"
fi

# ---
# --- Programs to maybe run.
# ---

# echo "gitit: open current folder on github"

# echo "cd-gitroot, or cdu: go to git root"

# Check dotfiles are up to date.
homeshick --quiet refresh

# *** Uncomment this and some more at the file's start to enable profiling. ***

# unsetopt XTRACE
# exec 2>&3 3>&-

# *** ***

export CLICOLOR=1

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

[ -f "~/.ghcup/env" ] && source "~/.ghcup/env"

[ -f "~/.zshrc.local" ] && source "~/.zshrc.local"
