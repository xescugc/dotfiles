#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

################
# EXPORTS
################

# Local bin
export PATH="$PATH:$HOME/bin"

# Locale
export LANG=en_US.UTF-8
export LC_CTYPE="en_US.UTF-8"
export EDITOR="vim"
export BROWSER="firefox"

# Git automerge
export GIT_MERGE_AUTOEDIT=no

export POMPT_DIRTRIM=2

#export PATH="$PATH:$HOME/perl5"

# GOLANG
#export GOPATH=$HOME/repos/go_workspace
#export PATH=$PATH:$GOPATH/bin


################
# OVERRIDE ENV
################

# set a fancy prompt (non-color, unless we know we "want" color)
PS1='\[\033[01;32m\]\w\[\033[00m\] $(git branch &>/dev/null; if [ $? -eq 0 ]; then echo "[$(git branch | grep ^*|sed s/\*\ //)] "; fi)\$> '
HISTCONTROL=ignoreboth # This option is does the same as the 2 before

################
# ALIAS
################

alias server='open http://localhost:8000 && python -m SimpleHTTPServer'
alias dz='dzil build; cpanm -n *.tar.gz; dzil clean'
alias ll='ls -lAhG --color=auto'
alias ls='ls --color=auto'

alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
alias npm-do='PATH=$(npm bin):$PATH'

################
# FUNCTIONS
################

port() { lsof -n -i:$1 | grep LISTEN; }


###############
# SOURCES
###############

source ~/perl5/perlbrew/etc/bashrc
#source ~/.profile


