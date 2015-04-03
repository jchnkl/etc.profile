# .profile - Bourne Shell startup script for login shells
#
# see also sh(1), environ(7).
#

# do this only when $DISPLAY is set but not on an ssh connection
if [ -n "${DISPLAY}" -a -z "${SSH_CONNECTION}" ]; then
  # disable bell
  xset -b

  if [ "${HOSTNAME}" = "monolith" ]; then
    : xcalib /usr/share/apps/libkdcraw/profiles/widegamut.icm
  elif [ "${HOSTNAME}" = "phobos" ]; then
    : xgamma -quiet -rgamma 0.97 -ggamma 0.92 -bgamma 0.88
  fi
fi

# do this only for interactive shells
[ -z "$PS1" ] && return

PATH=\
${HOME}/bin:\
${HOME}/usr/sbin:\
${HOME}/usr/bin:\
${HOME}/.cabal/bin:\
${HOME}/.local/bin:\
${PATH}
export PATH

LD_LIBRARY_PATH=\
${HOME}/lib:\
${HOME}/usr/lib:\
${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH

OSNAME=$(uname -s)
HOSTNAME=$(hostname -s)

BLOCKSIZE=K
export BLOCKSIZE

LANG=de_DE.UTF-8
export LANG

LC_COLLATE=de_DE.UTF-8
export LC_COLLATE

LC_CTYPE=de_DE.UTF-8
export LC_CTYPE

LC_MESSAGES=en_US.UTF-8
export LC_MESSAGES

LC_MONETARY=de_DE.UTF-8
export LC_MONETARY

LC_NUMERIC=de_DE.UTF-8
export LC_NUMERIC

LC_TIME=de_DE.UTF-8
export LC_TIME

LESS='-i -X -R -j .5'
export LESS

EDITOR='vim'
export EDITOR

PAGER='less'
export PAGER

# fix mouse pointer problem in qemu/dosbox/etc.
SDL_VIDEO_X11_DGAMOUSE=0
export SDL_VIDEO_X11_DGAMOUSE

ENV=${HOME}/.shrc
export ENV

if [ "${OSNAME}" = "FreeBSD" -a -f ${HOME}/.termcap ]; then
  TERMCAP=$(< ${HOME}/.termcap)
  export TERMCAP
fi

# aliases
alias '...'='cd ../..'
alias '....'='cd ../../..'
alias '.....'='cd ../../../..'
alias -- '-'='cd -'
alias su='sudo su'
alias sudo='sudo -E'
alias gimp='gimp -s'
alias tms='tmux -L stuff'
alias tml='tmux -L long'
alias smux='sudo tmux'
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
alias gc='git commit -v'
alias gcv='git commit -v'
alias gca='git commit --amend -v'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcp='git checkout -p'
alias gdi='git diff'
alias gl='git log'
alias glp='git log -p'
alias gmv='git mv'
alias gpop='git populate'
alias gr='git reset'
alias grp='git reset -p'
alias gsm='git submodule'
alias gsmup='git submodule update --recursive --init'

# fasd
alias v='f -e vim'
alias o='a -e xdg-open'
alias c='fasd_cd -d'


COLORDIFF=$(which colordiff 2>/dev/null)
if [ -x ${COLORDIFF} ]; then
  alias diff='colordiff'
fi

# functions
if [ "${OSNAME}" = "FreeBSD" ]; then

  PATH=/usr/local/mpi/openmpi/bin:${PATH}
  export PATH

  LSCOLORS='xexfxcxdxbegedabagacad'
  export LSCOLORS

  ll() {
    CLICOLOR_FORCE=1 ls -FG $@;
  }

  dir() {
    CLICOLOR_FORCE=1 ls -FlGh $@ | less -EFr;
  }

  la() {
    CLICOLOR_FORCE=1 ls -ahFG $@;
  }

  da() {
    CLICOLOR_FORCE=1 ls -aFlGh $@ | less -EFr;
  }

elif [ "${OSNAME}" = "Linux" ]; then

  eval $(dircolors -b ${HOME}/.dircolors)

  alias ll='ls -F --color'
  alias la='ls -aF --color'

  dir() {
    ls -hlF --color "$@" | less -EFR
  }

  da() {
    ls -ahlF --color "$@" | less -EFR
  }

fi

GITCMD=/usr/bin/git
SVNCMD=/usr/bin/svn

checkscm() {
  DIR=$(pwd)
  SCMCMD=
  until [ ${DIR} = "/" ]; do
    if [ -d ${DIR}/.git ]; then
      SCMCMD=git
      break
    elif [ -d ${DIR}/.svn ]; then
      SCMCMD=svn
      break
    fi
    DIR=$(dirname ${DIR})
  done
}

runscm() {
  NOARGS="$1"
  WITHARGS="$2"
  shift; shift
  if [ $# -eq 0 ]; then
    eval "${SCMCMD} ${NOARGS}"
  else
    eval "${SCMCMD} ${WITHARGS} "$@""
  fi
}

# add
cad() {
  checkscm
  case ${SCMCMD} in
    git) runscm "add -p" "add" "$@" ;;
    svn) runscm "add" "add" "$@" ;;
  esac
}

# commit
ccm() {
  checkscm
  case ${SCMCMD} in
    git) runscm "commit -v" "commit -m" "'$@'" ;;
    svn) runscm "commit" "commit -m" "'$@'" ;;
  esac
}

# diff
cdi() {
  checkscm
  case ${SCMCMD} in
    git) runscm "diff" "diff" "$@" ;;
    svn) runscm "diff" "diff" "$@" ;;
  esac
}

# status
cst() {
  checkscm
  case ${SCMCMD} in
    git) runscm "status" "status" "$@" ;;
    svn) runscm "status" "status" "$@" ;;
  esac
}

# update
cup() {
  checkscm
  case ${SCMCMD} in
    git) runscm "pull" "pull" "$@" ;;
    svn) runscm "update" "update" "$@" ;;
  esac
}

# git push
cpu() {
  checkscm
  case ${SCMCMD} in
    git) runscm "push" "push" "$@" ;;
  esac
}

# checkout
cco() {
  checkscm
  case ${SCMCMD} in
    git) runscm "checkout" "checkout" "$@" ;;
    svn) runscm "checkout" "checkout" "$@" ;;
  esac
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
