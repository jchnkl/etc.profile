# .profile - Bourne Shell startup script for login shells
#
# see also sh(1), environ(7).

# do this only for interactive shells
[ -z "$PS1" ] && return

PATH=\
${HOME}/.cabal/bin:\
${HOME}/.local/bin:\
${PATH}
export PATH

LD_LIBRARY_PATH=\
${HOME}/.local/lib:\
${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH

OSNAME=$(uname -s)
HOSTNAME=$(hostname -s)

export BLOCKSIZE=K
export LANG=de_DE.UTF-8
export LC_COLLATE=de_DE.UTF-8
export LC_CTYPE=de_DE.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_MONETARY=de_DE.UTF-8
export LC_NUMERIC=de_DE.UTF-8
export LC_TIME=de_DE.UTF-8
export LESS='-i -X -R -j .5'
export EDITOR='vim'
export PAGER='less'
# fix mouse pointer problem in qemu/dosbox/etc.
export SDL_VIDEO_X11_DGAMOUSE=0

# Use standout and italics to highlight search results
# standout enter
export LESS_TERMCAP_so=$(tput smso)$(tput sitm)
# standout exit
export LESS_TERMCAP_se=$(tput rmso)$(tput ritm)

# aliases
alias '...'='cd ../..'
alias '....'='cd ../../..'
alias '.....'='cd ../../../..'
alias -- '-'='cd -'
alias su='sudo su'
alias sudo='sudo -E'
alias bc='bc -l'
alias grep='grep --color' # hooray for incompatibility
alias wi='wicd-curses'

alias g='git'
alias gs='git status'
alias gcl='git clone'
alias gpl='git pull'
alias gps='git push'
alias gbr='git branch'
alias gad='git add'
alias gap='git add -p'
alias gcv='git commit -v'
alias gca='git commit --amend -v'
alias gcm='git commit -m'
alias gcf='git commit --fixup'
alias gco='git checkout'
alias gcp='git checkout -p'
alias gdi='git diff'
alias gl='git log'
alias glp='git log -p'
alias gmv='git mv'
alias grp='git reset -p'

# fasd
alias v='f -e vim'
alias o='a -e xdg-open'
alias c='fasd_cd -d'


COLORDIFF=$(which colordiff 2>/dev/null)
if [ -x ${COLORDIFF} ]; then
  alias diff='colordiff'
fi

# functions
eval $(dircolors -b ${HOME}/.dircolors)

alias ll='ls -F --color'
alias la='ls -aF --color'

dir() {
  ls -hlF --color "$@" | less -EFR
}

da() {
  ls -ahlF --color "$@" | less -EFR
}

SVN=$(which svn 2>/dev/null)
if [ -n "${SVN}" ]; then
  svn() {
    if [ "$1" = "diff" ]; then
      ${SVN} "$@" --diff-cmd colordiff | less -R -F
    else
      ${SVN} "$@"
    fi
  }
fi

MAN=$(which man)
if [ -x ${MAN} ]; then
    man() {
        if [ ${COLUMNS} -lt 80 ]; then
            ${MAN} $@
        else
            MANWIDTH=80 ${MAN} $@
        fi
    }
fi
