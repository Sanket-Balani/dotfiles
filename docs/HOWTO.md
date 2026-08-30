# Dotfiles How-To

This document explains what was installed, how to use it, and how to maintain it.

## 1) What this setup includes

- Shell: Zsh + zinit + starship + zoxide + fzf + fzf-tab
- Window manager: AeroSpace (keyboard-first tiling workspaces)
- Terminal: Ghostty (Catppuccin Mocha + JetBrains Mono Nerd Font)
- Editor: Neovim (LazyVim base, Catppuccin Mocha, Treesitter, Telescope stack via LazyVim)
- Multiplexer: tmux + TPM + resurrect + continuum
- File manager: yazi
- CLI toolkit: `rg`, `fd`, `bat`, `eza`, `jq`, `gh`, `lazygit`, `atuin`
- Dotfiles management: GNU Stow

## 2) Repo layout

- `Brewfile`: package manifest
- `script/bootstrap`: install + backup conflicts + stow + post-setup
- `script/doctor`: health/validation checks
- `zsh/`: `.zshenv`, `.zprofile`, `.zshrc`
- `starship/.config/starship.toml`
- `ghostty/.config/ghostty/config`
- `aerospace/.aerospace.toml`
- `tmux/.tmux.conf`, `tmux/.config/tmux/tmux.conf`
- `nvim/.config/nvim/...`
- `yazi/.config/yazi/...`
- `docs/SETUP.md`, `docs/KEYMAPS.md`, `docs/HOWTO.md`

## 3) Bootstrap and recovery

Run this on a fresh machine or after major changes:

```bash
cd ~/dotfiles
./script/bootstrap --force
```

Useful options:

- `--no-cask`: skip casks
- `--skip-nvim`: skip Neovim headless sync
- `--force`: backup conflicting files first

Backups go to:

- `~/dotfiles-backups/<timestamp>/`

## 4) Daily operations

### Pull latest and apply

```bash
cd ~/dotfiles
git pull
brew bundle --file Brewfile
stow --restow zsh starship ghostty aerospace tmux nvim yazi
./script/doctor
```

### Validate setup

```bash
~/dotfiles/script/doctor
```

## 5) Zsh behavior and aliases

Configured in `zsh/.zshrc`:

- vi mode: `bindkey -v` with fast mode switch (`KEYTIMEOUT=1`)
- history options:
  - `APPEND_HISTORY`, `SHARE_HISTORY`, `HIST_IGNORE_SPACE`
  - `HIST_IGNORE_ALL_DUPS`, `HIST_IGNORE_DUPS`
  - `HIST_SAVE_NO_DUPS`, `HIST_FIND_NO_DUPS`
  - `INC_APPEND_HISTORY`, `EXTENDED_HISTORY`
- completion:
  - case-insensitive + flexible matching
  - fzf-tab previews with `eza`/`bat`
- integrations:
  - `starship init`
  - `zoxide init --cmd cd`
  - `fzf --zsh`

Aliases:

- `ls='eza --group-directories-first --icons=auto'`
- `ll`, `la`, `lt`
- `cat='bat --style=plain'`
- `c='clear'`
- `vim='nvim'`

## 6) Ghostty

Config path:

- `~/.config/ghostty/config`

Key settings:

- font: JetBrains Mono Nerd Font
- theme: Catppuccin Mocha palette
- shell: `/bin/zsh -l`

## 7) Neovim

Config path:

- `~/.config/nvim`

Highlights:

- LazyVim base + local overrides
- colorscheme forced to `catppuccin`
- terminal mode `<Esc>` -> `<C-\\><C-n>`
- yazi mapping: `<leader>-`
- lazygit mapping: `<leader>gg`
- Harpoon mappings: `<leader>ha`, `<leader>hh`, `<leader>h1..h4`
- Undo tree mapping: `<leader>uT`
- Surround edits via `nvim-surround`
- Better tmux split navigation via `vim-tmux-navigator`

Provider policy:

- Python provider enabled via local venv at:
  - `~/.local/share/nvim/python3/bin/python3`
- Perl/Ruby/Node providers disabled to avoid unnecessary checkhealth noise unless you need them.

If you need Node provider later:

```bash
brew install node
npm install -g neovim
# then remove `vim.g.loaded_node_provider = 0` from nvim options
```

## 8) tmux

Config paths:

- `~/.tmux.conf` (shim)
- `~/.config/tmux/tmux.conf` (main)

Prefix:

- `Ctrl-Space`

Plugins installed via TPM:

- `tmux-sensible`
- `vim-tmux-navigator`
- `catppuccin/tmux`
- `tmux-yank`
- `tmux-resurrect`
- `tmux-continuum`
- `tmux-open`
- `tmux-prefix-highlight`
- `tmux-fzf`

Reinstall/update tmux plugins:

```bash
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all
```

## 9) Stow model

From repo root:

```bash
cd ~/dotfiles
stow --restow zsh starship ghostty aerospace tmux nvim yazi
```

Unstow one package:

```bash
stow -D zsh
```

## 10) Window management (AeroSpace)

Install and apply:

```bash
cd ~/dotfiles
brew bundle --file Brewfile
stow --restow aerospace
```

Verify config is linked:

```bash
ls -la ~/.aerospace.toml
./script/doctor
```

Reload AeroSpace config after edits:

1. Press `Alt+Shift+;` to enter service mode.
2. Press `r` to reload config and return to main mode.

Workspace routing:

- `1`: Browser (`app.zen-browser.zen`)
- `2`: Editors (`com.todesktop.230313mzl4w4u92`, `com.microsoft.VSCode`)
- `3`: Terminal (`com.mitchellh.ghostty`)
- `4`: Reserved chat/collaboration
- `9`: Utilities

Keybindings:

- `Alt+1..9`: focus workspace
- `Alt+Shift+1..9`: move focused window to workspace
- `Alt+h/j/k/l`: focus neighbor
- `Alt+Shift+h/j/k/l`: move window
- `Alt+Tab` / `Alt+Shift+Tab`: cycle windows in current workspace
- `Alt+.` / `Alt+,`: fallback workspace-local window cycle (if Tab is intercepted)
- `Cmd+Tab` / `Cmd+Shift+Tab`: workspace-local window cycling override
- `Alt+f`: toggle fullscreen
- `Alt+Shift+f`: toggle floating <-> tiling for focused window
- `Alt+/`: toggle layout orientation
- `Alt+Enter`: rebalance tile sizes

## 11) How to add new tools/config

1. Add package to `Brewfile`.
2. Add config under matching package dir (e.g. `tool/.config/tool/...`).
3. Re-run stow:

```bash
stow --restow tool
```

4. Run doctor:

```bash
./script/doctor
```

## 12) Troubleshooting

### zinit/plugin clone failures

- Usually transient DNS/network issue.
- Retry by opening new shell or running:

```bash
exec zsh
```

### Neovim plugin/network issues

```bash
nvim --headless "+Lazy! sync" +qa
```

### Neovim checkhealth notes

- `which-key` overlap warnings (for keys like `gc`, `i`, `a`) are informational upstream checks and do not mean mappings are broken.
- `norg` is mapped to the `markdown` Treesitter parser to keep Snacks image/docs checks green without adding Neorg-specific parser maintenance.
- `yazi.nvim` warning about `grealpath` is fixed by installing `coreutils` (`brew install coreutils`).

### Rebuild everything from scratch

```bash
cd ~/dotfiles
./script/bootstrap --force
```
