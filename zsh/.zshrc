export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)
source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
eval "$(direnv hook zsh)"
[ -f ~/.env ] && source ~/.env

# Functions
gub() {
  local current_branch
  local target_branch

  current_branch=$(git branch --show-current)
  target_branch="$1"

  if [ -z "$target_branch" ]; then
    echo "Uso: gupdatebranch <branch>"
    return 1
  fi

  if [ -z "$current_branch" ]; then
    echo "Erro: não foi possível detectar a branch atual."
    return 1
  fi

  git checkout "$target_branch" &&
  git fetch origin &&
  git pull origin "$target_branch" &&
  git checkout "$current_branch"
}

# Aliases
alias vps-connect='ssh $VPS_USER@$VPS_IP'

# uv
export PATH="$HOME/.local/bin:$PATH"
# opencode
export PATH=$HOME/.opencode/bin:$PATH
