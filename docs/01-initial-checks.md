# 01. Initial Server Checks

After installing a minimal Linux OS, the very first thing you should do is **understand where you are starting from**. Think of this as a health report for a brand new server.

---

## 1. Verify OS Version and Kernel

Confirm you are running the expected OS and kernel version.

**Ubuntu / Debian:**
```bash
cat /etc/os-release
uname -r
```

**CentOS / AlmaLinux / RHEL:**
```bash
cat /etc/redhat-release
cat /etc/os-release
uname -r
```

> **What to look for:** Confirm the OS name, version, and that the kernel is up to date. A minimal install may ship with an older kernel that requires updates.

---

## 2. Check for Failed Services

Right after a fresh install, check if any critical services failed to start.

```bash
# List all failed units
systemctl --failed
```

> **What to look for:** The output should show `0 loaded units listed`. If any service is in `failed` state, investigate it before proceeding.

---

## 3. Check Network Configuration

Ensure your network interfaces are up and have the correct IP addresses.

```bash
# View all IP addresses and network interfaces
ip addr show

# Check the default routing table (gateway)
ip route

# Test internet connectivity
ping -c 4 google.com

# Verify DNS resolution is working
nslookup google.com
```

> **What to look for:** You should see an IP address on your main interface (e.g., `eth0` or `ens3`), a default gateway, and successful ping replies.

---

## 4. Check /etc/hosts

Verify that the hostname resolves locally — without this, `sudo` can throw warnings.

```bash
cat /etc/hosts
```

You should see an entry like:
```
127.0.0.1   localhost
127.0.1.1   your-hostname
```

---

## 5. Review Disk Partitions and Mounts

Check how your disk is partitioned and how much space is available.

```bash
# Show disk space usage for all mounted file systems
df -h

# Show all block devices (disks and partitions) in a tree view
lsblk

# List partitions with more detail
fdisk -l
```

> **What to look for:** Ensure `/` (root) has sufficient free space. A minimal install typically uses 1–2 GB, leaving plenty of room.

---

## 6. Check Open Network Ports

See which services are already listening on the network — this is your starting attack surface.

```bash
# Show all listening TCP/UDP ports with the process using them
ss -tulnp
```

> **What to look for:** On a minimal install, you should only see SSH (port 22). Any other unexpected open ports should be investigated.

---

## 7. Monitor System Resources

Establish a resource baseline before installing anything.

```bash
# View memory (RAM) and swap usage
free -h

# View CPU count and model
lscpu

# View system uptime and load average
uptime

# View CPU/process usage interactively (press 'q' to quit)
top
```

> **Tip:** Load average shown by `uptime` represents the average number of processes waiting for CPU over 1, 5, and 15 minutes. On a 1-core VM, a load average above `1.0` means the CPU is saturated.

---

## 8. Check Hardware Info

```bash
# View detailed hardware info (may need to install: apt/dnf install dmidecode)
sudo dmidecode -t system   # System manufacturer and model
sudo dmidecode -t memory   # RAM slot and size info
sudo dmidecode -t bios     # BIOS version
```

---

**Next Step:** [02. System Improvements →](02-system-improvements.md)
