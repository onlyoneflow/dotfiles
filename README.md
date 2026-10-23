# Dotfiles

Personal-but-portable configuration for:

- Zsh
- Ghostty
- Yazi
- Neovim

## Layout

```text
zsh/       .zshrc and .zprofile
ghostty/   Ghostty config, themes, and shaders
yazi/      Yazi config, keymaps, and flavors
nvim/      Neovim config and lazy-lock
```

The files are copied into their expected locations under `$HOME` / `$HOME/.config`.
Machine-specific settings should go in `~/.zshrc.local`; that file is intentionally not tracked.

## Install

```sh
cp zsh/.zshrc ~/.zshrc
cp zsh/.zprofile ~/.zprofile
cp -R ghostty ~/.config/ghostty
cp -R yazi ~/.config/yazi
cp -R nvim ~/.config/nvim
```
