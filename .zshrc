# Custom alias
# Some aliases use utilities installed on Homebrew: bat, btop, lsd, ollama, codex, fzf, gum
alias cat='bat'
alias ls='lsd -l'
alias ll='lsd -lha'
alias lt='lsd -lha --tree'
alias top='btop'

# Alias to start ollama server and kill any loaded model
alias ollama-start='echo "Starting Ollama server (verbose mode)..." && OLLAMA_HOST=127.0.0.1 OLLAMA_DEBUG=1 OLLAMA_NO_CLOUD=1 OLLAMA_CONTEXT_LENGTH=32768 ollama serve'
alias ollama-clean='ollama ps | awk "NR>1 {print \$1}" | while read model; do printf "Stopping %-30s" "$model"; if ollama stop "$model" >/dev/null 2>&1; then echo "[OK]"; else echo "[FAIL]"; fi; done'

# Codex Local with alternate screen + fzf (Catppuccin)
codex-local() {
  emulate -L zsh
  setopt noxtrace noverbose

  # --- enter alternate screen ---
  printf "\033[?1049h"
  trap 'printf "\033[?1049l"; [[ -n "$backend_pid" ]] && kill "$backend_pid" >/dev/null 2>&1' EXIT INT

  local backend backend_port
  local backend_pid=""
  local backend_started=false
  local -a models
  local codex_model

  while true; do
    clear

    # --- Backend selection ---
    backend=$(printf "Ollama\nLM Studio\nQuit\n" | \
      fzf \
        --prompt="Backend > " \
        --height=40% \
        --layout=reverse \
        --border \
        --border-label=" Codex Local " \
        --color=bg:#1e1e2e,fg:#cdd6f4,hl:#f38ba8 \
        --color=bg+:#45475a,fg+:#f5e0dc,hl+:#f38ba8 \
        --color=info:#89b4fa,prompt:#cba6f7,pointer:#fab387 \
        --color=marker:#f5e0dc,spinner:#f5e0dc,header:#a6e3a1 \
        --color=border:#b4befe,label:#cba6f7 \
        --header="Select backend (ESC to quit)") || return 0

    [[ "$backend" == "Quit" ]] && return 0

    case "$backend" in
      "Ollama") backend_port=11434 ;;
      "LM Studio") backend_port=1234 ;;
      *) continue ;;
    esac

    # --- Ensure backend is running ---
    if ! nc -z 127.0.0.1 "$backend_port" >/dev/null 2>&1; then
      if [[ "$backend" == "Ollama" ]]; then
        OLLAMA_HOST=127.0.0.1 OLLAMA_DEBUG=0 OLLAMA_NO_CLOUD=1 ollama serve >/dev/null 2>&1 &
      else
        lms server start >/dev/null 2>&1 &
      fi
      backend_pid=$!
      backend_started=true
      sleep 1
    fi

    # --- Load models ---
    if [[ "$backend" == "Ollama" ]]; then
      models=( $(ollama list 2>/dev/null | awk 'NR>1 {print $1}') )
    else
      models=( $(lms ls 2>/dev/null | awk '/^LLM/ {in=1; next} /^EMBEDDING/ {in=0} in {print $1}') )
    fi

    [[ ${#models[@]} -eq 0 ]] && continue

    # --- Model selection ---
    if [[ "$backend" == "Ollama" ]]; then
      codex_model=$( (printf "%s\n" "${models[@]}"; echo "← Back") | \
        fzf \
          --prompt="Model > " \
          --height=70% \
          --layout=reverse \
          --border \
          --border-label=" Ollama Models " \
          --preview 'ollama show {} 2>/dev/null | sed -n "1,60p"' \
          --preview-window=right:60% \
          --color=bg:#1e1e2e,fg:#cdd6f4,hl:#f38ba8 \
          --color=bg+:#45475a,fg+:#f5e0dc,hl+:#f38ba8 \
          --color=info:#89b4fa,prompt:#cba6f7,pointer:#fab387 \
          --color=marker:#f5e0dc,spinner:#f5e0dc,header:#a6e3a1 \
          --color=border:#b4befe,label:#cba6f7) || continue
    else
      codex_model=$( (printf "%s\n" "${models[@]}"; echo "← Back") | \
        fzf \
          --prompt="Model > " \
          --height=60% \
          --layout=reverse \
          --border \
          --border-label=" LM Studio Models " \
          --color=bg:#1e1e2e,fg:#cdd6f4,hl:#f38ba8 \
          --color=bg+:#45475a,fg+:#f5e0dc,hl+:#f38ba8 \
          --color=info:#89b4fa,prompt:#cba6f7,pointer:#fab387 \
          --color=marker:#f5e0dc,spinner:#f5e0dc,header:#a6e3a1 \
          --color=border:#b4befe,label:#cba6f7) || continue
    fi

    if [[ "$codex_model" == "← Back" ]]; then
      if [[ "$backend_started" == true ]]; then
        kill "$backend_pid" >/dev/null 2>&1 || true
        backend_started=false
        backend_pid=""
      fi
      continue
    fi

    [[ -z "$codex_model" ]] && continue

    command codex --oss -m "$codex_model"

    if [[ "$backend_started" == true ]]; then
      if [[ "$backend" == "Ollama" ]]; then
        ollama stop "$codex_model" >/dev/null 2>&1 || true
      else
        lms unload "$codex_model" >/dev/null 2>&1 || true
      fi
      kill "$backend_pid" >/dev/null 2>&1 || true
      backend_started=false
      backend_pid=""
    fi
  done
}


# Node Version Manager
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

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
export STARSHIP_CONFIG="$HOME/.config/starship/starship_text.toml"
eval "$(starship init zsh)"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/ruben/.lmstudio/bin"
# End of LM Studio CLI section

# Ollama models
export OLLAMA_MODELS=/Volumes/Lexar-NM620/AI-Resources/ollama-models

# Disable Homebrew hints
export HOMEBREW_NO_ENV_HINTS=1

# Claude Code using local LLM
export ANTHROPIC_BASE_URL=http://localhost:1234
export ANTHROPIC_AUTH_TOKEN=lmstudio
