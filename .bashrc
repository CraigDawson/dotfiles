# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export PAGER=less
export EDITOR=vim
export HISTTIMEFORMAT="%d/%m/%y %T "
export HISTCONTROL=ignoredups
export HISTSIZE=5000
export HISTFILESIZE=5000
export HISTIGNORE="&:ls:ll:la:l.:pwd:exit:clear"
export GREP_OPTIONS=--color=auto

export H2=/scratch/cxd

complete -cf sudo       # Tab complete for sudo

ulimit -u 2048
 
## shopt options
shopt -s cdspell        # This will correct minor spelling errors in a cd command.
shopt -s histappend     # Append to history rather than overwrite
shopt -s checkwinsize   # Check window after each command
shopt -s dotglob        # files beginning with . to be returned in the results of path-name expansion.
 
## set options
#set -o noclobber        # prevent overwriting files with cat
set -o ignoreeof        # stops ctrl+d from logging me out

# cxd aliases
alias a=alias
alias g=grep
alias l=less
#alias ls="ls --color=auto"
alias ls='ls --group-directories-first --time-style=+"%Y-%m-%d %H:%M" --color=auto --human-readable -F'
alias h='history | ~/bin/gpfilter.py'
alias hl=~/bin/hl.py
alias src='search.pl -red -xsrc'
alias t='python ~/bin/t.py --task-dir /scratch/tasks --list Tasks'

# python
#   /usr/bin/python - 2.6
#   python2.7       - 2.7 installed by /tools/hepdsw/scripts/install-python-2.7.sh
#   no alias for    - 2.7 in ~/anaconda directory
#alias python='/usr/bin/python2.7'
#alias pip=pip2.7
alias virtualenv=virtualenv-2.7
alias py=python
alias pyv="python -V"
# added by Anaconda 2.1.0 installer
#export PATH="$HOME/anaconda/bin:$PATH"

#export SCRIPTSDIR='/scratch/cxd/src/trunk/Scripts'
#export PYTHONPATH=$SCRIPTSDIR:$SCRIPTSDIR/Test/Messages:$SCRIPTSDIR/Test:/scratch/cxd/src/Release2_2015_STS/Scripts/Test

# STRip ESCape sequences
alias stresc='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"'

# pushd 
alias dirs="dirs -v"
alias po=popd
alias pu=pushd
alias d=dirs

# env
export PATH=$HOME/bin\:$PATH
export LESSOPEN="|lesspipe.sh %s"
export LESS=" -R -X -F"
export SCR="/scratch/cxd"

#export PS1="\[\e[00;30m\]\u@\h:\[\e[0m\]\[\e[00;32m\]\W\[\e[0m\]\[\e[00;30m\]\\$\[\e[0m\]\[\e[00;37m\] \[\e[0m\] \t "

# Custom bash prompt via kirsle.net/wizards/ps1.html
export PS1="\u@\h \t \[$(tput setaf 2)\]\W\[$(tput setaf 7)\]$ \[$(tput sgr0)\]"

function cd {
    if (("$#" > 0)); then
        if [ "$1" == "-" ]; then
            popd > /dev/null
        else
            pushd "$@" > /dev/null
        fi
    else
        cd $HOME
    PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'
    fi
}

##############################################################################
# Functions
##############################################################################
# Delete line from known_hosts
# courtesy of rpetre from reddit
ssh-del() {
    sed -i -e ${1}d ~/.ssh/known_hosts
}

psgrep() {
        if [ ! -z $1 ] ; then
                echo "Grepping for processes matching $1..."
                ps aux | grep $1 | grep -v grep
        else

                echo "!! Need name to grep for"
        fi
}

#hl() {
#    perl -e 'print "\xc2\xaf" x 80; print "\n"'
#}

# clock - a little clock that appeares in the terminal window.
# Usage: clock.
#
clock ()
{
while true;do clear;echo "===========";date +"%r";echo "===========";sleep 1;done
}

# showip - show the current IP address if connected to the internet.
# Usage: showip.
#
showip ()
{
lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | awk '{ print $4 }' | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g'
}

. ~/bin/z.sh

. /etc/profile.d/bash_completion.sh

# vim: tabstop=4 shiftwidth=4 ft=sh
