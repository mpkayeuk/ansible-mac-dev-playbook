#!/bin/zsh
#######################################################################
# Script Name: boot_ansible.sh
# Description: This script installs my Mac development machine
#     Options: None
#
#      Author: Mark Kaye
#       Email: mark@kaye.co
#     Version: 1.1
#        Date: 20220116 15:28 GMT
#######################################################################

# Copy my SSH keypair
echo "Copying SSH keys"
mkdir ~/.ssh
chmod 700 ~/.ssh
cp /Volumes/Install\ macOS\ Monterey/id_rsa* ~/.ssh
chmod 600 ~/.ssh/id_rsa*

# Install Homebrew
echo "Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/mark/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install pyenv
pyenv install $(pyenv install --list | grep -v - | grep -v b | grep -v a | grep -v miniforge | grep -v rc | tail -1)
pyenv global $(pyenv install --list | grep -v - | grep -v b | grep -v a | grep -v miniforge | grep -v rc | tail -1)

# Upgrade Pip
echo "Upgrading Pip"
sudo pip install --upgrade pip

# Install Rosetta 2
sudo softwareupdate --install-rosetta --agree-to-license

# Use Homebrew to install Ansible
echo "Installing Ansible"
brew install ansible

# Configure my git global parameters
echo "Configure git global parameters"
git config --global user.name "Mark Kaye"
git config --global user.email mark@kaye.co

# Install OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Modify ZSH environment for pyenv
echo "Adding pyenv logic to .zshrc"
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init --path)"\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc
source ~/.zshrc

# Create some basic directories to get stuff done
mkdir -p ~/Development/ansible

# Clone the Mac setup repo
cd ~/Development/ansible
git clone git@github.com:mpkayeuk/mac-dev-playbook.git

# Download the playbook requirements
echo "Downloading the playbook requirements"
cd ~/Development/ansible/mac-dev-playbook
ansible-galaxy install -r requirements.yml

# Let's go!
echo "Ready to rock and roll!  Run the playbook."
cd ~/Development/ansible/mac-dev-playbook
ansible-playbook main.yml -i inventory --ask-become-pass
