# 06. Security Hardening

Security hardening is the process of reducing the server's attack surface. After this guide, your server will have layered defenses that make unauthorized access significantly harder.

> ⚠️ **Critical Warning:** Before applying SSH restrictions, make sure you have a working SSH key uploaded and a session open. Applying `PasswordAuthentication no` without a working key will lock you out permanently.

---

## 1. Advanced SSH Hardening

SSH is the most common entry point for attackers. Hardening it is non-negotiable.

### Step 1: Backup the Original Config
```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
```

### Step 2: Edit the Config
```bash
sudo nano /etc/ssh/sshd_config
```

**Recommended settings — find each line and update it:**

```bash
# Disable direct root login — use a regular user with sudo instead
PermitRootLogin no

# Disable password authentication — require SSH keys
PasswordAuthentication no

# Change the default SSH port to reduce automated scan noise (optional)
Port 2222

# Only allow specific users to connect via SSH
AllowUsers john adminuser

# Disconnect idle sessions after 10 minutes (300 seconds x 3 checks)
ClientAliveInterval 300
ClientAliveCountMax 3

# Disable unused authentication methods
ChallengeResponseAuthentication no
X11Forwarding no
```

### Step 3: Test the Config BEFORE Restarting

This is the most important step — **always test before restarting SSH**.
```bash
sudo sshd -t
```
If there is no output, the config is valid. If you see an error, fix it before proceeding.

### Step 4: Restart SSH
```bash
sudo systemctl restart sshd

# Verify SSH is running
sudo systemctl status sshd
```

> **Tip:** Keep your current SSH session open in a second terminal window while testing from a new one. This way, if you get locked out, you still have the original session to fix it.

---

## 2. Activity Logging — Bash History for All Users

To maintain an audit trail of all commands typed on the server, create a global bash history configuration.

```bash
sudo nano /etc/profile.d/history.sh
```

Paste the following:
```bash
# Timestamp format: YYYY-MM-DD HH:MM:SS before each command
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

# Remember the last 10,000 commands in memory
export HISTSIZE=10000

# Store the last 20,000 commands in the history file
export HISTFILESIZE=20000

# Don't store duplicate commands or commands starting with a space
export HISTCONTROL=ignoredups:ignorespace

# Append to history file instead of overwriting it on each logout
shopt -s histappend

# Write to history after every command (not just on logout)
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
```

Set correct permissions:
```bash
sudo chmod 644 /etc/profile.d/history.sh
```

This applies to **all users** automatically at login.

**Viewing history with timestamps:**
```bash
history          # Shows all commands with timestamps
history | grep sudo   # Filter for all sudo commands
```

---

## 3. Fail2Ban — Brute Force Protection

Fail2Ban monitors log files and **automatically bans IP addresses** that repeatedly fail authentication.

**Install:**
```bash
# Ubuntu
sudo apt install -y fail2ban

# RHEL/AlmaLinux
sudo dnf install -y fail2ban
```

**Configure:**

Create a local override file (never edit the default `jail.conf` directly):
```bash
sudo nano /etc/fail2ban/jail.local
```

Paste this configuration:
```ini
[DEFAULT]
# Ban duration: 1 hour (in seconds)
bantime  = 3600

# Time window for counting failures: 10 minutes
findtime = 600

# Number of failures before banning
maxretry = 5

# Email notification (optional — set your email if desired)
# destemail = admin@example.com

[sshd]
enabled  = true
port     = ssh
logpath  = %(sshd_log)s
backend  = %(syslog_backend)s
maxretry = 3
```

> **Note:** If you changed the SSH port (e.g., to `2222`), update `port = 2222` in the `[sshd]` section.

**Enable and start Fail2Ban:**
```bash
sudo systemctl enable --now fail2ban

# Check status and see active jails
sudo fail2ban-client status
sudo fail2ban-client status sshd
```

**Useful Fail2Ban commands:**
```bash
# Manually unban an IP
sudo fail2ban-client set sshd unbanip <IP_ADDRESS>

# Check if an IP is currently banned
sudo fail2ban-client get sshd banned
```

---

## 4. Firewall Setup

A firewall is your first line of network defense. Configure it to block everything and only allow what is needed.

### Ubuntu (UFW — Uncomplicated Firewall)

```bash
sudo apt install -y ufw

# Set default policies: block all incoming, allow all outgoing
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH (use your custom port if you changed it: sudo ufw allow 2222/tcp)
sudo ufw allow ssh

# Allow common web ports
sudo ufw allow http
sudo ufw allow https

# Enable the firewall
sudo ufw enable

# Verify the rules
sudo ufw status verbose
```

### CentOS / AlmaLinux (firewalld)

```bash
sudo dnf install -y firewalld
sudo systemctl enable --now firewalld

# Add services permanently
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https

# If using a custom SSH port
sudo firewall-cmd --permanent --add-port=2222/tcp

# Apply all changes
sudo firewall-cmd --reload

# Verify
sudo firewall-cmd --list-all
```

---

## 5. Mandatory Access Control (MAC)

MAC provides an additional layer of security by restricting what programs and processes can access, even if they are compromised.

### Ubuntu (AppArmor)

AppArmor is enabled by default on Ubuntu.

```bash
# Check status and see all profiles
sudo apparmor_status

# List all loaded profiles and their modes
sudo aa-status

# Put a specific profile into enforce mode
sudo aa-enforce /etc/apparmor.d/profile_name

# Put a profile into complain mode (log violations without blocking)
sudo aa-complain /etc/apparmor.d/profile_name
```

### CentOS / AlmaLinux (SELinux)

SELinux provides Mandatory Access Control on all RHEL-based systems. It has three modes:
- **Enforcing**: Policies are enforced; violations are blocked and logged.
- **Permissive**: Violations are logged but NOT blocked — useful for debugging.
- **Disabled**: SELinux is turned off (not recommended in production).

```bash
# Check current SELinux status and mode
sestatus

# Temporarily switch to Permissive mode (survives until reboot)
sudo setenforce 0

# Temporarily switch back to Enforcing
sudo setenforce 1
```

**Permanent mode change** — edit the config file:
```bash
sudo nano /etc/selinux/config
```
```ini
SELINUX=enforcing   # Options: enforcing, permissive, disabled
```

**Troubleshooting SELinux denials:**
```bash
# Search the audit log for recent SELinux denials
sudo ausearch -m avc -ts recent

# Suggest policy rules to allow a denied action
sudo audit2allow -a
```

---

**Next Step:** [07. Log Management →](07-log-management.md)
