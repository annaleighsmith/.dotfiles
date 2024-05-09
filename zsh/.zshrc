#              _
#             | |
#      _______| |__  _ __ ___
#     |_  / __| '_ \| '__/ __|
#    _ / /\__ \ | | | | | (__
#   (_)___|___/_| |_|_|  \___|


pfetch
# oh-my-zsh & prompt
# ------------------------------>
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# ZSH_THEME="eastwood"
#
# function parse_git_branch() {
#     git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/\\ \1/p'
# }
function parse_git_branch() {
    local branch=$(git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/\\ \1/p')
    if [ -n "$branch" ]; then
        echo "[${branch}]"
    fi
}
setopt PROMPT_SUBST # probably already done by oh-my-zsh

export PROMPT='%{${fg[cyan]}%}[%~]%{${fg[magenta]}%}$(parse_git_branch)%{$fg[green]%} $ %{${fg[default]}%}'



# path variables
# ------------------------------>
export PATH=/home/anna/context/tex/texmf-linux-64/bin:$PATH
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:/home/anna/go/bin
export GRIM_DEFAULT_DIR=$HOME/screenshots/
export XDG_CURRENT_DESKTOP="sway"
export CALIBRE_USE_SYSTEM_THEME=true
export SDL_VIDEODRIVER="wayland"
export OPENWEATHER_API_KEY=$(</home/anna/.openweatherapikey)
export OPENAI_API_KEY=$(</home/anna/.chatgptapikey)
# export STARSHIP_CONFIG=~/.config/starship.toml
# other variables
# ------------------------------>
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANGUAGE=en_Us.UTF-8
export TERM="kitty"
export EDITOR="nvim"
export ARCHFLAGS="-arch x86_64"
export MANPATH="/usr/local/man:$MANPATH"
export BAT_THEME="Nord"
export PAGER="nvimpager"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# --> source profile from zsh
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

# general
# ------------------------------>
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
#
# --> Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
# HIST_STAMPS="mm/dd/yyyy"
#
# oh-my-zsh updates
# ------------------------------>
zstyle ':omz:update' mode reminder  # just remind me to update when it's time
# if auto updating
# zstyle ':omz:update' frequency 13

# plugins
# ------------------------------>
# plugins=(git)

# alias
# ------------------------------>
unalias l
unalias ll
unalias la
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
# alias cat="bat"
alias l='exa --icons --group-directories-first'
alias ls='exa -a --icons --group-directories-first'
alias lsa='exa -a --header --icons --group-directories-first --long --git'
# alias tree='exa -a --icons --group-directories-first --tree --level=3'
alias pdf='zathura --fork'
alias prism='cd ~/.local/share/PrismLauncher/'

# auto generated by conda
# ------------------------------>
__conda_setup="$('/home/anna/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/anna/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/anna/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/anna/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# startship
# ------------------------------>
# starship is bloat?
# eval "$(starship init zsh)"
