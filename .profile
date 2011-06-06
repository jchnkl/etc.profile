# $FreeBSD: src/share/skel/dot.profile,v 1.23.2.1.2.1 2009/10/25 01:10:29 kensmith Exp $
#
# .profile - Bourne Shell startup script for login shells
#
# see also sh(1), environ(7).
#

# do this only when $DISPLAY is set but not on an ssh connection
if [ -n "${DISPLAY}" -a -z "${SSH_CONNECTION}" ]; then
  # disable bell
  xset -b

  if [ "${HOSTNAME}" = "monolith" ]; then
    for screen in 0 1 2; do
      : xgamma -quiet -screen ${screen} -gamma 0.76
    done
  elif [ "${HOSTNAME}" = "phobos" ]; then
    xgamma -quiet -rgamma 0.97 -ggamma 0.92 -bgamma 0.88
  fi
fi

# do this only for interactive shells
[ -z "$PS1" ] && return

PATH=\
${HOME}/bin:\
${HOME}/usr/sbin:\
${HOME}/usr/bin:\
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

LANG=en_US.UTF-8
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

LESS='-i -X -R'
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
alias gimp='gimp -s'
alias tms='tmux -L stuff'
alias tml='tmux -L long'
alias smux='sudo tmux'

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
    CLICOLOR_FORCE=1 ls -aFG $@;
  }

  da() {
    CLICOLOR_FORCE=1 ls -aFlGh $@ | less -EFr;
  }

elif [ "${OSNAME}" = "Linux" ]; then

  eval `dircolors -b ${HOME}/.dircolors`

  alias ll='ls -F --color'
  alias la='ls -aF --color'

  dir() {
    ls -lF --color "$@" | less -EFR
  }

  da() {
    ls -alF --color "$@" | less -EFR
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
