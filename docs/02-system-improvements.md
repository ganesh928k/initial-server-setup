# 02. System Improvements

Now that we have verified the baseline, let's configure some foundational system settings. These are things you should do **every time** you set up a fresh server.

---

## 1. Update All Packages First

Before making any configuration changes, update everything to get the latest security patches.

**Ubuntu / Debian:**
```bash
sudo apt update && sudo apt full-upgrade -y
```

**CentOS / AlmaLinux / RHEL:**
```bash
sudo dnf upgrade -y
```

---

## 2. Setting the Hostname

A descriptive hostname uniquely identifies your server on the network (e.g., `web-prod-01`, `db-staging`).

```bash
# View current hostname and related details
hostnamectl status

# Set a new hostname
sudo hostnamectl set-hostname your-new-hostname
```

**Update /etc/hosts to match:**
After changing the hostname, update `/etc/hosts` to ensure local resolution works correctly. Without this, `sudo` may show a warning like `sudo: unable to resolve host`.

```bash
sudo nano /etc/hosts
```

Add or edit the line that maps `127.0.1.1` to your new hostname:
```
127.0.0.1   localhost
127.0.1.1   your-new-hostname
```

> **Note:** Log out and log back in to see the updated hostname in your shell prompt.

---

## 3. Time Zone and NTP (Network Time Protocol)

Accurate time is critical for:
- Log timestamps (you need to know *when* things happened)
- SSL/TLS certificate validation
- Scheduled cron jobs running at the right time

**Check Current Time and Time Zone:**
```bash
timedatectl status
```

**List Available Time Zones:**
```bash
timedatectl list-timezones | grep Asia   # Example: searching for Asian timezones
timedatectl list-timezones | grep America
```

**Set Your Time Zone:**
```bash
sudo timedatectl set-timezone Asia/Kolkata   # Change to your region
```

**Enable NTP Synchronization:**
```bash
sudo timedatectl set-ntp true

# Verify NTP is active
timedatectl status
```

**Ubuntu uses `systemd-timesyncd` by default.** For production servers requiring higher accuracy, consider `chrony`:
```bash
# Ubuntu
sudo apt install -y chrony
sudo systemctl enable --now chrony

# RHEL/AlmaLinux (chrony is usually pre-installed)
sudo systemctl enable --now chronyd
chronyc tracking   # Verify sync status
```

---

## 4. Configure System Locale

Locale controls the language, date format, and character encoding. Always use **UTF-8**.

**Check Current Locale:**
```bash
locale
```

**Ubuntu / Debian:**
```bash
sudo locale-gen en_US.UTF-8
sudo update-locale LANG=en_US.UTF-8
```

**CentOS / AlmaLinux / RHEL:**
```bash
# Use localectl on RHEL-based systems
sudo localectl set-locale LANG=en_US.UTF-8

# Verify
localectl status
```

---

**Next Step:** [03. Essential Tools →](03-essential-tools.md)
