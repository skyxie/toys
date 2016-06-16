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
export LSCOLORS=GxFxCxDxBxegedabagaced
export RACK_ENV=development
export RAILS_ENV=development
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/lib:/usr/local/opt/libpng/lib/pkgconfig/:/usr/local/opt/freetype/lib/pkgconfig/:/usr/local/opt/fontconfig/lib/pkgconfig/:/usr/local/opt/libxml2/lib/pkgconfig:/usr/local/opt/libiconv/lib/pkgconfig"
export NODE_PATH="/usr/local/lib/node"
export GOROOT="/usr/local/opt/go/libexec"
export GOPATH="$HOME/dev/go_path"

# Go install path from brew
export PATH="$GOROOT/bin:/usr/local/share/npm/bin:/usr/local/bin:/usr/local/sbin:/opt/local/lib:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"
export PATH="$HOME/dev/go_appengine:$PATH"


# Local .bash_profile should set ANIMOTO_STACK_ROOT and source this file
export ANIMOTO_DIR=$ANIMOTO_STACK_ROOT/config

alias h=history
alias c=clear
alias be='bundle exec'
alias la='ls -al'
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
alias less='less -R'
alias grep='grep --color=auto --exclude-dir=.git --exclude-dir=log --exclude-dir=vendor'
alias ag='ag --ignore-dir=.git --ignore-dir=log --ignore-dir=vendor'
alias db='mysql --host=localhost --port=3306 --user=root'

[[ -s "/Users/skyxie/.rvm/scripts/rvm" ]] && source "/Users/skyxie/.rvm/scripts/rvm"

if which nodenv > /dev/null; then eval "$(nodenv init -)"; fi
