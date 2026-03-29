ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)

eval "$(direnv hook zsh)"

[ -f ~/.env ] && source ~/.env
