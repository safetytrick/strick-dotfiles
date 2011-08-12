# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

if [ -f ~/.bashrc_local ] 
then
	. ~/.bashrc_local
fi

PATH=$PATH:~/scripts/:~/bin/:~/opt/idea-IU-95.627/bin/
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
alias atfd='ant test-failures -Dtest.remoteDebug=true'
alias atf='ant test-failures'

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
	find "$1" -name "*.jar" -exec sh -c 'jar -tf {}|grep -H --label {} '$2'' \;
}

