# dotfiles

Modern macOS keyboard-first environment:

- AeroSpace (i3-style tiling workspaces on macOS)
- Ghostty + Catppuccin Mocha
- Zsh + Zinit + Starship + zoxide + fzf-tab
- LazyVim (Neovim)
- tmux + TPM + resurrect/continuum
- yazi + modern CLI tools

## Bootstrap

```bash
cd ~/dotfiles
./script/bootstrap --force
```

## Validate

```bash
./script/doctor
```

## Restow after edits

```bash
stow --restow zsh starship ghostty aerospace tmux nvim yazi
```

## AeroSpace workspace map

- `1`: Zen browser
- `2`: Editors (Cursor + VS Code)
- `3`: Terminal (Ghostty)
- `4`: Reserved chat/collaboration
- `9`: Utilities
