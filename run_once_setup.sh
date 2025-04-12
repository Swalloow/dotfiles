#!/bin/sh

echo " ___       __   _______   ___       ________  ________  _____ ______   _______      "
echo "|\  \     |\  \|\  ___ \ |\  \     |\   ____\|\   __  \|\   _ \  _   \|\  ___ \     "
echo "\ \  \    \ \  \ \   __/|\ \  \    \ \  \___|\ \  \|\  \ \  \\\__\ \  \ \   __/|    "
echo " \ \  \  __\ \  \ \  \_|/_\ \  \    \ \  \    \ \  \\\  \ \  \\|__| \   \ \  \_|/__  "
echo "  \ \  \|\__\_\  \ \  \_|\ \ \  \____\ \  \____\ \  \\\  \ \  \    \ \  \ \  \_|\ \ "
echo "   \ \____________\ \_______\ \_______\ \_______\ \_______\ \__\    \ \__\ \_______\\"
echo "    \|____________|\|_______|\|_______|\|_______|\|_______|\|__|     \|__|\|_______|"
echo ""

# Default variables
WORK_PATH="$HOME/Documents"
DOWNLOAD_PATH="$HOME/Downloads"

echo "Installing xcode-stuff..."
sudo rm -rf /Library/Developer/CommandLineTools
xcode-select --install

# Install Homebrew
if test ! $(which brew); then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update homebrew recipes
echo "Updating homebrew..."
brew update

# Install brew packages
echo "Installing brew packages..."
apps=(
    cask
    fzf
    gcc
    gh
    git
    jq
    lsd
    openssl
    readline
    telnet
    tree
    vim
    wget
    yq
    zlib
)
brew install ${apps[@]}
$(brew --prefix)/opt/fzf/install

# Workspace configuration
echo "Updating work path"
mkdir -p $WORK_PATH/GitHub $WORK_PATH/Notebook $WORK_PATH/Tests

# Vim configuration
mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle && cd $HOME/.vim/bundle
curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
git clone --depth=1 https://github.com/altercation/vim-colors-solarized.git

# Git configuration
echo "Updating git config..."
git config --global user.name "Swalloow"
git config --global user.email swalloow.me@gmail.com

# Zsh configuration
echo "Installing zsh config..."
curl -L http://install.ohmyz.sh | sh
brew install zsh-completions
chsh -s `which zsh`

# zsh alias, plugins
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

# powerlevel10k theme with D2 Coding fonts
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
curl -o $DOWNLOAD_PATH/d2coding.zip https://github.com/naver/d2codingfont/releases/download/VER1.3.2/D2Coding-Ver1.3.2-20180524.zip

# Python configuration
echo "Installing python..."
brew install uv
uv python install 3.13

# SDKMAN configuration
echo "Installing JVM based..."
curl -s https://get.sdkman.io | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Kubernetes configuration
echo "Installing kubernetes config..."
brew install kubernetes-cli helm kubectx

# Node configuration
echo "Installing node config..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash

# Mac configuration
echo "Updating mac config..."

# Setting Finder
defaults write com.apple.finder AppleShowAllFiles YES
defaults write com.apple.finder "ShowPathbar" -bool true && killall Finder

# Setting Dock
defaults write com.apple.dock "autohide" -bool false
defaults write com.apple.dock "show-recents" -bool false
defaults write com.apple.dock "tilesize" -int "36" && killall Dock

# Disable siri assistant
defaults write com.apple.assistant.support "Assistant Enabled" -bool false
defaults write com.apple.Siri StatusMenuVisible -bool false

# Screenshot settings
defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture type -string "png"

# Incomplete downloads settings
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "$HOME/Downloads/Incomplete"

# Save to disk by default, not iCloud
defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool false

# Show battery percentage
defaults write com.apple.controlcenter.plist BatteryShowPercentage -bool true

echo "Setup finished!"
