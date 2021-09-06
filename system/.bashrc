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
export PATH="$HOME/.bin:$PATH"

# Locale
export LANG=en_US.UTF-8
export LC_CTYPE="en_US.UTF-8"
export EDITOR="vim"
export BROWSER="firefox"

# Git automerge
export GIT_MERGE_AUTOEDIT=no
export GIT_TERMINAL_PROMPT=1

export PROMPT_DIRTRIM=3

# GOLANG
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOPATH/bin:$PATH"

# Ruby
# export PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"


################
# OVERRIDE ENV
################

# set a fancy prompt (non-color, unless we know we "want" color)
PS1='\[\033[01;32m\]\w\[\033[00m\] $(git branch &>/dev/null; if [ $? -eq 0 ]; then echo "[$(git branch | grep ^*|sed s/\*\ //)] "; fi)\$> '
HISTCONTROL=ignoreboth # This option is does the same as the 2 before

################
# ALIAS
################

alias dz='dzil build; cpanm -n *.tar.gz; dzil clean'
alias ll='ls -lAhG --color=auto'
alias ls='ls --color=auto'

alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
alias npm-do='PATH=$(npm bin):$PATH'
alias xclip='xclip -selection c'
#https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes
alias drmi='docker rmi $(docker images -f dangling=true -q)'
alias dc='docker-compose'
alias st="tmux new-session -n cmd\; new-window -n code \"/bin/sh -c 'vim +:NERDTree; exec bash'\"\; new-window -n git\; select-window -t 1 \; attach"
################
# FUNCTIONS
################

port() { lsof -n -i:$1 | grep LISTEN; }
wp(){
    start=$(date +%s)
    "$@"
    [ $(($(date +%s) - start)) -le 15 ] || notify-send "Notification" "Long\
 running command \"$(echo $@)\" took $(($(date +%s) - start)) seconds to finish" -t 20000
}

pastefile() { curl -F file=@"$1" https://paste.owl.cycloid.io; }

function go() {
  case $* in
    doc* )
      shift 1
      GO111MODULE=auto command go doc "$@"
      ;;
    * )
      command go "$@"
      ;;
  esac
}
###############
# SOURCES
###############

#source ~/perl5/perlbrew/etc/bashrc


#source /usr/share/nvm/init-nvm.sh

#PATH="/home/xescugc/perl5/bin${PATH:+:${PATH}}"; export PATH;
#PERL5LIB="/home/xescugc/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
#PERL_LOCAL_LIB_ROOT="/home/xescugc/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
#PERL_MB_OPT="--install_base \"/home/xescugc/perl5\""; export PERL_MB_OPT;
#PERL_MM_OPT="INSTALL_BASE=/home/xescugc/perl5"; export PERL_MM_OPT;
