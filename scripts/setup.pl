#!/usr/bin/perl bash
use strict;
use warnings;
use File::Spec;
use File::Copy;
use Cwd;
use Config;

$ENV{LC_ALL} = 'en_US.UTF-8';
$ENV{LANG} = 'en_US.UTF-8';

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

sub setup_python {
    my $python = command_exist('py') || command_exist('python') || command_exist('python3');
    if (!$python) {
        die "[Server-Side] Python is not installed on the machine.\n";
    }

    my $current_dir = getcwd;
    my $venv_path = File::Spec->catdir($current_dir, 'packages', 'server-side', 'venv');

    unless (-d $venv_path) {
        print "[Server-Side] Virtual environment not found.\n";
        print "[Server-Side] Creating a virtual environment...\n";
        my $create_venv_cmd = "\"$python\" -m venv \"$venv_path\"";
        system($create_venv_cmd) == 0
            or die "Failed to create the virtual environment: $!\n";
        print "[Server-Side] Virtual enviroment created.\n";
    }

    print "[Server-Side] Activating the virtual environment and installing dependencies...\n";

    my $activate_venv;
    if ($^O eq 'MSWin32') {
        $activate_venv = File::Spec->catfile($venv_path, 'Scripts', 'activate');
    } else {
        $activate_venv = File::Spec->catfile($venv_path, 'bin', 'activate');
    }

    my $requirements_file = File::Spec->catfile($venv_path, '..', 'requirements.txt');

    my $install_deps_cmd;
    if ($^O eq 'MSWin32') {
        $install_deps_cmd = "cmd /c \"$activate_venv\" && pip install -r \"$requirements_file\"";
    } else {
        $install_deps_cmd = ". \"$activate_venv\" && pip install -r \"$requirements_file\"";
    }

    system($install_deps_cmd) == 0
        or die "Failed to install dependencies: $!\n";

    print "[Server-Side] Dependencies installed successfully.\n";
}

sub setup_next {
    my $package_manager = command_exist('pnpm') || command_exist('bun') || command_exist('yarn') || command_exist('npm');
    if (!$package_manager) {
        die "[Client-Side] Package Manager is not installed on the machine.\n";
    }

    my $current_dir = getcwd;
    my $client_path = File::Spec->catdir($current_dir, 'packages', 'client-side');

    unless (-d $client_path) {
        die "Client-side don't found: $!\n";
    }

    print "[Client-Side] Installing all necessary dependencies...\n";

    my $install_deps_cmd = "cd \"$client_path\" && $package_manager install";

    system($install_deps_cmd) == 0
        or die "[Client-Side] Failed to install dependencies: $!\n";

    print "[Client-Side] Dependencies installed successfully.\n";
    print "[Client-Side] Creating .env file.\n";

    my $input_file = File::Spec->catfile($client_path, '.env.example');
    my $output_file = File::Spec->catfile($client_path, '.env');
    copy($input_file, $output_file);
}

setup_python();
setup_next();