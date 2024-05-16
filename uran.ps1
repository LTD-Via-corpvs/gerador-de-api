#!/usr/bin/env pwsh

param (
    [string]$command
)

switch ($command) {
    "i" {
        .\scripts\win\init.ps1
    }
    "init" {
        .\scripts\win\init.ps1
    }
    "r" {
        perl .\scripts\run.pl
    }
    "run" {
        perl .\scripts\run.pl
    }
    default {
        Write-Host "Uran build tool command. This provides a variety of commands to control the Uran (generator api tool)."
        Write-Host "View below for details of the available commands."
        Write-Host ""
        Write-Host "Commands:"
        Write-Host "  * i, init          | Init submodules and config them."
        Write-Host "  * r, run          | Run system."
    }
}