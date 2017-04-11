# .bash_profile 4/7/2017 cXd _r1000
# Created : Sun 09 Apr 2017 07:53:14 PM EDT
# Modified: Tue 11 Apr 2017 12:52:08 PM EDT

export PATH=$HOME/bin:/usr/local/bin:$PATH:/usr/local/share/pypy

# Get the aliases and functions
[[ -s ~/.bashrc ]] && source ~/.bashrc

# User specific environment and startup programs
[ -f "${HOME}/.iterm2_shell_integration.bash" ] && source "${HOME}/.iterm2_shell_integration.bash"

[ -f ~/perl5/perlbrew/etc/bashrc ] && source ~/perl5/perlbrew/etc/bashrc

export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
export PATH="/usr/local/opt/sqlite/bin:$PATH"
export PATH="/usr/local/opt/dirmngr/bin:$PATH"
export PATH="/usr/local/opt/gpg-agent/bin:$PATH"

[ -f ~/bin/clnpath ] && export PATH=$(clnpath $PATH)
