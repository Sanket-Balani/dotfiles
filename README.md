# dotfiles

Modern keyboard-first dotfiles for macOS and Ubuntu WSL:

- AeroSpace (i3-style tiling workspaces on macOS)
- Ghostty + Catppuccin Mocha
- Zsh + Zinit + Starship + zoxide + fzf-tab
- LazyVim (Neovim)
- tmux + TPM + resurrect/continuum
- yazi + modern CLI tools

On Windows, Ubuntu WSL is the primary environment. Windows Terminal, zsh, Git/delta,
Atuin, tmux, and CLI surfaces are themed to match the existing Catppuccin Mocha
Neovim/tmux/starship setup.

## Bootstrap

```bash
cd ~/dotfiles
./script/bootstrap --force
```

For Ubuntu WSL:

```bash
cd ~/dotfiles
./script/bootstrap-linux --force
```

For Windows Terminal/font setup, run from PowerShell:

```powershell
.\script\bootstrap-windows.ps1
```

## Validate

```bash
./script/doctor
```

## Restow after edits

```bash
stow --restow zsh starship git atuin tmux nvim yazi
```

## AeroSpace workspace map

- `1`: Zen browser
- `2`: Editors (Cursor + VS Code)
- `3`: Terminal (Ghostty)
- `4`: Reserved chat/collaboration
- `9`: Utilities
