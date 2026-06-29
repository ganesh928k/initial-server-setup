# 06. Security Hardening

Securing the server minimizes the attack surface. We will configure SSH, implement comprehensive logging, set up firewalls, and review Mandatory Access Control.

## 1. Advanced SSH Hardening
The Secure Shell (SSH) daemon is a prime target for attacks. We will harden its configuration in `/etc/ssh/sshd_config`.

```bash
# Ensure you have a backup of the original configuration
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
```

**Recommended Changes:**
- `PermitRootLogin no`: Disallow direct root login.
- `PasswordAuthentication no`: Force SSH key-based authentication.
- `Port 2222`: Change the default port (optional, but reduces automated brute force noise).
- `AllowUsers username`: Restrict SSH access to specific users.

**Apply and Restart:**
```bash
# Reload or restart the SSH daemon to apply changes
sudo systemctl restart sshd
```
*Warning: Always ensure your SSH keys are set up and you have a working session open before restarting `sshd` with `PasswordAuthentication no`.*

## 2. Activity Logging (Bash History)
To maintain an audit trail, we can configure bash history to log timestamps and make it globally consistent.

Create a custom profile script `/etc/profile.d/history.sh` to apply history rules to all users:

```bash
# Example /etc/profile.d/history.sh content:
export HISTTIMEFORMAT="%F %T "
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
```
This ensures that all commands typed by all users are properly time-stamped and appended to their `.bash_history` instead of overwriting it.

## 3. Firewall Setup
A firewall controls incoming and outgoing network traffic based on predetermined security rules.

### Ubuntu (UFW - Uncomplicated Firewall)
```bash
sudo apt install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh  # Or your custom SSH port: sudo ufw allow 2222/tcp
sudo ufw allow http
sudo ufw allow https
sudo ufw enable
```

### CentOS / AlmaLinux (firewalld)
```bash
sudo dnf install -y firewalld
sudo systemctl enable --now firewalld
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
# If using a custom SSH port:
# sudo firewall-cmd --permanent --add-port=2222/tcp
sudo firewall-cmd --reload
```

## 4. Mandatory Access Control (MAC)
MAC systems confine programs to a limited set of resources, providing defense-in-depth even if a process is compromised.

### Ubuntu (AppArmor)
AppArmor is installed and enabled by default on Ubuntu.
```bash
# Check AppArmor status
sudo apparmor_status
```

### CentOS / AlmaLinux (SELinux)
SELinux is the standard for RHEL-based systems.
```bash
# Check SELinux status (Enforcing, Permissive, Disabled)
sestatus

# Temporarily set to Permissive (for debugging)
sudo setenforce 0

# Temporarily set to Enforcing
sudo setenforce 1
```
*Note: Permanent changes are made in `/etc/selinux/config`.*
