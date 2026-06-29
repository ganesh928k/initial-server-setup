# Quick Reference Cheat Sheet

A one-stop command reference for everything covered in this repository. Bookmark this page.

---

## System Information

```bash
cat /etc/os-release          # OS name and version
uname -r                     # Kernel version
hostnamectl status           # Hostname, OS, kernel, architecture
uptime                       # Uptime and load average
free -h                      # RAM and swap usage
df -h                        # Disk space on all mounts
lsblk                        # Block devices and partition layout
lscpu                        # CPU info
ip addr show                 # IP addresses and network interfaces
ss -tulnp                    # Listening ports and services
systemctl --failed           # Show any failed services
```

---

## Package Management

| Task | Ubuntu (APT) | RHEL/AlmaLinux (DNF) |
|---|---|---|
| Update package lists | `apt update` | *(included in upgrade)* |
| Upgrade all packages | `apt full-upgrade -y` | `dnf upgrade -y` |
| Install a package | `apt install -y pkg` | `dnf install -y pkg` |
| Remove a package | `apt remove pkg` | `dnf remove pkg` |
| Purge config files | `apt purge pkg` | *(use `dnf remove`)* |
| Search for a package | `apt search keyword` | `dnf search keyword` |
| List installed packages | `dpkg -l` | `rpm -qa` |
| Hold package version | `apt-mark hold pkg` | `dnf versionlock pkg` |
| Clean cache | `apt clean && apt autoremove -y` | `dnf clean all && dnf autoremove -y` |
| Undo last transaction | *(not natively supported)* | `dnf history undo last` |

---

## User & Group Management

```bash
# Users
adduser john                     # Add user (Ubuntu - interactive)
useradd -m -s /bin/bash john     # Add user (RHEL)
passwd john                      # Set/change password
usermod -aG sudo john            # Add to sudo group (Ubuntu)
usermod -aG wheel john           # Add to wheel group (RHEL)
userdel -r john                  # Delete user and home dir
usermod -L john                  # Lock account
usermod -U john                  # Unlock account
chage -l john                    # View password aging
chage -M 90 -W 7 john            # 90-day max, 7-day warning
getent passwd                    # List all users
who                              # Who is logged in now
last                             # Recent login history

# Groups
groupadd developers              # Create a group
usermod -aG developers john      # Add user to group
gpasswd -d john developers       # Remove user from group
groups john                      # Show groups for a user
groupdel developers              # Delete a group
```

---

## SSH

```bash
ssh-keygen -t ed25519 -C "email"     # Generate SSH key pair
ssh-copy-id user@server_ip           # Copy public key to server
ssh user@server_ip                   # Connect to server
ssh -p 2222 user@server_ip           # Connect on custom port
sudo sshd -t                         # Test SSH config (always before restarting!)
sudo systemctl restart sshd          # Apply SSH config changes
```

---

## Firewall

| Task | Ubuntu (UFW) | RHEL/AlmaLinux (firewalld) |
|---|---|---|
| Enable firewall | `ufw enable` | `systemctl enable --now firewalld` |
| Status | `ufw status verbose` | `firewall-cmd --list-all` |
| Allow SSH | `ufw allow ssh` | `firewall-cmd --permanent --add-service=ssh` |
| Allow port | `ufw allow 8080/tcp` | `firewall-cmd --permanent --add-port=8080/tcp` |
| Deny port | `ufw deny 8080` | `firewall-cmd --permanent --remove-port=8080/tcp` |
| Apply rules | *(instant)* | `firewall-cmd --reload` |

---

## Fail2Ban

```bash
sudo systemctl status fail2ban          # Check Fail2Ban is running
sudo fail2ban-client status             # List all active jails
sudo fail2ban-client status sshd        # Show SSH jail (banned IPs, stats)
sudo fail2ban-client set sshd unbanip <IP>  # Unban an IP address
tail -f /var/log/fail2ban.log           # Watch Fail2Ban activity live
```

---

## Logs & Journalctl

```bash
journalctl -f                           # Follow all logs in real-time
journalctl -u sshd                      # Logs for SSH service
journalctl -b                           # Logs since current boot
journalctl -p err                       # Errors and above only
journalctl --since "1 hour ago"         # Logs from the last hour
grep "Failed password" /var/log/auth.log   # Failed SSH logins (Ubuntu)
grep "Failed password" /var/log/secure     # Failed SSH logins (RHEL)
```

---

## Cron

```bash
crontab -e        # Edit your cron jobs
crontab -l        # List your cron jobs
sudo crontab -u john -e   # Edit another user's crontab

# Cron expression: MIN HOUR DOM MON DOW command
# Examples:
# Run at 2:30 AM daily:   30 2 * * * /script.sh
# Run every hour:         0 * * * * /script.sh
# Run every Sunday midnight: 0 0 * * 0 /script.sh
```

---

## Networking

```bash
ip addr show               # View IP addresses
ip route                   # View routing table
ping -c 4 8.8.8.8          # Test connectivity
nslookup google.com        # DNS lookup
ss -tulnp                  # Open ports and services
traceroute google.com      # Network path trace
nmcli connection show      # List network connections (RHEL)
sudo netplan apply         # Apply netplan changes (Ubuntu)
```

---

## SELinux (RHEL/AlmaLinux)

```bash
sestatus                   # Check SELinux mode
setenforce 0               # Temporarily set Permissive (logging only)
setenforce 1               # Temporarily set Enforcing
sudo ausearch -m avc -ts recent   # View recent SELinux denials
sudo audit2allow -a               # Suggest rules for denied actions
```

---

## AppArmor (Ubuntu)

```bash
sudo apparmor_status       # Check status and loaded profiles
sudo aa-status             # Same, more detail
sudo aa-enforce profile    # Put a profile in enforce mode
sudo aa-complain profile   # Put a profile in complain mode
```
