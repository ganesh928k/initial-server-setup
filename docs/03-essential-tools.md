# 03. Essential Administrator Tools

A minimal ISO installation lacks many basic tools you might need for troubleshooting and administration.

## Must-Have Tools Overview

- **`htop`**: An interactive, more user-friendly alternative to `top` for monitoring processes.
- **`tmux` / `screen`**: Terminal multiplexers that allow you to keep sessions alive even if SSH disconnects.
- **`curl` / `wget`**: Command-line tools for downloading files from the internet.
- **`vim` / `nano`**: Text editors for modifying configuration files.
- **`git`**: Version control system, essential for pulling scripts and configurations.
- **`net-tools`**: Provides older networking commands like `netstat` and `ifconfig`.
- **`tree`**: Displays directories as trees (with depth).
- **`rsync`**: Fast, versatile file copying tool (essential for backups).
- **`bash-completion`**: Adds auto-completion support to the bash shell.

## Installation Commands

**Ubuntu / Debian:**
```bash
sudo apt update
sudo apt install -y htop tmux curl wget vim git net-tools tree rsync bash-completion
```

**CentOS / AlmaLinux / RHEL:**
```bash
sudo dnf install -y epel-release
sudo dnf install -y htop tmux curl wget vim git net-tools tree rsync bash-completion
```
*Note: `epel-release` (Extra Packages for Enterprise Linux) is required on RHEL-based systems to install packages like `htop`.*
