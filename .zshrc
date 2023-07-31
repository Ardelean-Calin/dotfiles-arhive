source ~/.zplug/init.zsh

zplug "embeddedpenguin/sanekeybinds"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
# Install plugins if they are not installed.
if ! zplug check --verbose; then
    echo; zplug install
fi
# Load the plugins
zplug load

alias config="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias ls="exa"
alias vim="nvim"
alias vi="nvim"

# Enable cht.sh autocompletions
# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases
fpath=(~/.zsh.d/ $fpath)

# Last step, enable starship prompt.
eval "$(starship init zsh)"
