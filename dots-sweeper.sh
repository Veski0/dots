set -o pipefail

# Nuke the current dots collection
rm -rf ~/dots/home
mkdir -p ~/dots/home

# Handle bash
cp ~/.bash_aliases ~/dots/home/

# Handle nvim
mkdir ~/dots/home/.config
cp -r ~/.config/nvim/ ~/dots/home/.config
rm ~/dots/home/.config/nvim/.nvimlog
rm ~/dots/home/.config/nvim/lazy-lock.json

# Handle tmux
cp ~/.tmux.conf ~/dots/home
cp -r ~/.tmux ~/dots/home
rm -rf ~/dots/home/.tmux/plugins

# Handle pi
mkdir -p ~/dots/home/.pi/agent/
cp ~/.pi/agent/settings.json ~/dots/home/.pi/agent

echo "Dotfiles swept"
