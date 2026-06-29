# 03. Essential Administrator Tools

A minimal ISO installation is stripped down to the bare minimum. Here are the tools every Linux administrator should install on a fresh server.

---

## Tool Overview

| Tool | Purpose | Available On |
|---|---|---|
| `htop` | Interactive process and resource monitor | Ubuntu, RHEL (via EPEL) |
| `tmux` | Terminal multiplexer — keeps sessions alive on SSH disconnect | Both |
| `screen` | Alternative terminal multiplexer | Both |
| `curl` | Transfer data from URLs; used for API testing and downloads | Both |
| `wget` | Download files from the internet | Both |
| `vim` | Powerful terminal text editor | Both |
| `nano` | Simple beginner-friendly text editor | Both |
| `git` | Version control; pull configs and scripts from repositories | Both |
| `net-tools` | Provides `netstat`, `ifconfig` (older but still widely used) | Both |
| `tree` | Display directory structure as a tree | Both |
| `rsync` | Efficient file transfers and backups | Both |
| `bash-completion` | Tab-completion for bash commands | Both |
| `lsof` | List open files and network connections by process | Both |
| `unzip` | Extract `.zip` archives | Both |
| `tar` | Extract `.tar`, `.tar.gz`, `.tar.bz2` archives (usually pre-installed) | Both |
| `fail2ban` | Bans IPs that repeatedly fail login — critical for SSH security | Both |

---

## Installation Commands

**Ubuntu / Debian:**
```bash
sudo apt update
sudo apt install -y \
  htop tmux screen \
  curl wget \
  vim nano \
  git \
  net-tools tree rsync \
  bash-completion \
  lsof unzip \
  fail2ban
```

**CentOS / AlmaLinux / RHEL:**
```bash
# EPEL is required for htop, tmux, and other packages
sudo dnf install -y epel-release

sudo dnf install -y \
  htop tmux screen \
  curl wget \
  vim nano \
  git \
  net-tools tree rsync \
  bash-completion \
  lsof unzip \
  fail2ban
```

> **What is EPEL?** The Extra Packages for Enterprise Linux repository is a community project that provides thousands of high-quality packages not included in the default RHEL repositories. It's safe, widely trusted, and essential.

---

## Quick Usage Examples

**`htop`** — Press `F6` to sort by column, `F9` to kill a process, `q` to quit.
```bash
htop
```

**`tmux`** — Start a session, and your work survives SSH disconnects.
```bash
tmux new -s mysession       # Create a named session
tmux attach -t mysession    # Re-attach after disconnect
# Inside tmux: Ctrl+B, D = detach | Ctrl+B, % = split pane
```

**`lsof`** — Find which process is using a specific port.
```bash
sudo lsof -i :80   # What is using port 80?
sudo lsof -i :22   # What is using port 22 (SSH)?
```

**`rsync`** — Copy files efficiently between directories or remote servers.
```bash
rsync -avz /source/dir/ user@remote:/destination/dir/
```

---

**Next Step:** [04. Package Management →](04-package-management.md)
