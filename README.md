# Linux Server Post-Installation Guide

<div align="center">

![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)
![Platform](https://img.shields.io/badge/Platform-Ubuntu%20%7C%20AlmaLinux%20%7C%20CentOS-blue)
![PRs Welcome](https://img.shields.io/badge/PRs-Welcome-brightgreen.svg)
![Maintained](https://img.shields.io/badge/Maintained-Yes-brightgreen)

**A professional, beginner-friendly guide to configuring a fresh Linux server from a minimal ISO installation.**
*Perfect for students, sysadmins, and anyone building a solid foundation in Linux administration.*

</div>

---

## 📖 Table of Contents

- [Who Is This For?](#who-is-this-for)
- [Prerequisites](#prerequisites)
- [Quick Start (Automated)](#quick-start-automated)
- [Step-by-Step Learning Path](#step-by-step-learning-path)
- [Repository Structure](#repository-structure)
- [Tested On](#tested-on)
- [Contributing](#contributing)
- [License](#license)

---

## Who Is This For?

| Audience | How to Use This Repo |
|---|---|
| 🎓 **Students / Beginners** | Follow the `docs/` sequentially. Run each command manually on a VM. |
| 🛠️ **Junior Sysadmins** | Use this as a checklist every time you provision a new server. |
| 🏫 **Instructors** | Use the structured docs as a ready-made curriculum for Linux courses. |
| ⚡ **Experienced Admins** | Jump straight to the automation scripts for fast, repeatable setup. |

---

## Prerequisites

Before you begin, you need:
- A fresh **minimal ISO installation** of Ubuntu, CentOS, or AlmaLinux on a physical machine or virtual machine (e.g., VirtualBox, VMware, KVM).
- An SSH client (Terminal on Mac/Linux, PuTTY or Windows Terminal on Windows).
- Basic knowledge of navigating a Linux terminal.

> **Recommended:** Read [`docs/00-prerequisites.md`](docs/00-prerequisites.md) for a full environment setup guide.

---

## Quick Start (Automated)

If you just want to apply all best practices instantly using the automation scripts:

**Ubuntu / Debian:**
```bash
git clone https://github.com/YOUR_USERNAME/initial-server-setup.git
cd initial-server-setup
sudo bash scripts/setup-ubuntu.sh
```

**CentOS / AlmaLinux / RHEL:**
```bash
git clone https://github.com/YOUR_USERNAME/initial-server-setup.git
cd initial-server-setup
sudo bash scripts/setup-rhel.sh
```

> ⚠️ **Important:** Always review a script before running it as root. The scripts are well-commented so you understand every action they take.

### What the Script Does
After running, your server will have:
- ✅ All packages updated to the latest version
- ✅ Essential admin tools installed (`htop`, `tmux`, `vim`, `git`, etc.)
- ✅ Timezone set to UTC with NTP enabled
- ✅ Bash history configured with timestamps for all users
- ✅ SSH hardened (root login disabled, key-based auth enforced)
- ✅ Fail2Ban installed and active to block brute-force attacks
- ✅ Firewall configured (UFW or firewalld) with safe defaults
- ✅ All actions logged to `/var/log/server-setup.log`

---

## Step-by-Step Learning Path

Work through these guides **in order** for the best learning experience:

| # | Guide | Description |
|---|---|---|
| 00 | [Prerequisites](docs/00-prerequisites.md) | Setting up your VM and SSH client |
| 01 | [Initial Checks](docs/01-initial-checks.md) | Verify OS, network, disk, and resources |
| 02 | [System Improvements](docs/02-system-improvements.md) | Hostname, time zone, NTP, and locale |
| 03 | [Essential Tools](docs/03-essential-tools.md) | Must-have admin packages |
| 04 | [Package Management](docs/04-package-management.md) | APT and DNF deep dive |
| 05 | [User Management](docs/05-user-management.md) | Users, groups, sudo, and SSH keys |
| 06 | [Security Hardening](docs/06-security-hardening.md) | SSH, Fail2Ban, firewalls, SELinux/AppArmor |
| 07 | [Log Management](docs/07-log-management.md) | journalctl, logrotate, and /var/log/ |
| 08 | [Cron & Scheduling](docs/08-cron-and-scheduling.md) | Automating tasks with cron and systemd timers |
| 09 | [Networking Basics](docs/09-networking-basics.md) | Static IP, DNS, nmcli |
| 📋 | [Quick Reference](docs/QUICK-REFERENCE.md) | Cheat sheet of all essential commands |

---

## Repository Structure

```
initial-server-setup/
├── README.md                   # You are here
├── CONTRIBUTING.md             # How to contribute
├── CHANGELOG.md                # Version history
├── LICENSE                     # MIT License
├── .gitignore                  # Files to exclude from git
├── docs/
│   ├── 00-prerequisites.md
│   ├── 01-initial-checks.md
│   ├── 02-system-improvements.md
│   ├── 03-essential-tools.md
│   ├── 04-package-management.md
│   ├── 05-user-management.md
│   ├── 06-security-hardening.md
│   ├── 07-log-management.md
│   ├── 08-cron-and-scheduling.md
│   ├── 09-networking-basics.md
│   └── QUICK-REFERENCE.md
└── scripts/
    ├── setup-ubuntu.sh         # Automated setup for Ubuntu/Debian
    ├── setup-rhel.sh           # Automated setup for CentOS/AlmaLinux
    └── files/
        └── history.sh          # Deployed to /etc/profile.d/history.sh
```

---

## Tested On

| Distribution | Version | Status |
|---|---|---|
| Ubuntu | 22.04 LTS (Jammy) | ✅ Tested |
| Ubuntu | 24.04 LTS (Noble) | ✅ Tested |
| AlmaLinux | 8.x | ✅ Tested |
| AlmaLinux | 9.x | ✅ Tested |
| CentOS Stream | 9 | ✅ Tested |

---

## Contributing

Contributions are welcome! Please read [`CONTRIBUTING.md`](CONTRIBUTING.md) before submitting a pull request.

---

## License

This project is licensed under the MIT License — see the [`LICENSE`](LICENSE) file for details.
