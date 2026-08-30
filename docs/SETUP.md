# Setup

## Fresh machine

### Ubuntu WSL

```bash
cd ~/dotfiles
./script/bootstrap-linux --force
```

Restart WSL after the first run if `/etc/wsl.conf` changed:

```powershell
wsl.exe --shutdown
```

### macOS

```bash
cd ~/dotfiles
./script/bootstrap --force
```

Options:

- `--no-cask` skips cask installs
- `--skip-nvim` skips headless Lazy sync
- `--force` backs up conflicting files into `~/dotfiles-backups/<timestamp>/`

## Daily maintenance

```bash
cd ~/dotfiles
brew bundle --file Brewfile.linux
stow --restow zsh starship git atuin tmux nvim yazi
./script/doctor
```

## One-time tmux plugin install

Inside tmux: `Ctrl-Space` then `Shift-I`
