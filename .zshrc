# Custom alias
# Some aliases use utilities installed on Homebrew: bat, btop, lsd, ollama, codex, fzf, gum
alias cat='bat'
alias ls='lsd -l'
alias ll='lsd -lha'
alias lt='lsd -lha --tree'
alias top='btop'

# Set Claude variables to use with local LLM
claude-local() {
  export ANTHROPIC_BASE_URL=http://localhost:1234
  export ANTHROPIC_AUTH_TOKEN=lmstudio
}

# Unset Claude variables to use with Anthropic account
claude-anthropic() {
  unset ANTHROPIC_BASE_URL
  unset ANTHROPIC_AUTH_TOKEN
}

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Mise
eval "$(~/.local/bin/mise activate zsh)"

# Activate syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Disable underline
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# Activate autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship_text.toml"
eval "$(starship init zsh)"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/ruben/.lmstudio/bin"
# End of LM Studio CLI section

# Ollama models
export OLLAMA_MODELS=/Volumes/Lexar-NM620/AI-Resources/ollama-models

# Disable Homebrew hints
export HOMEBREW_NO_ENV_HINTS=1

# Added by cua-driver-rs installer — see https://github.com/trycua/cua
export PATH="/Users/ruben/.local/bin:$PATH"
