# 01. Initial Server Checks

After installing a minimal Linux OS, it's crucial to understand your system's starting point.

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

## 2. Check Network Configuration
Ensure your interfaces are up and have the correct IP addresses assigned.

```bash
# View IP addresses
ip addr show

# Check default gateway
ip route

# Test internet connectivity and DNS resolution
ping -c 4 google.com
```

## 3. Review Disk Partitions and Mounts
Check how your disk is partitioned and how much space is available.

```bash
# Show file system disk space usage
df -h

# Show block devices (disks and partitions)
lsblk
```

## 4. Monitor System Resources
Look at your current memory (RAM) and CPU usage to establish a baseline.

```bash
# View memory usage
free -h

# View basic system uptime and load average
uptime

# Basic process viewer
top
```
