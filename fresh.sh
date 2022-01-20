#!/bin/sh

echo "Setting up your Mac..."

# Setting up basic gitconfig
git config --global user.email "Averroes2006@gmail.com"
git config --global user.name "Ahmad Ragab"

export DOTFILES=$HOME/.dotfiles

# Check for Oh My Zsh and install if we don't have it
if test ! -d $ZSH; then
  echo "Installing Oh My Zsh..."
  export ZSH=$HOME/.oh-my-zsh
  0>dev/null /bin/sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "Setting up Oh My Zsh plugins..."
# Oh my zsh setup
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-completions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

if test ! $(which arch); then
  echo "Installing Rosetta2 ..."
  softwareupdate --install-rosetta --agree-to-license
fi  

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  echo "Installing brew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Replace and symlink .zshrc
rm -rf $HOME/.zshrc
ln -s $DOTFILES/.zshrc $HOME/.zshrc

# Replace and symlink aliases
rm -rf $HOME/.aliases
ln -s $DOTFILES/.aliases $HOME/.aliases

rm -rf $HOME/.gitignore_global
ln -s $DOTFILES/.gitignore_global $HOME/.gitignore_global

# Symlink the Mackup config file to the home directory
rm -rf $HOME/.mackup.cfg
ln -s $DOTFILES/.mackup.cfg $HOME/.mackup.cfg

# Symlink the .p10k configuration
rm -rf $HOME/.p10k.zsh
ln -s $DOTFILES/.p10k.zsh $HOME/.p10k.zsh

# Instll Vim Plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Symlink the .vimrc 
rm -rf $HOME/.vimrc
ln -s $DOTFILES/.vimrc $HOME/.vimrc

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

# install pipenv
python3 -m pip install --user pipenv

# clone git repos
$DOTFILES/clone.sh

touch $HOME/.hushlogin

# Set macOS preferences - we will run this last because this will reload the shell
source $DOTFILES/.macos
