if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    zsh-autosuggestions 
    zsh-syntax-highlighting
    zsh-autocomplete
)

source $ZSH/oh-my-zsh.sh

[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

[ -f ~/.zsh_functions ] && source ~/.zsh_functions

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

(cat ~/.cache/wal/sequences &)
