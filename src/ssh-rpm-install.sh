#!/bin/bash


# Author: Ty Hitzeman

# Purpose: Make it easier to install an RPM on a remote server without sacrificing security.
## The beauty of using this script is that it allows you to sign in to a remote server, escalate to root,
## and run subsequent commands, all WITHOUT sending any plain text passwords. 

# Usage:
## 1) Replace example variables with your own
## 2) Make script executable: `sudo chmod +x ssh-rpm-install.sh`
## 3) Run script: `./ssh-rpm-install.sh`
## 4) Follow prompts

# Note: The script uses the following as example variables. Replace them with your own before using.
## - RPM name: app.rpm

# References:
  # heredocs usage
        # https://en.wikipedia.org/wiki/Here_document
        # http://tldp.org/LDP/abs/html/here-docs.html

# To-Dos:
## Suppress errors

# Global Variables

### Place ${COLOR} before text to color
#### NOTE 1: Using these colors requires the 'echo -e' flag, which enables interpretation of backslash escapes
##### Example: echo -e "Enter ${RED}ONE${NC} IP, then return."
#### NOTE 2: \033[ references cursor position, 1;32 references (1) font style (32) font color
RED="\033[1;31m"
BLUE=" \033[1;34m"
NC="\033[0m" # Turns coloration OFF - place ${NC} after text to color

## Start of script
echo "

This script will:
  1) Prompt you for an IP, username, and build URL
  2) Sign into a VM as the provided user using a pseudo SSH session
  3) curl the rpm from the provided build URL
  4) install the rpm
  5) sign out of the pseudo SSH session
  6) sign in with a normal SSH session
"

#Get IP and username
read -p "Enter the VM's IP: " HOSTS;

USERNAME="admin"
read -e -p "User that will sign in via SSH (default = 'admin'): " userinput
USERNAME="${userinput:-$USERNAME}"
echo "signing into VM using a pseudo SSH session..."

for HOSTNAME in ${HOSTS} ; do
    # SSH into VM using input from the two prompts, then download and install rpm
    ssh -t -l ${USERNAME} ${HOSTS} '
    read -p "Enter Build URL: " BUILD_URL;
    sudo su << HERE
    echo "Switched to root user"
    echo "Downloading app.rpm ..."
    curl -o app.rpm -k $BUILD_URL
    echo "Installing app.rpm..."
    rpm -i app.rpm
    echo "app.rpm installed."

    HERE'
    
done

echo "app.rpm installed."
echo "signing in using normal SSH session ... "
echo -e "${BLUE}Remember to run any other necessary commands once you're signed in.${NC}"
echo ""
echo ""
sleep 5
ssh -t -l ${USERNAME} ${HOSTS}
