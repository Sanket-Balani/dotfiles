setopt promptsubst

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Corporate TLS inspection CA bundle for AWS CLI, boto3/botocore, and requests.
export AWS_CA_BUNDLE="/opt/homebrew/etc/openssl@3/cert.pem"
export REQUESTS_CA_BUNDLE="/opt/homebrew/etc/openssl@3/cert.pem"

# zinit bootstrap
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" || true
fi

# completion system
autoload -Uz compinit
if [ -n "${XDG_CACHE_HOME}" ]; then
  compinit -d "${XDG_CACHE_HOME}/zsh/.zcompdump"
else
  compinit
fi

if [ -f "${ZINIT_HOME}/zinit.zsh" ]; then
  source "${ZINIT_HOME}/zinit.zsh"

  # plugins
  zinit light zsh-users/zsh-syntax-highlighting
  zinit light zsh-users/zsh-completions
  zinit light zsh-users/zsh-autosuggestions
  zinit light Aloxaf/fzf-tab

  # OMZ snippets
  zinit snippet OMZP::git
  zinit snippet OMZP::sudo
  zinit snippet OMZP::aws
  zinit snippet OMZP::command-not-found
  zinit cdreplay -q
fi

# prompt + shell integrations
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(fzf --zsh)"

# history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

# keymaps: full vi mode
KEYTIMEOUT=1
bindkey -v
bindkey '^R' history-incremental-search-backward

# completion behavior
zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompcache"

# fzf-tab previews
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --icons=always --group-directories-first --all --long $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always --icons=always --group-directories-first --all --long $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -d $realpath ]] && eza --color=always --icons=always --group-directories-first --all --long $realpath || bat --style=plain --color=always --line-range=:200 $realpath'

# aliases
alias ls='eza --group-directories-first --icons=auto'
alias ll='eza --group-directories-first --icons=auto -lah'
alias la='eza --group-directories-first --icons=auto -a'
alias lt='eza --group-directories-first --icons=auto --tree --level=2'
alias cat='bat --style=plain'
alias c='clear'
alias vim='nvim'
alias gs='git status'

# modern defaults
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix'
export BAT_THEME='Catppuccin Mocha'
export EZA_COLORS='da=38;5;110:uu=38;5;180:gu=38;5;149'

# bun runtime
if [ -d "$HOME/.bun/bin" ]; then
  export PATH="$HOME/.bun/bin:$PATH"
fi

# atuin in local mode only
export ATUIN_NOBIND="true"
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Android SDK
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"

export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH="$JAVA_HOME/bin:$PATH"
