#Add paths
export PATH="~/bin:$PATH"

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=1000
EDITOR=nano
fpath=(~/.zsh/functions $fpath)

source ~/.zsh/git-prompt.sh
source ~/.zsh/keymap.sh

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/travis/.zsh'



autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2 eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# End of lines added by compinstall

autoload -U colors && colors

# Git prompt components
# Source: @garybernhardt https://github.com/garybernhardt/dotfiles/blob/master/.bashrc

function minutes_since_last_commit {
    now=`date +%s`
    last_commit=`git log --pretty=format:'%at' -1`
    seconds_since_last_commit=$((now-last_commit))
    minutes_since_last_commit=$((seconds_since_last_commit/60))
    echo $minutes_since_last_commit
}
grb_git_prompt() {
    local g="$(__git_ps1)"
    if [ -n "$g" ]; then
        local MINUTES_SINCE_LAST_COMMIT=`minutes_since_last_commit`
	time="$MINUTES_SINCE_LAST_COMMIT"

	local format="m"
        if [ "$MINUTES_SINCE_LAST_COMMIT" -gt 30 ]; then
            local COLOR="%{$fg_no_bold[red]%}"
        elif [ "$MINUTES_SINCE_LAST_COMMIT" -gt 10 ]; then
            local COLOR="%{$fg_no_bold[yellow]%}"
        else
            local COLOR="%{$fg_no_bold[green]%}"
        fi

	if [ "$MINUTES_SINCE_LAST_COMMIT" -gt 1440 ]; then
		time="$(expr $MINUTES_SINCE_LAST_COMMIT / 1440 )"
		format="d"
	elif [ "$MINUTES_SINCE_LAST_COMMIT" -gt 60 ]; then
		time="$(expr $MINUTES_SINCE_LAST_COMMIT / 60)"
		format="h"
	fi

        local SINCE_LAST_COMMIT="${time}${format}"
        # The __git_ps1 function inserts the current git branch where %s is
        local BRANCH=`__git_ps1 "%s"`
        echo " (${BRANCH}|%{$COLOR%}${time}${format}%{$reset_color%})"
    fi
}
PROMPT='%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m%{$reset_color%}:%{$fg_no_bold[yellow]%}%1~%{$reset_color%}$(grb_git_prompt)\$ '
RPROMPT="[%{$fg_no_bold[yellow]%}%?%{$reset_color%}]"

setopt prompt_subst

DIRSTACKFILE="$HOME/.cache/zsh/dirs"
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

DIRSTACKSIZE=20

setopt autopushd pushdsilent pushdtohome

## Remove duplicate entries
setopt pushdignoredups

## This reverts the +/- operators.
setopt pushdminus
