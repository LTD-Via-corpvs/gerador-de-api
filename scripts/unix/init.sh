#!/usr/bin/env sh

echo "Init submodules..."
git submodule update --init --recursive

echo "Checking Perl..."
if command -v perl &> /dev/null; then
    echo "Perl found."
else
    bash "install-perl.sh"
fi

echo "Checking Python..."
if command -v python3 &> /dev/null; then
    echo "Python found."
else
    bash "install-python.sh"
fi

echo "Checking Pip..."
if command -v pip &> /dev/null; then
    echo "Pip found."
else
    bash "./scripts/unix/install-pip.sh"
fi

echo "Checking Node..."
if command -v node &> /dev/null; then
    echo "Node found."
else
    bash "./scripts/unix/install-nodejs.sh"
fi

echo "Executing setup script..."
perl "./scripts/setup.pl"

echo "Init finished."