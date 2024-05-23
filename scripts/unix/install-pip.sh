#!/usr/bin/env sh

# OS specific support (must be 'true' or 'false').
linux=false
darwin=false
case "$OSTYPE" in
  linux* )
    linux=true
    ;;
  darwin* )
    darwin=true
    ;;
esac

echo "Installing Pip..."
# Checking OS system
if [[ "$linux" == "true"* ]]; then
    if command -v apt-get &> /dev/null; then
        sudo apt update
        sudo apt upgrade -y
        sudo apt -y install python3-pip
        sudo apt -y install python3.11-venv
    elif command -v yum &> /dev/null; then
        sudo yum install -y python3-pip
    else
        echo "Unsupported package manager."
        exit 1
    fi
elif [[ "$darwin" == "true"* ]]; then
    if command -v curl &> /dev/null; then
        curl "https://bootstrap.pypa.io/get-pip.py | python3"
    else
        echo "Curl is not installed."
        exit 1
    fi
else
    echo "Operating system not supported."
    exit 1
fi