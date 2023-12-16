#!/bin/bash

export DOTFILES=$HOME/.dotfiles

# Function to check if a command exists
command_exists() {
  type "$1" &> /dev/null ;
}

echo "Setting up your Mac..."

# Install Homebrew if it's not already installed
if ! command_exists brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  echo "Setting up Oh My Zsh plugins..."
  # Oh my zsh setup
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
  git clone https://github.com/zsh-users/zsh-completions.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-completions
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
fi

if [ -z "$git_user" ]; then
  git config --global user.name "Ahmad Ragab"
fi

"$DOTFILES"/ssh.sh 

if [ -z "$git_email" ]; then
  git config --global user.email "averroes2006@gmail.com"
fi

if test ! $(which arch); then
  echo "Installing Rosetta2 ..."
  softwareupdate --install-rosetta --agree-to-license
fi

# hushlogin
touch $HOME/.hushlogin

# Replace and symlink .zshrc
rm -rf $HOME/.zshrc
ln -s $DOTFILES/.zshrc $HOME/.zshrc

# Replace and symlink aliases
rm -rf $HOME/.aliases
ln -s $DOTFILES/.aliases $HOME/.aliases

rm -rf $HOME/.gitignore_global
ln -s $DOTFILES/.gitignore_global $HOME/.gitignore_global

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
brew bundle --file=$DOTFILES/Brewfile

# install pipenv
python3 -m pip install --user pipenv

# clone git repos
$DOTFILES/clone.sh

touch $HOME/.hushlogin

# Set macOS preferences - we will run this last because this will reload the shell
source "$DOTFILES"/.macos
