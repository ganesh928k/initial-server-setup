# 07. Log Management

Logs are your window into everything happening on the server. As an administrator, understanding logs is essential for troubleshooting, auditing, and security monitoring.

---

## 1. Log Files in `/var/log/`

Linux stores system logs in the `/var/log/` directory. Here are the most important ones:

| Log File | What it Contains |
|---|---|
| `/var/log/syslog` (Ubuntu) | General system messages |
| `/var/log/messages` (RHEL) | General system messages |
| `/var/log/auth.log` (Ubuntu) | Authentication events: logins, sudo, SSH |
| `/var/log/secure` (RHEL) | Authentication events: logins, sudo, SSH |
| `/var/log/kern.log` | Kernel messages |
| `/var/log/fail2ban.log` | Fail2Ban activity |
| `/var/log/dpkg.log` | APT package install/remove history |
| `/var/log/dnf.log` | DNF package install/remove history |

**Quick viewing commands:**
```bash
# View a log file (press 'q' to quit)
sudo less /var/log/auth.log

# Follow a log file in real-time (like watching a live feed)
sudo tail -f /var/log/auth.log

# View last 50 lines of a log
sudo tail -n 50 /var/log/syslog

# Search inside a log file
sudo grep "Failed password" /var/log/auth.log
```

---

## 2. `journalctl` — The Modern Way (systemd)

On modern Linux systems using `systemd`, `journalctl` is the central tool for viewing all logs collected by the systemd journal.

```bash
# View all logs (newest at the bottom, press 'G' to jump to end)
sudo journalctl

# Follow logs in real-time (like tail -f)
sudo journalctl -f

# Show logs for a specific service
sudo journalctl -u sshd
sudo journalctl -u nginx
sudo journalctl -u fail2ban

# Show logs since the last boot only
sudo journalctl -b

# Show logs from the previous boot
sudo journalctl -b -1

# Show logs from the last hour
sudo journalctl --since "1 hour ago"

# Show logs between specific dates/times
sudo journalctl --since "2026-06-01 00:00:00" --until "2026-06-29 23:59:59"

# Show only errors and critical messages
sudo journalctl -p err

# Show logs for a specific user
sudo journalctl _UID=1001
```

---

## 3. `logrotate` — Preventing Logs from Filling Your Disk

Logs can grow very large over time. `logrotate` automatically compresses and rotates log files on a schedule.

**View the main config:**
```bash
cat /etc/logrotate.conf
```

**View per-application configs:**
```bash
ls /etc/logrotate.d/
```

**Example custom logrotate config** (`/etc/logrotate.d/myapp`):
```
/var/log/myapp/*.log {
    daily               # Rotate daily
    rotate 14           # Keep 14 rotated files
    compress            # Compress old logs with gzip
    delaycompress       # Compress after 2nd rotation (keeps 1 uncompressed)
    missingok           # Don't error if log file is missing
    notifempty          # Don't rotate if the log is empty
    create 0644 root root  # Create new log file with these permissions
}
```

**Test your logrotate config manually:**
```bash
sudo logrotate --debug /etc/logrotate.conf
```

---

## 4. Checking for Failed Login Attempts

A critical admin task — regularly check for brute-force attempts.

```bash
# Ubuntu — failed SSH login attempts
sudo grep "Failed password" /var/log/auth.log | tail -20

# RHEL/AlmaLinux — failed SSH login attempts
sudo grep "Failed password" /var/log/secure | tail -20

# Count failed attempts per IP (see who is hammering your server)
sudo grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | sort -rn | head -10

# View successful logins
sudo grep "Accepted" /var/log/auth.log
```

---

**Next Step:** [08. Cron & Scheduling →](08-cron-and-scheduling.md)
