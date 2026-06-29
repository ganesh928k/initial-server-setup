# 00. Prerequisites

Before diving into the guide, let's make sure you have the right environment set up. You do not need a physical machine — a **virtual machine (VM)** works perfectly for learning.

---

## 1. What You Need

| Requirement | Details |
|---|---|
| **Virtualization Software** | VirtualBox (free), VMware Workstation, or KVM |
| **Minimal ISO** | Ubuntu Server, AlmaLinux, or CentOS Stream |
| **SSH Client** | Terminal (Linux/macOS), Windows Terminal, or PuTTY (Windows) |
| **Recommended RAM** | At least 1 GB for the VM (2 GB preferred) |
| **Recommended Disk** | At least 10 GB for the VM |

---

## 2. Download the Minimal ISO

Use the **minimal/server** ISO — this gives you the leanest possible installation with no GUI.

| OS | Download Link |
|---|---|
| Ubuntu Server 24.04 LTS | https://ubuntu.com/download/server |
| AlmaLinux 9 Minimal | https://almalinux.org/get-almalinux/ |
| CentOS Stream 9 | https://www.centos.org/centos-stream/ |

---

## 3. Create a Virtual Machine

When creating your VM, use these settings for a learning environment:

```
RAM:   1024 MB (minimum) / 2048 MB (recommended)
CPU:   1–2 cores
Disk:  10–20 GB (dynamically allocated is fine)
Network: NAT (for internet access) or Bridged (to connect from your host machine via SSH)
```

---

## 4. Connecting via SSH

Once installed and booted, find the VM's IP address:
```bash
ip addr show
```

Then from your host machine, connect:
```bash
ssh username@<VM_IP_ADDRESS>
```

---

## 5. Basic Terminal Survival Commands

Before you start, make sure you know these basics:

```bash
pwd          # Print current directory
ls -la       # List all files with details
cd /etc      # Change directory
man command  # Read the manual for any command (e.g., man ls)
clear        # Clear the screen
exit         # Log out of the session
```

You are now ready to start. Proceed to [01. Initial Checks →](01-initial-checks.md)
