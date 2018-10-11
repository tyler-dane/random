
# Exports
export ZSH=/Users/ty/.oh-my-zsh # Path to your oh-my-zsh installation.
export SONAR='/Users/ty/src/sonarqube-6.7.4/bin/macosx-universal-64/' #sonarqube
export SLEEP_BASE=/Users/ty/src/gitlab/drive-api-testing

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="strug"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
a  git
docker
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"


#===========================STUFF ADDED BY TYLER H ===================

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HYPHEN_INSENSITIVE="true"


#SSH sign in - need to modify for ZSH
lgn () {

    base_ip="192.168.1.110"

    IFS='.' read -ra provided_ip <<< "$1"
    IFS='.' read -ra standard_ip <<< "$base_ip"

    start=$(expr ${#standard_ip[@]} - ${#provided_ip[@]}) 

    ip=()

    for (( subnet=0; subnet<"$start"; subnet++ )); 
    do 
      ip+=(${standard_ip[$subnet]})
    done
    
    for (( subnet=0; subnet<${#provided_ip[@]}; subnet++ )); 
    do 
      ip+=(${provided_ip[$subnet]})
    done

    function join_by { 
        local IFS="$1"; shift; echo "$*"; 
    }

    final_ip=$(join_by . "${ip[@]}")

    ssh dmin@$final_ip
}


# !!!!!!!!!!!!!!!!!!!!!!!!! ALIASES !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
alias zre="source ~/.zshrc"
alias plz="sudo !!"
alias gc=gcmsg
alias ls="ls -GFha"
alias zre="source ~/.zshrc"

# TY'S ALIASES
## General:
alias gthb='cd /Users/ty/src/github'
alias rpsql='brew services restart postgresql'
alias p='prometheus'
alias ports1='sudo lsof -PiTCP -sTCP:LISTEN'
alias src='cd /Users/ty/src'
alias wtf='echo "You got this, dawg!"'

## Sonar:
alias startsonar='cs && $SONAR/sonar.sh console'
alias stopsonar='$SONAR/sonar.sh stop'
alias restartsonar='$SONAR/sonar.sh restart'

## Docker
#alias stats='docker ps -q | xargs  docker stats'
alias dp='docker ps'
alias dls='docker container ls'
alias dlsa='docker container ls -a'
alias stats='sudo docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}\t{{.PIDs}}"'
alias statsf='sudo docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}\t{{.PIDs}}"'
alias statsno='docker ps -q | xargs  docker stats --no-stream'
alias vz='vim ~/.zshrc'

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export NVM_DIR="/Users/ty/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# $1 = type; 0 - both, 1 - tab, 2 - title
# rest = text
#setTerminalText () {
#    # echo works in bash & zsh
#    local mode=$1 ; shift
#    echo -ne "\033]$mode;$@\007"
#}
#stt_both  () { setTerminalText 0 $@; }
#stt_tab   () { setTerminalText 1 $@; }
#stt_title () { setTerminalText 2 $@; }

export PATH="/usr/local/bin:$PATH"
