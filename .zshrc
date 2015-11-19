# Path to your ohmy-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"
#ZSH_THEME="pygmalion"
#ZSH_THEME="robbyrussell"
#avit
#dogenpunk
#flazz
#smt
#sorin
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
ZSH_TMUX_AUTOSTART="false"
ZSH_TMUX_AUTOSTART_ONCE="true"
ZSH_TMOX_FIXTERM="false"
plugins=(git osx brew vi-mode web-search wd node npm sudo tmux fancy-ctrl-z)

source $ZSH/oh-my-zsh.sh

# User configuration

#export PATH="/opt/chefdk/embedded/bin:${HOME}/.chefdk/gem/ruby/2.1.0/bin:$PATH"
export PATH=$HOME/packer:$PATH
export PATH=$HOME/bin:/usr/local/bin:$PATH
export VAGRANT_HOME="/Volumes/LaCie/vagrant_home"
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
# export SSH_KEY_PATH="~/.ssh/dsa_id"
#
unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/help
VAGRANT_DEFAULT_PROVIDER=vmware_fusion
# Vim like completions of previous executed commands (also enter Vi-mode). If
# called at the beginning it just recalls old commands (like cursor up), if
# called after typing something, only lines starting with the typed text are
# returned. Very useful to get old commands quickly - in addition to the
# historW commands (!..). Thanks to Mikachu in #zsh on Freenode (2010-01-17
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
export WORDCHARS='*?[]~&;!$%^<>'
export EDITOR=vim
setopt extendedglob
unsetopt correctall
function marked {
    open -a marked.app $1
}

#disable flow control (for C-s to work in vim)
stty stop undef
stty start undef

[[ -f "~/.$TERM.ti" ]] && tic ~/.$TERM.ti
alias vim='nvim'

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
#export PATH=/opt/chefdk/bin:/Users/johan/.chefdk/gem/ruby/2.1.0/bin:/opt/chefdk/embedded/bin:/usr/local/heroku/bin:/Users/johan/bin:/usr/local/bin:/Users/johan/packer:/opt/chefdk/embedded/bin:/Users/johan/.chefdk/gem/ruby/2.1.0/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/CrossPack-AVR/bin:/usr/local/heroku/bin:/Users/johan/bin:/Users/johan/packer:/opt/chefdk/embedded/bin:/Users/johan/.chefdk/gem/ruby/2.1.0/bin
export PATH=/usr/local/heroku/bin:/Users/johan/bin:/usr/local/bin:/Users/johan/packer:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/CrossPack-AVR/bin:/usr/local/heroku/bin:/Users/johan/bin:/Users/johan/packer
export PATH="/opt/chefdk/bin:/Users/johan/.chefdk/gem/ruby/2.1.0/bin:/opt/chefdk/embedded/bin:$PATH"
export GEM_ROOT="/opt/chefdk/embedded/lib/ruby/gems/2.1.0"
export GEM_HOME=/Users/johan/.chefdk/gem/ruby/2.1.0
export GEM_PATH=/Users/johan/.chefdk/gem/ruby/2.1.0:/opt/chefdk/embedded/lib/ruby/gems/2.1.0
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
