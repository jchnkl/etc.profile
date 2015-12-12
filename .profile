# .profile - Bourne Shell startup script for login shells
#
# see also sh(1), environ(7).

PATH="${HOME}/.cabal/bin${PATH+:}${PATH}"
PATH="${HOME}/.local/bin${PATH+:}${PATH}"
export PATH

export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

# fix mouse pointer problem in qemu/dosbox/etc.
export SDL_VIDEO_X11_DGAMOUSE=0



# do this only for interactive shells
[ -z "$PS1" ] && return



LD_LIBRARY_PATH="${HOME}/.local/lib${LD_LIBRARY_PATH+:}${LD_LIBRARY_PATH}"
export LD_LIBRARY_PATH

export BLOCKSIZE=K
export LANG=de_DE.UTF-8
export LC_COLLATE=de_DE.UTF-8
export LC_CTYPE=de_DE.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_MONETARY=de_DE.UTF-8
export LC_NUMERIC=de_DE.UTF-8
export LC_TIME=de_DE.UTF-8
export EDITOR='vim'
export PAGER='less'

## LESS options
# Use standout and italics to highlight search results
# standout enter
export LESS_TERMCAP_so=$(tput smso)$(tput sitm)
# standout exit
export LESS_TERMCAP_se=$(tput rmso)$(tput ritm)
export LESSOPEN="| highlight -s solarized-light -O xterm256 %s 2>/dev/null"
export LESS='-i -X -R -J -j .25'

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
alias vim=nvim

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
alias gl='git lg'
alias glg='git log'
alias glp='git log -p'
alias gmv='git mv'
alias grp='git reset -p'

# fasd
alias v='f -e vim'
alias o='a -e xdg-open'
alias c='fasd_cd -d'

COLORDIFF=$(/usr/bin/which --skip-functions colordiff 2>/dev/null)
if [ -x ${COLORDIFF} ]; then
  alias diff='colordiff'
fi

# functions
eval $(dircolors -b ${HOME}/.dircolors)

alias ll='ls -F --color'
alias la='ls -aF --color'

function dir() {
  ls -hlF --color "$@" | less -EFR
}

function da() {
  ls -ahlF --color "$@" | less -EFR
}

IRSSI=$(/usr/bin/which --skip-functions irssi 2>/dev/null)
function irssi() {
  TERM=$TERM
  if [ -n "$TMUX" ]; then
    TERM=screen-256color
  fi
  ${IRSSI} $@
}

SVN=$(/usr/bin/which --skip-functions svn 2>/dev/null)
if [ -n "${SVN}" ]; then
  svn() {
    if [ "$1" = "diff" ]; then
      ${SVN} "$@" --diff-cmd colordiff | less -R -F
    else
      ${SVN} "$@"
    fi
  }
fi

MAN=$(/usr/bin/which --skip-functions man 2>/dev/null)
if [ -x ${MAN} ]; then
    man() {
        if [ ${COLUMNS} -lt 80 ]; then
            ${MAN} $@
        else
            MANWIDTH=80 ${MAN} $@
        fi
    }
fi
