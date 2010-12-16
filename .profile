# $FreeBSD: src/share/skel/dot.profile,v 1.23.2.1.2.1 2009/10/25 01:10:29 kensmith Exp $
#
# .profile - Bourne Shell startup script for login shells
#
# see also sh(1), environ(7).
#

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

ENV=${HOME}/.shrc
export ENV

if [ -f ${HOME}/.termcap ]; then
  TERMCAP=$(< ${HOME}/.termcap)
  export TERMCAP
fi

# aliases
alias '..'='cd ..'
alias '...'='cd ../..'
alias '....'='cd ../../..'
alias '.....'='cd ../../../..'
alias -- '-'='cd -'
alias su='sudo su'
alias gimp='gimp -s'
alias tms='tmux -L stuff'
alias tml='tmux -L long'
alias smux='sudo tmux'

# named directories
if [ -n ${ZSH_VERSION} ]; then
  doc=${HOME}/doc
  pdf=${HOME}/pdf
  src=${HOME}/src
  tex=${HOME}/tex
  tmp=${HOME}/tmp
  usr=${HOME}/usr
  work=${HOME}/work
  jdl=/data/JDownloader/downloads
fi

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

  lla() {
    CLICOLOR_FORCE=1 ls -aFG $@;
  }

  dira() {
    CLICOLOR_FORCE=1 ls -aFlGh $@ | less -EFr;
  }

  # source bash completion scripts
  if [ -d /usr/local/etc/bash_completion.d/ -a -n "${BASH}" ]; then
    for i in /usr/local/etc/bash_completion.d/*; do
      . "$i"
    done
  fi

elif [ "${OSNAME}" = "Linux" ]; then

  eval `dircolors -b ${HOME}/.dircolors`

  alias ll='ls -F --color'
  alias lla='ls -aF --color'

  dir() {
    ls -lF --color "$@" | less -EFR
  }

  dira() {
    ls -alF --color "$@" | less -EFR
  }

  # source bash completion scripts
  if [ -d /etc/bash_completion.d/ -a -n "${BASH}" ]; then
    for i in /etc/bash_completion.d/*; do
      . "$i"
    done
  fi

fi

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

if [ -n "${DISPLAY}" -a -z "${SSH_CONNECTION}" ]; then
  if [ "${HOSTNAME}" = "monolith" ]; then
    for screen in 0 1 2; do
      xgamma -quiet -screen ${screen} -gamma 0.74
    done
  elif [ "${HOSTNAME}" = "phobos" ]; then
    xgamma -quiet -rgamma 0.97 -ggamma 0.92 -bgamma 0.88
  fi
fi
