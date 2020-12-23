#!/bin/bash
#######################################################################
# Script Name: boot_ansible.sh
# Description: This script installs my Mac development machine
#     Options: None
#
#      Author: Mark Kaye
#       Email: mark@kaye.co
#     Version: 1.0
#        Date: 20201223 19:07 GMT
#######################################################################

# Install OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Homebrew
echo "Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Use Homebrew to install Ansible
echo "Installing Ansible"
brew install ansible

# Copy my SSH keypair
echo "Copying SSH keys"
mkdir ~/.ssh
chmod 700 ~/.ssh
cp /Volumes/Install\ macOS\ Big\ Sur/id_rsa* ~/.ssh
chmod 600 ~/.ssh/id_rsa*

# Configure my git global parameters
echo "Configure git global parameters"
git config --global user.name "Mark Kaye"
git config --global user.email mark@kaye.co

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