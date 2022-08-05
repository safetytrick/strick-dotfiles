
if [ "x$JAVA_HOME" != "x" ]; then
  PATH="$PATH:$JAVA_HOME/bin"
fi

PATH="/usr/local/bin:$PATH:$HOME/scripts:$HOME/bin"
export PATH

if [ -f ~/.bashrc_local ] 
then
  . ~/.bashrc_local
fi


# If not running interactively, don't do anything
[ -z "$PS1" ] && return
export FIGNORE=DS_Store

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTSIZE=
export HISTFILESIZE=

# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history

export D_UID=$(id -u)
export D_GID=$(id -g)

export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim

# "Linux" for linux, "Darwin" for osx
os=`uname -s`

# ignoredups and ignorespace 
export HISTCONTROL=ignoreboth

# append to history instead of rewriting
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"
[ -x /usr/local/bin/lesspipe.sh ] && eval "$(lesspipe.sh)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

LOCALNAME="${LOCALNAME:-\h}"

HOST_COLOR="${HOST_COLOR:-01;32m}"
if [ "$color_prompt" = yes ]; then
  PS1="\[\033[$HOST_COLOR\]\u@$LOCALNAME\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[0;33m\]\$(parse_git_branch)\[\033[0m\]\$ "
else
  PS1="\u@$LOCALNAME:\w\ \$(parse_git_branch)$ "
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${PWD/$HOME/~} : ${USER}@${HOSTNAME}\007"'
    ;;
  *)
    ;;
esac

# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
  eval "`dircolors -b`"
  alias ls='ls --color=auto'
  alias dir='ls --color=auto --format=vertical'
  alias vdir='ls --color=auto --format=long'

  alias grep='grep --color=auto --exclude-dir=".svn"'
  alias fgrep='fgrep --color=auto --exclude-dir=".svn"'
  alias egrep='egrep --color=auto --exclude-dir=".svn"'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

alias ..='cd ..'
alias ...='cd ../..'

# http://www.reddit.com/r/linux/comments/13s57s/make_your_bashrc_aliases_work_with_sudo/
alias sudo='sudo '

#alias webs='python -m SimpleHTTPServer'
function webs() {
  python3 -m http.server 7777
}

alias desktop.no="defaults write com.apple.finder CreateDesktop false; killall Finder;"
alias desktop.yes="defaults write com.apple.finder CreateDesktop true; killall Finder;"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

if command -v brew >/dev/null 2>&1; then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi
fi

# python specific
#. /home/michael/.django_bash_completion
export PYTHONSTARTUP=~/.pythonrc

if [ $os != "Darwin" ]; then
  alias md5=md5sum
  alias open=xdg-open
else
  # git-completion
  if [ -f /usr/local/git/contrib/completion/git-completion.bash ]; then 
    source /usr/local/git/contrib/completion/git-completion.bash
  else
    if [ -f /usr/share/git-core-git-completion.bash ]; then
      source /usr/share/git-core/git-completion.bash
    fi
  fi

  alias gvim=mvim
fi


alias dc="docker compose"

complete -F _docker_compose dc

alias h=history_grep

function join_strs { local IFS="$1"; shift; echo "$*"; }

history_grep() {
  _grh=$(join_strs ' ' $@)
  history | grep -e "$_grh"
}

# cd's to the source of a python package
cdp () {
  cd "$(python -c "import sys, imp, os  
path = sys.path
for i in '${1}'.split('.'): path = [imp.find_module(i,path)[1],]
path = path[0] if os.path.isdir(path[0]) else os.path.dirname(path[0])
print path")"
  }

# cds to the parent directory of first search result
cdfind() {
  cd $(dirname $(find "$@" 2>/dev/null | head -n1))
}

locatedir () {
  for last; do true; done
  if [[ $last == *\/* ]]
  then
    locate $@ | grep "${last}\$"
  else
    locate $@ | grep "/${last}\$"
  fi
}

locateext () {
  for last; do true; done
  locate $@ | grep "${last}\$"
}

findclass() {
  # lame, i hate working with bash arrays
  if [ $# == 2 ]
  then
    find "$1" -type f -name "*.jar" -exec sh -c 'jar -tf {}|grep -H --label {} '$2'' \;
  else
    find "." -type f -name "*.jar" -exec sh -c 'jar -tf {}|grep -H --label {} '$1'' \;
  fi

}

repeat () {
  n=$1
  shift
  while [ $(( n -= 1 )) -ge 0 ]
  do
    "$@"
  done
}

toback() {
  mv "$1" "$1.bak"
}

unback() {
  mv "$1" "`basename "$1" .bak`"
}

flip-coin() {
  if [[ $(($RANDOM % 2)) -eq 1 ]]; then
    echo "Heads";
  else
    echo "Tails"
  fi
}

# http://madebynathan.com/2011/10/04/a-nicer-way-to-use-xclip/
#
# A shortcut function that simplifies usage of xclip.
# - Accepts input from either stdin (pipe), or params.
# - If the input is a filename that exists, then it
#   uses the contents of that file.
# ------------------------------------------------
if [ $os == "Darwin" ]; then
  alias xclip=pbcopy
fi

cb() {
  # Check that xclip is installed.
  if ! type xclip > /dev/null 2>&1; then
    echo -e "You must have the 'xclip' program installed."
    # Check user is not root (root doesn't have access to user xorg server)
  elif [ "$USER" == "root" ]; then
    echo -e "Must be regular user (not root) to copy a file to the clipboard."
  else
    # If no tty, data should be available on stdin
    if [ "$( tty )" == 'not a tty' ]; then
      input="$(< /dev/stdin)"
      # Else, fetch input from params
    else
      input="$*"
    fi
    if [ -z "$input" ]; then  # If no input, print usage message.
      echo "Copies a string or the contents of a file to the clipboard."
      echo "Usage: cb <string or file>"
      echo "       echo <string or file> | cb"
    else
      # If the input is a filename that exists, then use the contents of that file.
      if [ -e "$input" ]; then input="$(cat $input)"; fi
      # Copy input to clipboard
      echo -n "$input" | xclip -selection c
      # Truncate text for status
      if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)..."; fi
      # Print status.
      echo -e "Copied to clipboard: $input"
    fi
  fi
}

# adjust cb() for copying paths
cbp() {
  input="$*"

  echo -n "$input" | xclip -selection c
  # Truncate text for status
  if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
  # Print status.
  echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
}

# Shortcut to copy SSH public key to clipboard.
alias cb-ssh="cb ~/.ssh/id_rsa.pub"

if [ -f ~/.ssh/config ]; then
  # Autocomplete ssh commands
  WL="$(perl -ne 'print "$1\n" if /^Host (.+)$/' ~/.ssh/config | grep -v "*" | tr "\n" " ")"
  complete -o plusdirs -f -W "$WL" ssh scp ssh-hostname
fi

build-ssh-conf() {
  mv ~/.ssh/config ~/.ssh/config.old
  cat ~/.ssh/sshconf/* > ~/.ssh/config  
}

ant-debug() {
  opts="-XX:MaxPermSize=256m -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8789"
  if [[ $ANT_OPTS == $opts ]]; then
    echo "debug disabled"
    export ANT_OPTS=""
  else
    echo "debug enabled"
    export ANT_OPTS=$opts
  fi
  unset opts
}

gradle-debug() {
  opts="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5006"
  if [[ $GRADLE_OPTS == $opts ]]; then
    echo "debug disabled"
    export GRADLE_OPTS=""
  else
    echo "debug enabled"
    export GRADLE_OPTS=$opts
  fi
  unset opts
}


htime() {
  HISTTIMEFORMAT="%F %T "
  history
}

ppath() {
  echo $PATH | tr ":" "\n" | sort
}

json_escape(){
  arg="$1"
  if [ -z "$arg" ]; then 
    arg=$(</dev/stdin)
  fi
  echo -n "$arg" | python -c 'import json,sys; print json.dumps(sys.stdin.read())'
}

show-tests() {
  if [[ ":" == "$1" ]]; then
    shift
    show-tests-immediate "$1"
  elif [[ -d "$1" ]]; then
    path=$1
    shift
    $(cd "$path" && show-tests "$@")
  else
    for path in $(find . -name build.gradle); do
      $(cd `dirname ${path}` && show-tests-immediate "$@")
    done
  fi

}

show-tests-immediate() {
  for directory in "target/test-reports/html" "build/reports/tests"; do
    if [[ -e "$directory" ]]; then
      find "$directory" -name "index.html" -print0 | while IFS= read -r -d $'\0' line; do
        if [[ "$line" == *"$1"* ]] || [[ "$(basename `pwd`)" == *"$1"* ]]; then
          open "$line"
        fi
      done
    fi
  done
}

# requires pup https://github.com/ericchiang/pup

if command -v pup >/dev/null 2>&1; then
  failures() {
    if [[ ":" == "$1" ]]; then
      shift
      failures-immediate "$1"
    elif [[ -d "$1" ]]; then
      path=$1
      shift
      $(cd "$path" && failures "$@")
    else
      for path in $(find . -name 'build.gradle*'); do
        $(cd `dirname ${path}` && failures-immediate "$@")
      done
    fi
  }
  
  failures-immediate() {
    for directory in "target/test-reports/html" "build/reports/tests"; do
      if [[ -e "$directory" ]]; then
        find "$directory" -name "index.html" -print0 | while IFS= read -r -d $'\0' line; do
          if [[ "$line" == *"$1"* ]] || [[ "$(basename `pwd`)" == *"$1"* ]]; then
            failurecount=$(cat "$line" | pup '#failures .counter text{}')
            if [[ "$failurecount" -ne "0" ]]; then
               open "$line"
            fi
          fi
        done
      fi
    done
  }
  cert-failures () 
  { 
      if [[ ":" == "$1" ]]; then
          shift;
          cert-failures-immediate "$1";
      else
          if [[ -d "$1" ]]; then
              path=$1;
              shift;
              $(cd "$path" && failures "$@");
          else
              for path in $(find . -name 'build.gradle*');
              do
                  $(cd `dirname ${path}` && cert-failures-immediate "$@");
              done;
          fi;
      fi
  }
  cert-failures-immediate () 
  { 
      depcheck="build/reports/dependency-check-report.html";
      if [[ -e "$depcheck" ]]; then
          failurecount=$(cat "$depcheck" | pup -n -f "$depcheck" '.vulnerable');
          if [[ "$failurecount" -ne "0" ]]; then
              xdg-open "$depcheck";
          fi;
      fi
  }
else
  failures() {
    cat <<EOF
requires pup for html parsing: https://github.com/ericchiang/pup

brew install https://raw.githubusercontent.com/EricChiang/pup/master/pup.rb
EOF
    return 1
  }
  cert-failures() {
    failures
  }
fi

ff() {
  find . -name \*${1}\*
}

ffo() {
  open $(ff "$1")
}

ssh-hostname() {
  ssh -G "$@" | grep ^hostname | sed 's/hostname //'
}

# https://hub.github.com/
if command -v hub >/dev/null 2>&1; then
  alias git=hub
fi

# man for builtins
bashman () { man bash | less -p "^       $1 "; }

function pslisten {
  echo `lsof -n -i4TCP:$1 | grep LISTEN`
}

jps-cwd() {
  jps -q | xargs -I % lsof -a -d cwd -p % | grep java | awk '{printf "%6s\t%s\n", $2, $NF}' | sort
}

extract-urls() {
  if [ $# -eq 0 ]; then
    echo "Usage: extract-urls file1 [file ...] "
  fi
  egrep -oh "https?://[^' \"]+" "$@"
}

extract-hostnames() {
  awk -F[/:] "{print \"$@\" \$4}"

}





[[ -s "$HOME/bash_completion.d/gradle-completion.bash" ]] && source "$HOME/bash_completion.d/gradle-completion.bash"
[[ -s "$HOME/bash_completion.d/ng-completion.bash" ]] && source "$HOME/bash_completion.d/ng-completion.bash"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

if type kubectl >/dev/null 2>&1; then
  source <(kubectl completion bash)
fi

if type hub >/dev/null 2>&1; then
  alias git=hub
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

