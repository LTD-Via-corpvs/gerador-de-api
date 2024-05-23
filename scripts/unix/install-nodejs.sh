#!/usr/bin/env sh

echo "Installing NodeJS..."
# Checking OS system
if command -v nvm &> /dev/null; then
    sudo "nvm install 20" 
else
    echo "NVM is not installed. Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    sudo "nvm install 20"
fi