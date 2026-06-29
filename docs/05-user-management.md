# 05. User Management

For security, avoid working as the `root` user directly. Instead, create a standard user account and grant it administrative privileges via `sudo`.

## 1. Creating a New User

**Ubuntu / Debian:**
```bash
# Interactive, user-friendly command
sudo adduser username
```

**CentOS / AlmaLinux / RHEL:**
```bash
# Non-interactive command
sudo useradd username

# Set the password for the new user
sudo passwd username
```

## 2. Granting Sudo Privileges

Add the user to the appropriate administrative group so they can run `sudo` commands.

**Ubuntu / Debian:**
```bash
sudo usermod -aG sudo username
```

**CentOS / AlmaLinux / RHEL:**
```bash
sudo usermod -aG wheel username
```

**Verifying Sudo Access:**
Switch to the new user and test `sudo`.
```bash
su - username
sudo ls /root
```

## 3. Advanced Sudoers Configuration (`visudo`)
To modify sudo rules safely, always use `visudo`. It checks for syntax errors before saving, preventing accidental lockouts.

```bash
sudo visudo
```

## 4. Enforcing Password Policies
To secure user accounts, configure password aging (forcing regular password changes).

```bash
# View current password aging info for a user
chage -l username

# Force a password change every 90 days, with a warning 7 days before
sudo chage -M 90 -W 7 username
```

## 5. Deleting a User
When a user no longer needs access, remove their account.

```bash
# Remove user but keep their home directory
sudo userdel username

# Remove user AND their home directory
sudo userdel -r username
```
