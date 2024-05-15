#!/usr/bin/perl
use strict;
use warnings;
use File::Spec;
use Cwd;
use Config;

sub command_exist {
    my ($command) = @_;
    my $path;
    if ($^O eq 'MSWin32') {
        $path = `where $command 2>NUL`
    } else {
        $path = `which $command 2>/dev/null`;
    }
    chomp $path;
    return $path if $path;
    return;
}

sub run_app {
    my $python = command_exist('py') || command_exist('python') || command_exist('python3');
    if (!$python) {
        die "Python is not installed on the machine.\n";
    }

    my $package_manager = command_exist('pnpm') || command_exist('bun') || command_exist('yarn') || command_exist('npm');
    if (!$package_manager) {
        die "Package Manager is not installed on the machine.\n";
    }

    my $current_dir = getcwd;
    my $venv_path = File::Spec->catdir($current_dir, 'packages', 'server-side', 'venv');

    my $activate_venv;
    if ($^O eq 'MSWin32') {
        $activate_venv = File::Spec->catfile($venv_path, 'Scripts', 'activate');
    } else {
        $activate_venv = File::Spec->catfile($venv_path, 'bin', 'activate');
    }

    my $exec_dev_cmd;
    if ($^O eq 'MSWin32') {
        $exec_dev_cmd = "cmd /c \"$activate_venv\" && $package_manager run dev";
    } else {
        $exec_dev_cmd = ". \"$activate_venv\" && $package_manager run dev";
    }

    system($exec_dev_cmd) == 0
        or die "Failed to execute command: $!\n";
}

run_app();