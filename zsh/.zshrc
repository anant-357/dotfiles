# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install

source ~/zsh-autocomplete/zsh-autocomplete.plugin.zsh
eval "$(starship init zsh)"
plugins=(zsh-syntax-highlighting)
echo
echo
neofetch

# Created by `pipx` on 2023-04-04 04:17:21
export PATH="$PATH:/home/vix/.local/bin"
eval "$(starship init zsh)"
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
