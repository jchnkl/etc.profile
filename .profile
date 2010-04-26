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

BLOCKSIZE=K
export BLOCKSIZE

LESS='-i -X'
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
alias su='sudo su'
alias gimp='gimp -s'
alias tms='tmux -L stuff'
alias tml='tmux -L long'

COLORDIFF=$(which colordiff 2>/dev/null)
if [ -x ${COLORDIFF} ]; then
  alias diff='colordiff'
fi

# functions
if [ -z "${OSTYPE}" ]; then
  OSTYPE=$(uname -s)
fi

if [ "${OSTYPE}" = "FreeBSD"\
  -o "${OSTYPE}" = "freebsd8.0"\
  -o "${HOSTTYPE}" = "FreeBSD" ]; then

  LSCOLORS='xexfxcxdxbegedabagacad'
  export LSCOLORS

  ll() {
    CLICOLOR_FORCE=1 ls -FG $@;
  }

  dir() {
    CLICOLOR_FORCE=1 ls -FlGh $@ | less -EFr;
  }

  # source bash completion scripts
  if [ -d /usr/local/etc/bash_completion.d/ -a -n ${BASH} ]; then
    for i in /usr/local/etc/bash_completion.d/*; do
      . "$i"
    done
  fi

elif [ "${OSTYPE}" = "Linux"\
  -o "${HOSTTYPE}" = "Linux" ]; then

  LS_COLORS='rs=00:di=37;44:ln=45;37:mh=00:pi=40;33:so=42;37:do=37;45:bd=40;33:cd=40;33:or=40;31:su=30;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=41;37:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
  export LS_COLORS;

  alias ll='ls -F --color'

  dir() {
    ls -lF --color "$@" | less -EFR
  }

  # source bash completion scripts
  if [ -d /etc/bash_completion.d/  -a -n ${BASH} ]; then
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

# merge gdm auth cookie into .Xauthority
if [ -n "${DISPLAY}" -a "${XAUTHORITY}" != "${HOME}/.Xauthority" ]; then
  xauth -f "${HOME}/.Xauthority" remove ${DISPLAY}
  if [ -n "`xauth -f "${HOME}/.Xauthority" merge ${XAUTHORITY} 2>&1`" ]; then
    xauth -f "${HOME}/.Xauthority" merge "$(echo /var/run/gdm/auth-for-$(id -un)-*/database)" 2>/dev/null
  fi
  export XAUTHORITY="${HOME}/.Xauthority"
fi

# load monitor calibration file
if [ -n "${DISPLAY}" -a -f "${HOME}/.monicarc" -a -z "${SSH_CONNECTION}" ]; then
  . ${HOME}/.monicarc
fi

# start gpg-agent
GPG_AGENT=$(which gpg-agent 2>/dev/null)
if [ -n "${GPG_AGENT}" ]; then
  if [ -f "${HOME}/.gpg-agent-info" ]; then
    if ! kill -0 `grep GPG_AGENT_INFO ${HOME}/.gpg-agent-info | cut -f2 -d:` 2>/dev/null; then
      rm -f ${HOME}/.gpg-agent-info
      eval $(${GPG_AGENT} --daemon)
      . ${HOME}/.gpg-agent-info
      export `cut -f1 -d= ${HOME}/.gpg-agent-info`
    else
      . ${HOME}/.gpg-agent-info
      export `cut -f1 -d= ${HOME}/.gpg-agent-info`
      echo UPDATESTARTUPTTY | gpg-connect-agent 2>&1 >/dev/null
    fi
  else
    eval $(${GPG_AGENT} --daemon)
    . ${HOME}/.gpg-agent-info
    export `cut -f1 -d= ${HOME}/.gpg-agent-info`
  fi
fi
