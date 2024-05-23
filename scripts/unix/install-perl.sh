#!/usr/bin/env sh

# OS specific support (must be 'true' or 'false').
linux=false
darwin=false
case "`$OSTYPE`" in
  linux-gnu* )
    linux=true
    ;;
  darwin* )
    darwin=true
    ;;
esac

echo "Installing Perl..."
# Checking OS system
if [[ "$linux" == "true"* ]]; then
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y perl
    elif command -v yum &> /dev/null; then
        sudo yum install -y perl
    else
        echo "Unsupported package manager."
        exit 1
    fi
elif [[ "$darwin" == "true"* ]]; then
    if command -v brew &> /dev/null; then
        brew install perl
    else
        echo "Homebrew is not installed. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew install perl
    fi
else
    echo "Operating system not supported."
    exit 1
fi