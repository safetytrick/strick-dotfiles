# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

if [ -f ~/.bashrc_local ] 
then
	. ~/.bashrc_local
fi

if [ "x$JAVA_HOME" != "x" ]; then
	PATH=$PATH:$JAVA_HOME/bin
fi
GRADLE_HOME=~/opt/gradle
PATH=$PATH:~/scripts/:~/bin/:$GRADLE_HOME/bin
HISTSIZE=1500
export PATH
#export HISTIGNORE="&:ls:ls *:[bf]g:exit"

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

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

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

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

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# python specific
#. /home/michael/.django_bash_completion
#export PYTHONSTARTUP=~/.pythonrc

alias ..='cd ..'
alias ...='cd ../..'
alias h='history | grep $1'
alias open=xdg-open

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

mysql_genlog_on () {
	mysql $@ -e "set global general_log = 1;"
}

mysql_genlog_off () {
	mysql $@ -e "set global general_log = 0;"
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
		find "$1" -name "*.jar" -exec sh -c 'jar -tf {}|grep -H --label {} '$2'' \;
	else
		find "." -name "*.jar" -exec sh -c 'jar -tf {}|grep -H --label {} '$1'' \;
	fi
	
}

# it would be nice to write some utils to help with property lookup
# find . -wholename \*conf/messages.properties -print0 | xargs -0 grep "kickstart"

repeat () {
	n=$1
	shift
	while [ $(( n -= 1 )) -ge 0 ]
	do
		"$@"
	done
}

revertiml () {
	svn revert *.iml **/*.iml	
}

truthy() {
	if [[ $0 ]] ; then
		echo "true"
	else
		echo "false"
	fi
}

toback() {
	mv "$1" "$1.bak"
}

unback() {
	mv "$1" "`basename "$1" .bak`"
}

alias pushtab='firefox --display=:0.0 -new-tab '

export svnroot=svn+ssh://michaelnielson@svn.ops.ut.us.attask.com/SVN/Development/redrock
cobranch() {
	cd /src/
	svn co $svnroot/branches/$1
	cd $1
	ant intellij
}

# uncommit revision, thanks joel
function svnuc {
	for revision in $@
	do
		svn merge -c -$revision .
	done
}

# delete svn st ? files
# svn st |grep -e ^\? -e ^I | awk '{print $2}'| xargs -r rm -r

alias svnre='~/scripts/pysvn.py'

lsdeployed() {
	find /attask/AtTask/AtTaskJBoss/server/default/ -maxdepth 2 -type d -name redrock.ear 
}

# http://madebynathan.com/2011/10/04/a-nicer-way-to-use-xclip/
#
# A shortcut function that simplifies usage of xclip.
# - Accepts input from either stdin (pipe), or params.
# - If the input is a filename that exists, then it
#   uses the contents of that file.
# ------------------------------------------------
cb() {
  local _scs_col="\e[0;32m"; local _wrn_col='\e[1;31m'; local _trn_col='\e[0;33m'
  # Check that xclip is installed.
  if ! type xclip > /dev/null 2>&1; then
    echo -e "$_wrn_col""You must have the 'xclip' program installed.\e[0m"
  # Check user is not root (root doesn't have access to user xorg server)
  elif [ "$USER" == "root" ]; then
    echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\e[0m"
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
      if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
      # Print status.
      echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
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
alias cb_ssh="cb ~/.ssh/id_rsa.pub"


ant_debug() {
	opts="-XX:MaxPermSize=256m -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8789"
	if [[ $ANT_OPTS == $opts ]]; then
		export ANT_OPTS=""
	else
		export ANT_OPTS=$opts
	fi
	unset opts
}
