#WIP

#Turn git colors on
git config --global color.ui true


# Colors
# Source: @garybernhardt https://github.com/garybernhardt/dotfiles/blob/master/bin/bash_colors.sh
DULL=0
BRIGHT=1

FG_BLACK=30
FG_RED=31
FG_GREEN=32
FG_YELLOW=33
FG_BLUE=34
FG_VIOLET=35
FG_CYAN=36
FG_WHITE=37

FG_NULL=00

BG_BLACK=40
BG_RED=41
BG_GREEN=42
BG_YELLOW=43
BG_BLUE=44
BG_VIOLET=45
BG_CYAN=46
BG_WHITE=47

BG_NULL=00
##
# ANSI Escape Commands
##
ESC="\033"
NORMAL="$ESC[m"
RESET="$ESC[${DULL};${FG_WHITE};${BG_NULL}m"

BLACK="$ESC[${DULL};${FG_BLACK}m"
RED="$ESC[${DULL};${FG_RED}m"
GREEN="$ESC[${DULL};${FG_GREEN}m"
YELLOW="$ESC[${DULL};${FG_YELLOW}m"
BLUE="$ESC[${DULL};${FG_BLUE}m"
VIOLET="$ESC[${DULL};${FG_VIOLET}m"
CYAN="$ESC[${DULL};${FG_CYAN}m"
WHITE="$ESC[${DULL};${FG_WHITE}m"

# BRIGHT TEXT
BRIGHT_BLACK="$ESC[${BRIGHT};${FG_BLACK}m"
BRIGHT_RED="$ESC[${BRIGHT};${FG_RED}m"
BRIGHT_GREEN="$ESC[${BRIGHT};${FG_GREEN}m"
BRIGHT_YELLOW="$ESC[${BRIGHT};${FG_YELLOW}m"
BRIGHT_BLUE="$ESC[${BRIGHT};${FG_BLUE}m"
BRIGHT_VIOLET="$ESC[${BRIGHT};${FG_VIOLET}m"
BRIGHT_CYAN="$ESC[${BRIGHT};${FG_CYAN}m"
BRIGHT_WHITE="$ESC[${BRIGHT};${FG_WHITE}m"



notify() {
	printf "[*] $1\n"
}

warning() {
	printf "${YELLOW}[!]${NORMAL} $1\n"
}

error() {
	printf "${BRIGHT_RED}[X]${NORMAL} $1\n"
}

backup() {
	warning "Backing up \"$1\" to \"${1}.backup\""
	mv $1{,.backup}
}

dotfiles=(".bash_aliases" ".bashrc" ".htoprc" ".nanorc" ".screenrc")

for dotfile in "${dotfiles[@]}"; do
	homedotfile="$(eval echo '~/${dotfile}')"
	this=$(pwd)

	#Backup dotfile if it is a file
	[ -f "${homedotfile}" ] && [ ! -L "${homedotfile}" ] && warning "~/$dotfile already exists" && backup "${homedotfile}"
	#Create dotfile symlink
	[ ! -L "${homedotfile}" ] && [ ! -f "${homedotfile}" ] && notify "Creating Symlink: ${this}/${dotfile} => ~/${dotfile}" && ln -s "${this}/${dotfile}" "${homedotfile}"

done

###
# Dependency Check
###
[ ! -f /usr/share/git/completion/git-prompt.sh ] && [ ! -f /etc/bash_completion.d/git ] && error "Could not find git-prompt.sh"
[ ! -f /usr/share/git/completion/git-completion.bash ] && [ ! -f /etc/bash_completion.d/git ] && error "Your prompt doesn't have git autocompletion enabled."


