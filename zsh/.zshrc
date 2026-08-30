setopt promptsubst

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

if ! command -v brew >/dev/null 2>&1; then
  if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
    export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar"
    export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew"
    export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
    export MANPATH="/home/linuxbrew/.linuxbrew/share/man:${MANPATH:-}"
    export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:${INFOPATH:-}"
  elif [ -x "$HOME/.linuxbrew/bin/brew" ]; then
    export HOMEBREW_PREFIX="$HOME/.linuxbrew"
    export HOMEBREW_CELLAR="$HOME/.linuxbrew/Cellar"
    export HOMEBREW_REPOSITORY="$HOME/.linuxbrew/Homebrew"
    export PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
    export MANPATH="$HOME/.linuxbrew/share/man:${MANPATH:-}"
    export INFOPATH="$HOME/.linuxbrew/share/info:${INFOPATH:-}"
  elif [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# zinit bootstrap
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ -f "${ZINIT_HOME}/zinit.zsh" ]; then
  source "${ZINIT_HOME}/zinit.zsh"

  # plugins
  zinit light zsh-users/zsh-completions
  zinit light zsh-users/zsh-autosuggestions
  zinit light Aloxaf/fzf-tab

  # OMZ snippets
  zinit snippet OMZP::git
  zinit snippet OMZP::sudo
  zinit snippet OMZP::aws
  zinit snippet OMZP::command-not-found
  zinit cdreplay -q

  # zsh-syntax-highlighting must load after other interactive plugins.
  zinit light zsh-users/zsh-syntax-highlighting
fi

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "/home/user/.bun/_bun" ] && source "/home/user/.bun/_bun"

export LS_COLORS="${LS_COLORS:-di=38;5;110:ln=38;5;183:so=38;5;110:pi=38;5;110:ex=38;5;150:bd=38;5;109:cd=38;5;109:su=38;5;204:sg=38;5;204:tw=38;5;228:ow=38;5;228}"

# completion system
autoload -Uz compinit
if [ -n "${XDG_CACHE_HOME}" ]; then
  compinit -d "${XDG_CACHE_HOME}/zsh/.zcompdump"
else
  compinit
fi

# prompt + shell integrations
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

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

if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
  alias fd='fdfind'
fi

if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
  alias bat='batcat'
fi

# modern defaults
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix'
export FZF_DEFAULT_OPTS='--height=40% --layout=reverse --border --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#a6e3a1,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8'
export BAT_THEME='Catppuccin Mocha'
export EZA_COLORS='da=38;5;110:uu=38;5;180:gu=38;5;149'

# atuin in local mode only
export ATUIN_NOBIND="true"
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if grep -qiE "(microsoft|wsl)" /proc/version 2>/dev/null; then
  alias open='/mnt/c/Windows/explorer.exe'
  alias pbcopy='/mnt/c/Windows/System32/clip.exe'
  pbpaste() {
    /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoProfile -Command Get-Clipboard 2>/dev/null | sed 's/\r$//'
  }
fi
