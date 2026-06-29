# 05. User Management

One of the most important security principles in Linux is the **Principle of Least Privilege**: users should only have access to what they need, nothing more. Never work as `root` for day-to-day tasks.

---

## 1. Listing Existing Users

Before creating new users, understand who already exists on the system.

```bash
# View all users (each line = one user account)
cat /etc/passwd

# A cleaner view — show only usernames
getent passwd | cut -d: -f1

# Show all currently logged-in users
who

# Show recent login history
last
```

> **Note:** System accounts (like `daemon`, `sshd`, `nobody`) are normal — they are used by services, not humans.

---

## 2. Creating a New User

**Ubuntu / Debian (`adduser` — interactive, user-friendly):**
```bash
sudo adduser john
```
This creates the user, prompts for a password, and sets up a home directory automatically.

**CentOS / AlmaLinux / RHEL (`useradd` — non-interactive):**
```bash
# Create user and home directory
sudo useradd -m -s /bin/bash john

# Set the password
sudo passwd john
```

---

## 3. Granting Sudo Privileges

Add the user to the admin group so they can run commands as root using `sudo`.

**Ubuntu / Debian:**
```bash
sudo usermod -aG sudo john
```

**CentOS / AlmaLinux / RHEL:**
```bash
sudo usermod -aG wheel john
```

**Verify sudo access:**
```bash
su - john
sudo whoami     # Should output: root
```

---

## 4. Advanced Sudoers Configuration (`visudo`)

`visudo` safely edits the `/etc/sudoers` file and validates syntax before saving — preventing accidental lockouts.

```bash
sudo visudo
```

**Useful sudoers entries:**
```bash
# Allow john to run ALL commands as root
john ALL=(ALL:ALL) ALL

# Allow john to run sudo WITHOUT a password (useful for automation)
john ALL=(ALL:ALL) NOPASSWD: ALL

# Allow john to only restart nginx, nothing else
john ALL=(ALL) /bin/systemctl restart nginx
```

---

## 5. Setting Up SSH Keys for a User

SSH key authentication is **far more secure** than password logins. Here's how to set it up for a new user.

**On your local machine (generate a key pair if you don't have one):**
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
# Your public key is at: ~/.ssh/id_ed25519.pub
```

**Copy your public key to the server:**
```bash
# Automated method (recommended)
ssh-copy-id john@<server_ip>

# Manual method
cat ~/.ssh/id_ed25519.pub
# Then on the server, as the john user:
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys   # Paste the public key here
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

> **Why ed25519?** It's a modern elliptic curve algorithm — more secure and faster than the older RSA-2048.

---

## 6. Group Management

Groups let you manage permissions for multiple users at once.

```bash
# Create a new group
sudo groupadd developers

# Add a user to a group
sudo usermod -aG developers john

# View all groups a user belongs to
groups john

# List all groups on the system
getent group

# Remove a user from a group
sudo gpasswd -d john developers

# Delete a group
sudo groupdel developers
```

---

## 7. Enforcing Password Policies (Password Aging)

Force users to change their passwords periodically and set complexity rules.

```bash
# View current password aging info for a user
sudo chage -l john

# Enforce a password change every 90 days, warning 7 days before expiry
sudo chage -M 90 -W 7 john

# Force the user to change their password on next login
sudo chage -d 0 john
```

**Install and configure `pam_pwquality` for password complexity:**

```bash
# Ubuntu
sudo apt install -y libpam-pwquality

# RHEL/AlmaLinux
sudo dnf install -y pam_pwquality
```

Edit the configuration:
```bash
sudo nano /etc/security/pwquality.conf
```

Recommended settings:
```ini
minlen = 12          # Minimum password length of 12 characters
dcredit = -1         # Require at least 1 digit
ucredit = -1         # Require at least 1 uppercase letter
lcredit = -1         # Require at least 1 lowercase letter
ocredit = -1         # Require at least 1 special character
```

---

## 8. Locking and Unlocking User Accounts

```bash
# Lock a user account (prevents login)
sudo usermod -L john

# Unlock a user account
sudo usermod -U john

# Check if an account is locked (look for ! in the password field)
sudo passwd -S john
```

---

## 9. Deleting a User

```bash
# Remove user but KEEP their home directory
sudo userdel john

# Remove user AND their home directory (use with caution!)
sudo userdel -r john
```

---

**Next Step:** [06. Security Hardening →](06-security-hardening.md)
