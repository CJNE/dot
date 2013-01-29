eval "$(fasd --init auto)"
# Set custom prompt
setopt PROMPT_SUBST
autoload -U promptinit
promptinit
prompt grb

# Initialize completion
autoload -U compinit
compinit

#Java
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/
# Add paths
export PATH=/usr/local/sbin:/usr/local/bin:${PATH}
export EC2_HOME="$HOME/ec2-api-tools"
export PATH="$EC2_HOME/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# Colorize terminal
eval `gdircolors $HOME/.dir_colors`
export TERM='xterm-256color'
alias ls='gls --color=auto'
alias ll='gls -l --color=auto'
#export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export GREP_OPTIONS="--color"


# I don't need the arrow keys, I use ^N and ^P for this (see below).
bindkey -r '^[OA' '^[OB' '^[OC' '^[OD' '^[[A' '^[[B' '^[[C' '^[[D'
# Also not in Vi mode.
bindkey -a -r '^[OA' '^[OB' '^[OC' '^[OD' '^[[A' '^[[B' '^[[C' '^[[D'

# Nicer history
export HISTSIZE=100000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

# Append to the history file instead of overwriting it and do it immediately
# when a command is executed.
setopt appendhistory
setopt incappendhistory
# If the same command is run multiple times store it only once in the history.
setopt histignoredups
# Don't add lines starting with a space to the history.
setopt histignorespace
# Vim like completions of previous executed commands (also enter Vi-mode). If
# called at the beginning it just recalls old commands (like cursor up), if
# called after typing something, only lines starting with the typed text are
# returned. Very useful to get old commands quickly - in addition to the
# history commands (!..). Thanks to Mikachu in #zsh on Freenode (2010-01-17
# 12:47 CET) for the information how to a use function with bindkey.
zle -N my-vi-history-beginning-search-backward
my-vi-history-beginning-search-backward() {
    local not_at_beginning_of_line
    if [[ $CURSOR -ne 0 ]]; then
        not_at_beginning_of_line=yes
    fi

    zle history-beginning-search-backward

    # Start Vi-mode and stay at the same position (Vi-mode moves one left,
    # this counters it).
    zle vi-cmd-mode
    if [[ -n $not_at_beginning_of_line ]]; then
        zle vi-forward-char
    fi
}
bindkey '^P' my-vi-history-beginning-search-backward
bindkey -a '^P' history-beginning-search-backward # binding for Vi-mode
# Here only Vi-mode is necessary as ^P enters Vi-mode and ^N only makes sense
# after calling ^P.
bindkey -a '^N' history-beginning-search-forward

# Use vim as the editor
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
alias vi='/Applications/MacVim.app/Contents/MacOS/Vim'
export EDITOR=vi
set -o vi

# Use jj and jk to exit insert mode.
bindkey 'jj' vi-cmd-mode
bindkey 'jk' vi-cmd-mode

# Use C-x C-e to edit the current command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# By default, zsh considers many characters part of a word (e.g., _ and -).
# Narrow that down to allow easier skipping through words via M-f and M-b.
export WORDCHARS='*?[]~&;!$%^<>'

# Highlight search results in ack.
export ACK_COLOR_MATCH='red'

# Aliases
alias r=rails
#alias t="script/test $*"
#alias f="script/features $*"
alias weechat="TERM=screen-256color weechat-curses"
function mcd() { mkdir -p $1 && cd $1 }
function cdf() { cd *$1*/ } # stolen from @topfunky

# Activate the closest virtualenv by looking in parent directories.
activate_virtualenv() {
    if [ -f env/bin/activate ]; then . env/bin/activate;
    elif [ -f ../env/bin/activate ]; then . ../env/bin/activate;
    elif [ -f ../../env/bin/activate ]; then . ../../env/bin/activate;
    elif [ -f ../../../env/bin/activate ]; then . ../../../env/bin/activate;
    fi
}


# By @ieure; copied from https://gist.github.com/1474072
#
# It finds a file, looking up through parent directories until it finds one.
# Use it like this:
#
#   $ ls .tmux.conf
#   ls: .tmux.conf: No such file or directory
#
#   $ ls `up .tmux.conf`
#   /Users/grb/.tmux.conf
#
#   $ cat `up .tmux.conf`
#   set -g default-terminal "screen-256color"
#
function up()
{
    local DIR=$PWD
    local TARGET=$1
    while [ ! -e $DIR/$TARGET -a $DIR != "/" ]; do
        DIR=$(dirname $DIR)
    done
    test $DIR != "/" && echo $DIR/$TARGET
}

# Initialize RVM
PATH=$PATH:$HOME/.rvm/bin
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

