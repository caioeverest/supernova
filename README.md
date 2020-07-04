# Supernova

Supernova is an environment-building script that uses Ansible to install and configure basic applications for software development purposes. The idea was based on the project (prepare-dev-environment from @Marco Ollivier) [https://github.com/marcopollivier/prepare-dev-environment]. Because of that, the project shares the same motivation.

## How to use

Supernova is really easy to use, basically you just need to exec the following prompt:
make git_email=youremail@provider.com

By running that, the script will ask for your password and the root password (if your user is on the sudoers file, just write it on the first and leave the second one empty).

The default config uses your username as git name, but if you want a custom name you can run with with the variable git_name="your name" and it will use this instead:
make git_name="your name" git_email=youremail@provider.com

## Improvements

The main idea is to be able to use supernova on different operating systems, so the next step should be creating new scripts for each OS/Distro, feel free to open pull requests :)
