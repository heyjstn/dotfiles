typeset -U path PATH

path_prepend() {
  local dir i
  for (( i = $#; i >= 1; i-- )); do
    dir="${argv[i]}"
    [[ -n "$dir" && -d "$dir" ]] && path=("$dir" $path)
  done
}

path_append() {
  local dir
  for dir in "$@"; do
    [[ -n "$dir" && -d "$dir" ]] && path+=("$dir")
  done
}

if tty -s; then
  export GPG_TTY="$(tty)"
fi

if [[ -z "${HOMEBREW_PREFIX:-}" ]]; then
  if command -v brew >/dev/null 2>&1; then
    export HOMEBREW_PREFIX="$(brew --prefix)"
  elif [[ -x /opt/homebrew/bin/brew ]]; then
    export HOMEBREW_PREFIX="$(/opt/homebrew/bin/brew --prefix)"
  elif [[ -x /usr/local/bin/brew ]]; then
    export HOMEBREW_PREFIX="$(/usr/local/bin/brew --prefix)"
  fi
fi

if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  path_prepend "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin"
fi

path_prepend \
  "$HOME/.local/bin" \
  "$HOME" \
  "$HOME/sdk/go1.24.0/bin" \
  "$HOME/sdk/go1.23.2/bin"

if command -v go >/dev/null 2>&1; then
  path_append "$(go env GOPATH 2>/dev/null)/bin"
fi

export KUBERNETES_CLI_PATH="${KUBERNETES_CLI_PATH:-$HOME}"
export HELM_PATH="${HELM_PATH:-$HOME}"
path_prepend "$KUBERNETES_CLI_PATH" "${N2C_CLI_PATH:-$HOME}" "$HELM_PATH"

kubeconfigs=()
[[ -f "$HOME/.kube/config" ]] && kubeconfigs+=("$HOME/.kube/config")
(( ${#kubeconfigs[@]} )) && export KUBECONFIG="${(j.:.)kubeconfigs}"
unset kubeconfigs

export BUN_INSTALL="$HOME/.bun"
path_prepend "$BUN_INSTALL/bin"

if command -v brew >/dev/null 2>&1; then
  sdkman_brew_prefix="$(brew --prefix sdkman-cli 2>/dev/null)"
  if [[ -n "$sdkman_brew_prefix" && -d "$sdkman_brew_prefix/libexec" ]]; then
    export SDKMAN_DIR="$sdkman_brew_prefix/libexec"
  fi
  unset sdkman_brew_prefix
fi

if [[ -z "${SDKMAN_DIR:-}" && -d "${HOMEBREW_PREFIX:-}/opt/sdkman-cli/libexec" ]]; then
  export SDKMAN_DIR="$HOMEBREW_PREFIX/opt/sdkman-cli/libexec"
fi

if [[ -n "${SDKMAN_DIR:-}" ]]; then
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
  [[ -d "$SDKMAN_DIR/candidates/java/current" ]] && export JAVA_HOME="$SDKMAN_DIR/candidates/java/current"
fi

export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_THEME=""

zstyle ':omz:plugins:eza' dirs-first yes
zstyle ':omz:plugins:eza' git-status yes

plugins=(
  git
  brew
  colored-man-pages
  fzf
  zoxide
  eza
  kubectl
  helm
  fluxcd
  bun
  golang
  nvm
  sdk
  zsh-syntax-highlighting
)

if [[ -s "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/pure.omp.json)"
fi

export EDITOR="nvim"
if [[ -n "${SSH_CONNECTION:-}" ]]; then
  export EDITOR="vim"
fi

if [[ -o interactive ]]; then
  autoload -Uz edit-command-line
  zle -N edit-command-line
  bindkey '^z^e' edit-command-line
fi

alias nv="nvim"
alias k="kubectl"
alias f="flux"
alias python35="python3.5"
command -v python3 >/dev/null 2>&1 && alias python="python3"
[[ -f "$HOME/boot.sh" ]] && alias dev="bash $HOME/boot.sh"
command -v kubecolor >/dev/null 2>&1 && alias kubectl="kubecolor"

alias -s yaml="$EDITOR"
alias -s toml="$EDITOR"
alias -s json="$EDITOR"
alias -s md="$EDITOR"

export OBSIDIAN_ICLOUD_DIR="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents"
export OBSIDIAN_DOCS_VAULT="$OBSIDIAN_ICLOUD_DIR/docs"
if [[ -d "$OBSIDIAN_DOCS_VAULT" ]]; then
  alias oo='cd "$OBSIDIAN_DOCS_VAULT"'
fi
if [[ -d "$OBSIDIAN_ICLOUD_DIR" && ! -e "$HOME/obsidian" ]]; then
  ln -s "$OBSIDIAN_ICLOUD_DIR" "$HOME/obsidian"
fi

if command -v eza >/dev/null 2>&1; then
  alias lt="eza --tree --level=2 --group-directories-first"
fi

if [[ -o interactive ]] && command -v xan >/dev/null 2>&1; then
  autoload -Uz bashcompinit
  bashcompinit

  _xan() {
    xan compgen "$1" "$2" "$3"
  }

  complete -F _xan -o default xan
fi

if [[ -r "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
