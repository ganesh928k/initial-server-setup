# 02. System Improvements

Now that we have verified the baseline, let's configure some basic system settings.

## 1. Setting the Hostname
A descriptive hostname is important for identifying the server.

```bash
# View current hostname
hostnamectl status

# Set a new hostname
sudo hostnamectl set-hostname your-new-hostname
```
*Note: You may need to log out and log back in to see the prompt update.*

## 2. Time Zone and NTP (Network Time Protocol)
Accurate time is essential for logging, scheduling, and cryptographic operations.

**Check Current Time/Zone:**
```bash
timedatectl status
```

**Set Time Zone:**
```bash
# List available time zones
timedatectl list-timezones

# Set your specific time zone
sudo timedatectl set-timezone America/New_York
```

**Enable NTP Synchronization:**
Most modern Linux distributions use `systemd-timesyncd` or `chrony`.
```bash
sudo timedatectl set-ntp true
```

## 3. Configure System Locale
Ensure the system language and character encoding are correctly set (usually UTF-8).

```bash
# View current locale
locale

# Generate necessary locale (Ubuntu Example for US English)
sudo locale-gen en_US.UTF-8

# Update system locale
sudo update-locale LANG=en_US.UTF-8
```
