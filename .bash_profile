PATH=$PATH:/usr/local/sbin
export PATH=/usr/local/mysql/bin:$PATH
export PS1="\u@\h:\w\$ "

# set terminal color
export CLICOLOR=1
export LSCOLORS=DxGxcxdxCxegedabagacad

# set a fancy prompt (non-color, unless we know we "want" color)
PS1='\[\033[01;32m\]\w\[\033[00m\] $(git branch &>/dev/null; if [ $? -eq 0 ]; then echo "[$(git branch | grep ^*|sed s/\*\ //)] "; fi)\$> '

# Locale
export LANG=en_US.UTF-8
export LC_CTYPE="en_US.UTF-8"

alias server='open http://localhost:8000 && python -m SimpleHTTPServer'
alias dz='dzil build; cpanm -n *.tar.gz; dzil clean'
alias ll='ls -lAhG'
alias docker-cleanup='./.functions/docker-cleanup'
port() { lsof -n -i:$1 | grep LISTEN; }

# Git automerge
export GIT_MERGE_AUTOEDIT=no

alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
alias npm-do='PATH=$(npm bin):$PATH'

source ~/perl5/perlbrew/etc/bashrc
source ~/.profile

HISTCONTROL=ignoreboth # This option is does the same as the 2 before

# GOLANG
export GOPATH=$HOME/repos/go_workspace
export PATH=$PATH:$GOPATH/bin
