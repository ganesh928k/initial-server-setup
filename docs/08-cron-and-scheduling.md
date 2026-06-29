# 08. Cron & Scheduling

As an administrator, many tasks need to run automatically on a schedule — backups, updates, cleanup scripts, and health checks. Linux provides two main scheduling tools: **cron** and **systemd timers**.

---

## 1. Cron — The Classic Scheduler

Cron runs commands at specified times. The schedule is defined using a **cron expression**.

### Cron Expression Format

```
* * * * *  command_to_run
│ │ │ │ │
│ │ │ │ └──── Day of week (0-7, Sunday = 0 or 7)
│ │ │ └────── Month (1-12)
│ │ └──────── Day of month (1-31)
│ └────────── Hour (0-23)
└──────────── Minute (0-59)
```

### Common Examples

```bash
# Run every minute
* * * * * /path/to/script.sh

# Run at 2:30 AM every day
30 2 * * * /path/to/backup.sh

# Run every hour
0 * * * * /path/to/check.sh

# Run at midnight every Sunday
0 0 * * 0 /path/to/weekly-cleanup.sh

# Run at 9 AM on the 1st of every month
0 9 1 * * /path/to/monthly-report.sh
```

> **Tip:** Use [crontab.guru](https://crontab.guru/) to interactively build and validate cron expressions.

### Managing Cron Jobs

```bash
# Open your personal crontab for editing
crontab -e

# List your current crontab entries
crontab -l

# Remove your entire crontab
crontab -r

# Edit another user's crontab (as root)
sudo crontab -u john -e
```

### System-Wide Cron Directories

For root-level scheduled tasks, you can place scripts in these directories instead of editing crontab directly:

```
/etc/cron.hourly/    # Scripts that run every hour
/etc/cron.daily/     # Scripts that run every day
/etc/cron.weekly/    # Scripts that run every week
/etc/cron.monthly/   # Scripts that run every month
```

Example — create a daily cleanup script:
```bash
sudo nano /etc/cron.daily/cleanup-tmp
```
```bash
#!/bin/bash
find /tmp -type f -atime +7 -delete
```
```bash
sudo chmod +x /etc/cron.daily/cleanup-tmp
```

---

## 2. Systemd Timers — The Modern Alternative

Systemd timers are more powerful and flexible than cron. They integrate with the systemd journal for logging and can be monitored with `systemctl`.

**View all active timers:**
```bash
systemctl list-timers --all
```

**Creating a simple systemd timer:**

First, create a **service unit** (what to run):
```bash
sudo nano /etc/systemd/system/my-backup.service
```
```ini
[Unit]
Description=My Backup Script

[Service]
Type=oneshot
ExecStart=/root/scripts/backup.sh
```

Then create a **timer unit** (when to run it):
```bash
sudo nano /etc/systemd/system/my-backup.timer
```
```ini
[Unit]
Description=Run My Backup Script Daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

Enable and start the timer:
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now my-backup.timer

# Verify it's active
systemctl status my-backup.timer
```

---

## 3. Logging Cron Output

By default, cron runs silently. To capture output for debugging, redirect it:

```bash
# In crontab — append stdout and stderr to a log file
30 2 * * * /path/to/backup.sh >> /var/log/backup.log 2>&1
```

---

**Next Step:** [09. Networking Basics →](09-networking-basics.md)
