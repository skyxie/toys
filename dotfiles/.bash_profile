function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function proml {
  local        BLUE="\[\033[0;34m\]"
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"

PS1="$BLUE[$RED\$(date +%H:%M)$BLUE]\
$BLUE[$RED\w$GREEN\$(parse_git_branch)$BLUE]\
$GREEN\$$WHITE "
PS2='> '
PS4='+ '
}

proml

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export PATH="/usr/local/share/npm/bin:/usr/local/bin:/usr/local/sbin:/opt/local/lib:$PATH"
export RACK_ENV=development
export RAILS_ENV=development
export ANIMOTO_DIR='/Users/skyxie/Development/stack/config'
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/lib:/usr/local/opt/libpng/lib/pkgconfig/:/usr/local/opt/freetype/lib/pkgconfig/:/usr/local/opt/fontconfig/lib/pkgconfig/:/usr/local/opt/libxml2/lib/pkgconfig:/usr/local/opt/libiconv/lib/pkgconfig"
export NODE_PATH="/usr/local/lib/node"

alias h=history
alias c=clear
alias be='bundle exec'
alias la='ls -al'
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
alias less='less -R'
alias grep='grep --color=auto --exclude-dir=.git --exclude-dir=log'
alias db='mysql --host=localhost --port=3306 --user=root'

[[ -s "/Users/skyxie/.rvm/scripts/rvm" ]] && source "/Users/skyxie/.rvm/scripts/rvm"

export ANIMOTO_STACK_ROOT=/Users/skyxie/animoto/stack
