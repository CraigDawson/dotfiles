# cXd _r1002 -- One .bashrc to rule them all (mac os, linux, cygwin, etc.)
# Created : Sun 09 Apr 2017 07:52:40 PM EDT
# Modified: Tue 11 Apr 2017 12:52:12 PM EDT
# If not running interactively, don't do anything
[ -z "$PS1" ] && return
##############################################################################
# Initial items
##############################################################################
platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
   platform='freebsd'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='darwin'
elif [[ "$unamestr" == 'CYGWIN_NT-10.0' ]]; then
    platform='cygwin'
fi

export PAGER=less
export EDITOR=vim
export HISTTIMEFORMAT="%d/%m/%y %T "
export HISTCONTROL=ignoredups
export HISTSIZE=100000
export HISTFILESIZE=500000
export HISTIGNORE="&:ls:ll:la:l.:pwd:exit:clear"

# export JAVA_HOME=/opt/jdk1.8.0_45
# export JRE_HOME=/opt/jdk1.8.0_45/jre

if [[ $platform == 'linux' ]]; then
    ulimit -u 2048
    if [ -e /usr/share/terminfo/x/xterm-256color ]; then
        export TERM='xterm-256color'
    else
        export TERM='xterm-color'
    fi
else
    export TERM='xterm-256color'
fi

complete -cf sudo       # Tab complete for sudo

## shopt options
# use in scripts only:  shopt -s nullglob       # return null if glob doesn't match
shopt -s cdspell        # This will correct minor spelling errors in a cd command.
shopt -s histappend     # Append to history rather than overwrite
shopt -s checkwinsize   # Check window after each command
shopt -s dotglob        # files beginning with . to be returned in the results of path-name expansion.
shopt -s cdable_vars    # be able to cd to vars 
shopt -s cmdhist        # save multi-line commands to the history as one command

## set options
#set -o noclobber        # prevent overwriting files with cat
set -o ignoreeof        # stops ctrl+d from logging me out

##############################################################################
# Aliases
##############################################################################
alias a=alias
alias ag='ag --asm --batch --cc --cpp --csharp --css --cython --elisp --fortran --gettext --hh --html --ini --java --js --json --less --lisp --lua --m4 --make --markdown --matlab --objc --objcpp --octave --parrot --perl --php --puppet --python --racket --restructuredtext --r --ruby --scala --scheme --shell --smalltalk --sql --swift --tcl --tex --vb --vim --xml --yaml'
alias c='pygmentize -g -O style=colorful,linenos=1'
alias fb='nautilus --no-desktop --browser'
alias g='egrep --color=auto'
alias l=less
if [[ $platform == 'darwin' ]]; then
   alias ls='gls --group-directories-first --time-style=+"%Y-%m-%d %H:%M" --color=auto --human-readable -F'
else
   alias ls='ls --group-directories-first --time-style=+"%Y-%m-%d %H:%M" --color=auto --human-readable -F'
fi
lss() { ls -lrt --color "$@" | tail; }
alias h='history | ~/bin/gpfilter.py'
alias hl=~/bin/hl.py
alias src='search.pl -red -xsrc'
alias t='python ~/bin/t.py --task-dir /scratch/tasks --list Tasks'
alias webshare='python -m SimpleHTTPServer'
alias pgrp="ps aux | percol | awk '{ print \$2 }'"
alias pkll='pgrp | xargs kill'
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; brew cask cleanup; brew prune; npm update -g npm; npm update -g; updateRuby; sudo gem update --system; gem update; gem cleanup; pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | sudo -H xargs -n1 pip install -U; sudo composer self-update; composer global update; . updatePerl; cpan -u; meteor update;'
# gvim now script in ~/bin
# if [[ $platform == 'darwin' ]]; then
#     alias gvim='open -a /Applications/MacVim.app'
# fi
alias rdesktop='rdesktop -g 1440x810 -a 32'
alias freemind='~/bin/freemind-bin-max-1.0.1/freemind.sh'

# python
#   /usr/bin/python - 2.6
#   python2.7       - 2.7 installed by /tools/hepdsw/scripts/install-python-2.7.sh
#   no alias for    - 2.7 in ~/anaconda directory
alias python=python2.7
alias pip=pip2.7
alias virtualenv=virtualenv-2.7
alias py='time python'
alias pyv="python -V"

# STRip ESCape sequences
alias stresc='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"'

# pushd 
alias dirs="dirs -v"
alias po=popd
alias pu=pushd
alias d=dirs

alias less='less -m -N -g -i -J --underline-special --SILENT'

##############################################################################
# Environment
##############################################################################
# Enable syntax-highlighting in less.
# brew/apt-get install source-highlight
if [[ $platform == 'cygwin' ]]; then
    export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
elif [[ $platform == 'darwin' ]]; then
    export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"
else
    export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
fi
export LESS=" -R -F -X "

# Set-up FreeMind (fix homedir)
export FREEMIND_BASE_DIR="$HOME/bin/freemind-bin-max-1.0.1"

##############################################################################
# Prompt
##############################################################################

# Another prompt from http://unix.stackexchange.com/questions/148/colorizing-your-terminal-and-shell-environment
# Custom bash prompt via kirsle.net/wizards/ps1.html
git_branch () { git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'; }
BRANCH=' $(git_branch) '
LOCATION='`pwd`'
PS1="\$(hl)\n\[$(tput bold)\]\[$(tput setaf 1)\]\t \[$(tput bold)\]\[$(tput setaf 2)\]\u@\h \[$(tput bold)\]\[$(tput setaf 4)\]$LOCATION \[$(tput setaf 3)\]$BRANCH\[$(tput setaf 7)\]\n\\$ \[$(tput sgr0)\]"
PS2='\[\033[01;36m\]>'

##############################################################################
# Functions
##############################################################################

function cd {
    if (("$#" > 0)); then
        if [ "$1" == "-" ]; then
            popd > /dev/null
        else
            pushd "$@" > /dev/null
        fi
    else
        cd $HOME
    PROMPT_COMMAND='history -a; history -n; echo -ne "\033]0;${PWD}\007"'
    fi
}

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


hproxy () {
    if (( $# < 1 ))
    then
        echo http_proxy=$http_proxy
    elif (( $# == 1 ))
    then
        if [ "$1" = "none" ];
        then
            echo "Unsetting http_proxy"
            export http_proxy=
        else
            echo "Setting http_proxy to $1"
            export http_proxy=http://$1
        fi
    else
        echo "Usage: hproxy [proxyip:port | none]"
    fi
}

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

##############################################################################
# End stuff
##############################################################################

# Love'n the Z
#
if [ -e ~/bin/z.sh ]; then
    source ~/bin/z.sh
else
    echo "~/bin/z.sh not found"
fi

if [ -e /etc/profile.d/bash_completion.sh ]; then
    source  /etc/profile.d/bash_completion.sh
elif [ -e /usr/local/etc/bash_completion ]; then
    source /usr/local/etc/bash_completion
else
    echo "bash_completion.sh not found (installed?)"
fi

# vim: tabstop=4 shiftwidth=4 ft=sh

if [ -e $HOME/.cargo/env ]; then
    source $HOME/.cargo/env
fi

export FZF_DEFAULT_COMMAND='ag -l -g ""'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# add this configuration to ~/.bashrc
export HH_CONFIG=hicolor         # get more colors
shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"   # mem/file sync
# if this is interactive shell, then bind hh to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hh -- \C-j"'; fi

export BYOBU_PREFIX=/usr/local

[ -f ~/.workrc ] && source ~/.workrc
