# Setup

## Fresh machine

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
brew bundle --file Brewfile
stow --restow zsh starship ghostty tmux nvim yazi
./script/doctor
```

## One-time tmux plugin install

Inside tmux: `Ctrl-Space` then `Shift-I`
