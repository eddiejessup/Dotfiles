# Am I on a mac?
[[ $OSTYPE == darwin* ]] && on_mac=1 || on_mac=0
# Am I on an SSH connection?
[[ -n $SSH_CONNECTION ]] && on_ssh=1 || on_ssh=0

if [[ $on_ssh = 1 ]]; then
  export EDITOR='vim'
  export VISUAL='vim'
  export EDITOR_ASYNC=$EDITOR
else
  export EDITOR='subl -w'
  export VISUAL='subl -w'
  # Want to be able to edit a file in the background.
  export EDITOR_ASYNC='subl'
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
)
if [[ $on_mac = 1 ]]; then
  path+=(
    /Applications/Sublime\ Text.app/Contents/SharedSupport/bin
    /Library/TeX/texbin
  )
fi

setopt auto_cd

export HOMESHICK_DIR=/usr/local/opt/homeshick
source "/usr/local/opt/homeshick/homeshick.sh"
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

autoload -Uz compinit; compinit;
bindkey "^Xa" _expand_alias
zstyle ':completion:*' completer _expand_alias _complete _ignored
zstyle ':completion:*' regular true

# Added by Zplugin's installer
source "$HOME/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
# End of Zplugin installer's chunk

zplugin ice lucid
zplugin light zsh-users/zsh-autosuggestions

zplugin ice lucid
zplugin light zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

zplugin ice lucid
zplugin light zdharma/fast-syntax-highlighting

zplugin ice lucid
zplugin snippet PZT::modules/history/init.zsh

# zplugin ice lucid
# zplugin snippet PZT::modules/fasd/init.zsh

zplugin ice lucid
zplugin light zdharma/history-search-multi-word

zplugin ice lucid pick"async.zsh" src"pure.zsh"
zplugin light sindresorhus/pure

# zplugin ice lucid from"gh-r" as"program"
# zplugin light junegunn/fzf-bin

zplugin ice lucid
zplugin light peterhurford/git-it-on.zsh

zplugin ice lucid
zplugin light mollifier/cd-gitroot

# Taken from PR: https://github.com/ohmyzsh/ohmyzsh/pull/4420
# Implicitly used by OMZ git plugin.
# Outputs the name of the current branch
# Usage example: git pull origin $(git_current_branch)
# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
function git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

zplugin ice lucid
zplugin snippet OMZ::plugins/git/git.plugin.zsh


# zplugin ice lucid
# zplugin light wfxr/forgit

zplugin ice lucid
zplugin light ael-code/zsh-colored-man-pages

zplugin ice lucid
zplugin light wookayin/fzf-fasd

# z / fzf (ctrl-g)
zplugin ice lucid
zplugin light andrewferrier/fzf-z

# cd
zplugin ice lucid
zplugin light changyuheng/zsh-interactive-cd

export BAT_STYLE="changes"

function command_exists () {
  type "$1" &> /dev/null
}

if command_exists go; then
  path+="$(go env GOPATH)/bin"
fi

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

function ghcl () {
    gcl https://github.com/$1/$2.git
}

alias -g V="|& $PAGER"
alias -g G="|& ag --color"

alias -g H= "|& head"
alias -g T= "|& tail"
alias -g H1="H -n 1"
alias -g T1="T -n 1"

alias -g v="bat --wrap=never"
alias -g wl="wc -l"

# Identity.
alias -g mn="Elliot Marsden"
alias -g me="elliot.marsden@gmail.com"

alias ls="exa"
alias l="exa -1"
alias la="exa -a"
alias ll="exa --long"
alias tree="exa --tree"

alias md="mkdir -p"
alias cpr="cp -R"

alias e="$EDITOR_ASYNC"
alias ee="e . &"
alias tm="tmux"
alias tma="tmux a"
alias chux="chmod u+x"
alias rd="rmdir"
alias ex="export"
alias us="unset"

# Python.
alias py="python"
alias ipy="ipython"
alias wo="workon"
alias nb="jupyter notebook --ip=\* --port=8080"
alias pi="pip install"

# Haskell
alias stb="stack build"
alias stg="stack ghci"
alias ste="stack exec"
alias str="stack run"

# Yarn.
alias y="yarn"
alias yw="yarn watch"

alias sai="sudo apt install"

alias enc="gpg --encrypt --recipient $me"
alias dec="gpg --decrypt"

# Git.
alias gs="git status"
alias gig="e .gitignore"
alias gclazy='git commit -m"Update"'
alias grm='git rebase master'
alias gl='glo'
alias gap='git add --patch'
alias gcm='git commit -m'
alias gcom='git checkout master'

# Configuration.
alias zc="e $HOME/.zshrc"
alias zr="source $HOME/.zshrc"

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

# https://github.com/zsh-users/zsh-autosuggestions/#disabling-suggestion-for-large-buffers
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"

if [[ -s "${ZDOTDIR:-$HOME}/.zshrc.local" ]]; then
  source "${ZDOTDIR:-$HOME}/.zshrc.local"
fi

if command_exists direnv; then
    # Hook to direnv.
    eval "$(direnv hook zsh)"
fi
# fzf.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# prevstr='if [[ $(file --mime {}) =~ inode/directory ]]; then
#     echo "# {} is a directory\n"
#     ls -1 --color=always --group-directories-first {} || ls {} 2> /dev/null | head -200
# elif [[ $(file --mime {}) =~ binary ]]; then
#     echo {} is a binary file
# else
#     bat --style=numbers --color=always {} || cat {} 2> /dev/null | head -200
# fi'
export FZF_COMPLETION_TRIGGER='~~'
# export FZF_DEFAULT_OPTS="--inline-info --preview '$prevstr' --bind 'f1:execute(subl {}),ctrl-y:execute-silent(echo {} | pbcopy)+abort'"
# export FZF_DEFAULT_COMMAND='fd'
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

function fzfe() {
    fzf --bind 'enter:execute($EDITOR_ASYNC {})'
}
function fzfh() {
    FZF_DEFAULT_COMMAND='fd -H' fzfe
}

# fasd.
# alias fe="f -e $EDITOR_ASYNC"
alias sfe="sf -e $EDITOR_ASYNC"
alias de="d -e $EDITOR_ASYNC"
eval "$(fasd --init auto)"

bindkey '^X^A' fasd-complete    # C-x C-a to do fasd-complete (files and directories)
bindkey '^X^F' fasd-complete-f  # C-x C-f to do fasd-complete-f (only files)
bindkey '^X^D' fasd-complete-d  # C-x C-d to do fasd-complete-d (only directories)

unalias z
# Change directory with fasd & fzf:
# - If given arguments, jump using `fasd`
# - Otherwise, filter output of `fasd` using `fzf`
function z() {
    [ $# -gt 0 ] && fasd_cd -d "$*" && return
    local dir
    dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort --no-multi)" && cd "${dir}" || return 1
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
function fz_func() {fasd -Rfl "$1" | fzfu }
function az_func() {fasd -Ral "$1" | fzfu }
function dz_func() {fasd -Rdl "$1" | fzfu }
alias -g fz='"$(fz_func)"'
alias -g az='"$(az_func)"'
alias -g dz='"$(dz_func)"'

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
function fe() {
  local files
  files=($(fzf --query="$1"))
  [[ -n "$files" ]] && e "${files[@]}"
}

# iterm2.
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

alias "..."="cd ../.."
alias -- -="cd -"
