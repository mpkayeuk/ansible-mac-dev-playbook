#!/bin/bash
#######################################################################
# Script Name: run_playbook.sh
# Description: This script installs my Mac development machine
#     Options: None
#
#      Author: Mark Kaye
#       Email: mark@kaye.co
#     Version: 1.0
#        Date: 20220119 09:34 GMT
#######################################################################

# Download the playbook requirements
echo "Downloading the playbook requirements"
cd ~/Development/ansible/mac-dev-playbook
ansible-galaxy install -r requirements.yml

# Let's go!
echo "Making sure you have the latest version..."
cd ~/Development/ansible/mac-dev-playbook
git pull
echo "Ready to rock and roll!  Run the playbook."
ansible-playbook main.yml -i inventory --ask-become-pass
