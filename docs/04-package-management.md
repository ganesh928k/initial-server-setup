# 04. Package Management

Keeping your system and packages up-to-date is one of the most critical and recurring responsibilities of a Linux administrator. This guide covers both **APT** (Ubuntu/Debian) and **DNF** (CentOS/AlmaLinux/RHEL).

---

## Ubuntu / Debian (APT)

The Advanced Package Tool (`apt`) is the default package manager for Debian-based distributions.

### Update and Upgrade

```bash
# Step 1: Refresh the local package index (does NOT install anything)
sudo apt update

# Step 2: Upgrade all installed packages (safe upgrade)
sudo apt upgrade -y

# Full upgrade — handles dependency changes; may remove conflicting packages
sudo apt full-upgrade -y
```

> **Best Practice:** Always run `apt update` before `apt upgrade`. The two commands are separate steps on purpose.

### Install and Remove Packages

```bash
# Install a package
sudo apt install -y package_name

# Remove a package (keeps config files)
sudo apt remove package_name

# Purge a package AND its config files (cleaner removal)
sudo apt purge package_name

# Remove automatically installed dependencies no longer needed
sudo apt autoremove -y
```

### Search and Inspect

```bash
# Search for a package by name or description
apt search keyword

# Show detailed info about a package before installing
apt show package_name

# List all installed packages
dpkg -l

# Check if a specific package is installed
dpkg -l | grep package_name
```

### Pin / Hold a Package (Prevent Upgrades)

Useful when you want to keep a specific version of a critical package.

```bash
# Hold a package at its current version
sudo apt-mark hold package_name

# Show all held packages
apt-mark showhold

# Unhold (allow upgrades again)
sudo apt-mark unhold package_name
```

### Clean Up Disk Space

```bash
# Remove downloaded .deb files from the package cache
sudo apt clean

# Remove partial packages from the cache
sudo apt autoclean

# Remove unneeded dependency packages
sudo apt autoremove -y
```

---

## CentOS / AlmaLinux / RHEL (DNF)

`dnf` (Dandified YUM) replaced the older `yum` starting from RHEL 8. It is faster, smarter about dependencies, and supports modules.

### Update and Upgrade

```bash
# Update all packages (fetches metadata AND upgrades in one command)
sudo dnf upgrade -y

# Update a specific package only
sudo dnf upgrade package_name
```

### Install EPEL Repository

```bash
sudo dnf install -y epel-release
```

### Install and Remove Packages

```bash
# Install a package
sudo dnf install -y package_name

# Remove a package
sudo dnf remove package_name

# Remove packages no longer needed as dependencies
sudo dnf autoremove -y
```

### Search and Inspect

```bash
# Search for a package
dnf search keyword

# Show detailed info about a package
dnf info package_name

# List all installed packages
rpm -qa

# Check if a specific package is installed
rpm -qa | grep package_name
```

### DNF History — Rollback Changes

This is one of `dnf`'s most powerful features — you can undo package operations.

```bash
# View transaction history
dnf history

# Undo the last transaction (e.g., if an upgrade broke something)
sudo dnf history undo last

# Undo a specific transaction by ID
sudo dnf history undo 5
```

### Managing Module Streams (RHEL 8+)

Modules let you install different versions of software (e.g., PHP 7.4 vs PHP 8.0).

```bash
# List available modules and their streams
dnf module list

# Enable a specific module stream
sudo dnf module enable php:8.1

# Install a module
sudo dnf module install php
```

### Clean Up Disk Space

```bash
# Remove all cached data
sudo dnf clean all

# Remove unneeded dependency packages
sudo dnf autoremove -y
```

---

## Automating Security Updates

For production servers, it's a good practice to automatically apply **security patches only**.

**Ubuntu — `unattended-upgrades`:**
```bash
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

**RHEL/AlmaLinux — `dnf-automatic`:**
```bash
sudo dnf install -y dnf-automatic
sudo systemctl enable --now dnf-automatic.timer
```

---

**Next Step:** [05. User Management →](05-user-management.md)
