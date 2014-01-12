#!/usr/bin/env zsh

# Shell has to be zsh
# use chsh -s /bin/zsh to change shell for the user
# A simple script for setting up OSX dev environment.

sudo -v # ask for password only at the beginning

homebin="$HOME/bin"

mkdir -p $homebin

export PATH=~/bin:$PATH


# echo 'Enter new hostname of the machine (e.g. todesstern)'
  read hostname
  echo "Setting new hostname to $hostname..."
  scutil --set HostName "$hostname"
  compname=$(sudo scutil --get HostName | tr '-' '.')
  echo "Setting computer name to $compname"
  scutil --set ComputerName "$compname"
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$compname"

# echo 'Enter Git Username'
  read git_username
  echo "Setting Git Username to $git_username"
  git config --global user.name "$git_username"

# echo 'Enter Git Email'
  read git_email
  echo "Setting Git Username to $git_email"
  git config --global user.email "$git_email"




pub=$HOME/.ssh/id_rsa.pub
echo 'Checking for SSH key, generating one if it does not exist...'
  [[ -f $pub ]] || ssh-keygen -t rsa

# echo 'Copying public key to clipboard. Paste it into your Github account...'
  [[ -f $pub ]] && cat $pub | pbcopy
  open 'https://github.com/account/ssh'

# If we on OS X, install homebrew and tweak system a bit.
if [[ `uname` == 'Darwin' ]]; then
  which -s brew
  if [[ $? != 0 ]]; then
    echo 'Installing Homebrew...'
      ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
      brew doctor
      brew update
    echo 'Installing Cask'
      brew install htop
      brew tap phinze/homebrew-cask
      brew install brew-cask
      brew tap caskroom/versions
  fi

  # echo 'Tweaking OS X...'
    source 'install/osx.sh'

  echo 'Installing APPS - be patient'
    source 'install/cask.sh'

  echo 'setting up homesick'
    source 'install/homesick.sh'
fi

