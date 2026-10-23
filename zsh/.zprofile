# Optional local tools. Add machine-specific paths in ~/.zshrc.local instead.
if [[ -r "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
