# Custom alias
# Some aliaes use utilities installed on Homebrew: bat, btop, lsd
alias cat='bat'
alias ls='lsd -l'
alias ll='lsd -lha'
alias lt='lsd -lha --tree'
alias top='btop'

# Disable .NET Telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=true

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Textmate shell support
#export EDITOR="/usr/local/bin/mate -w"

# Mise
eval "$(~/.local/bin/mise activate zsh)"

# Oh My Posh
#eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/lord-of-illusions.omp.json)"

# Activate syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Disable underline
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# Activate autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship_catppuccin.toml"
eval "$(starship init zsh)"
