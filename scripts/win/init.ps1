#!/usr/bin/env pwsh

Write-Output "Init submodules..."
git submodule update --init --remote --recursive

# OS specific support
$windows = $false
$os = [System.Environment]::OSVersion.Platform
switch ($os) {
    2 { $windows = $true } # Windows
}

function Install-Perl {
    Write-Output "Installing Perl..."
    if ($windows) {
        if (Get-Command "choco" -ErrorAction SilentlyContinue) {
            choco install -y strawberryperl
        } else {
            Write-Output "Chocolatey is not installed. Installing Chocolatey..."
            ".\chocolatey.ps1"
            choco install -y strawberryperl
        }
    } else {
        Write-Output "Operating system not supported."
        exit 1
    }
}

Write-Output "Checking Perl..."
if (Get-Command "perl" -ErrorAction SilentlyContinue) {
    Write-Output "Perl found."
} else {
    Install-Perl
}

Write-Output "Executing setup script..."
perl "scripts/setup.pl"

Write-Output "Init finished."