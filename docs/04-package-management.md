# 04. Package Management

Keeping your system and software up-to-date is one of the most critical responsibilities of a Linux administrator.

## Ubuntu / Debian (APT)

Advanced Package Tool (`apt`) is the default package manager for Debian-based systems.

**1. Update Package Lists:**
```bash
sudo apt update
```

**2. Upgrade Installed Packages:**
```bash
# Upgrade all packages safely
sudo apt upgrade -y

# Perform a full upgrade (handles changing dependencies, might remove some packages)
sudo apt full-upgrade -y
```

**3. Search for Packages:**
```bash
apt search package_name
```

**4. Clean Up Space:**
```bash
# Remove unneeded dependencies
sudo apt autoremove -y

# Clear the local repository of retrieved package files
sudo apt clean
```

## CentOS / AlmaLinux / RHEL (YUM / DNF)

`dnf` (Dandified YUM) is the modern package manager for RHEL-based systems (replacing the older `yum`).

**1. Update Package Lists and Upgrade Packages:**
```bash
# DNF updates both lists and packages in one command
sudo dnf upgrade -y
```

**2. Install EPEL Repository:**
The Extra Packages for Enterprise Linux (EPEL) repository provides many essential open-source packages not included by default.
```bash
sudo dnf install -y epel-release
```

**3. Search for Packages:**
```bash
dnf search package_name
```

**4. Clean Up Space:**
```bash
sudo dnf clean all
sudo dnf autoremove -y
```

## Automating Updates
While manual updates are common, consider using `unattended-upgrades` on Ubuntu or `dnf-automatic` on RHEL systems for automated security patches.
