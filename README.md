# Linux Server Post-Installation Guide

Welcome to the **Linux Server Post-Installation Guide** repository. This guide is designed for learning, teaching, and standardizing the setup of a fresh Linux server (Ubuntu, CentOS, or AlmaLinux) starting from a minimal ISO installation.

## Purpose
After installing a minimal Linux OS, administrators often need to perform a series of checks, optimizations, and security hardenings to prepare the server for production workloads. This repository acts as a comprehensive, step-by-step curriculum and includes automation scripts to apply these best practices seamlessly.

## Repository Structure

### Documentation (`docs/`)
1. **[01. Initial Checks](docs/01-initial-checks.md)**: Verifying hardware resources, network, and OS version.
2. **[02. System Improvements](docs/02-system-improvements.md)**: Configuring hostname, time (NTP), and locale.
3. **[03. Essential Tools](docs/03-essential-tools.md)**: Installing must-have packages for troubleshooting and administration.
4. **[04. Package Management](docs/04-package-management.md)**: Managing updates and repositories for APT and YUM/DNF.
5. **[05. User Management](docs/05-user-management.md)**: Best practices for adding users, sudoers, and password policies.
6. **[06. Security Hardening](docs/06-security-hardening.md)**: Advanced SSH configuration, activity logging, firewalls, and SELinux/AppArmor.

### Automation Scripts (`scripts/`)
- `setup-ubuntu.sh`: Automates the setup for Ubuntu systems.
- `setup-rhel.sh`: Automates the setup for CentOS/AlmaLinux systems.

## How to Use This Guide
1. **For Learners**: Read through the `docs/` sequentially. Try the commands manually on a virtual machine to understand what they do.
2. **For Automated Setup**: Review the bash scripts in the `scripts/` folder, understand their actions, and run them on a fresh server to instantly apply professional best practices.
