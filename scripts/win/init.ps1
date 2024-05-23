#!/usr/bin/env pwsh

Write-Output "Init submodules..."
git submodule update --init --remote --recursive

function Install-Chocolatey {
    Write-Output "Chocolatey is not installed. Installing Chocolatey..."
    ".\chocolatey.ps1"
}

function Install-Perl {
    Write-Output "Installing Perl..."
    if (Get-Command "choco" -ErrorAction SilentlyContinue) {
        choco install -y strawberryperl
    } else {
        Install-Chocolatey
        choco install -y strawberryperl
    }
}

function Install-Python {
    Write-Output "Installing Python..."
    if (Get-Command "choco" -ErrorAction SilentlyContinue) {
        choco install -y python311
    } else {
        Install-Chocolatey
        choco install -y python311
    }
}

function Install-Node {
    Write-Output "Installing NodeJS..."
    if (Get-Command "fnm" -ErrorAction SilentlyContinue) {
        "fnm use --install-if-missing 20"
    } else {
        Write-Output "FNM(Fast Node Manager) is not installed. Installing FNM(Fast Node Manager)..."
        ".\fnm.ps1"
        "fnm use --install-if-missing 20"
    }
}

Write-Output "Checking Perl..."
if (Get-Command "perl" -ErrorAction SilentlyContinue) {
    Write-Output "Perl found."
} else {
    Install-Perl
}

Write-Output "Checking Python..."
if (Get-Command "python" -ErrorAction SilentlyContinue) {
    Write-Output "Python found."
} else {
    Install-Python
}

Write-Output "Checking Node..."
if (Get-Command "node" -ErrorAction SilentlyContinue) {
    Write-Output "Node found."
} else {
    Install-Node
}

Write-Output "Executing setup script..."
perl "scripts/setup.pl"

Write-Output "Init finished."