
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="eastwood"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Prompt with git branch
function parse_git_branch() {
    local branch=$(git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/\1/p')
    if [ -n "$branch" ]; then
        echo "[${branch}]"
    fi
}
setopt PROMPT_SUBST
export PROMPT='%{${fg[cyan]}%}[%~]%{${fg[magenta]}%}$(parse_git_branch)%{$fg[green]%} $ %{${fg[default]}%}'

# General
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
export EDITOR="nvim"
setopt AUTO_CD

# History
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

# Homebrew completions
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"


alias zshconfig="nvim ~/.zshrc"
unalias ls
alias ls='ls -a --color=always'
unalias lsa
alias lsa='eza -a --icons'

alias tree='eza -Ta --level=5 --git-ignore --color=always --icons=always| head -n 300'

# Passwords stored with pass
# export GEMINI_API_KEY=$(pass show vertex_api)
# export ANTHROPIC_API_KEY=$(pass show claude)


# Added by Antigravity
export PATH="/Users/annasmith/.antigravity/antigravity/bin:$PATH"
