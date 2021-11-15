#!/bin/sh

echo "Setting up your Mac..."

echo "Installing Oh My Zsh..."
# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  export ZSH=$HOME/.oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

echo "Setting up Oh My Zsh plugins..."
# Oh my zsh setup
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "Installing brew..."
# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

# Replace and symlink .zshrc
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

# Replace and symlink aliases
rm -rf $HOME/.aliases
ln -s $HOME/.dotfiles/.aliases $HOME/.aliases

rm -rf $HOME/.gitignore_global
ln -s $HOME/.dotfiles/.gitingore_global $HOME/.gitingore_global

# Symlink the Mackup config file to the home directory
ln -s $HOME/.dotfiles/.mackup.cfg $HOME/.mackup.cfg

# clone git repos
./clone.sh

# Set macOS preferences - we will run this last because this will reload the shell
source .macos
