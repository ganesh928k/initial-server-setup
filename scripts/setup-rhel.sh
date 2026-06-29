#!/bin/bash
# Setup script for CentOS / AlmaLinux / RHEL systems

# Exit immediately if a command exits with a non-zero status
set -e

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or using sudo."
  exit 1
fi

echo "Starting CentOS/AlmaLinux post-installation setup..."

# 1. Update and Upgrade Packages
echo "[1/6] Updating package lists and upgrading system..."
dnf upgrade -y

# 2. Install EPEL and Essential Tools
echo "[2/6] Installing EPEL and essential administrator tools..."
dnf install -y epel-release
dnf install -y htop tmux curl wget vim git net-tools tree rsync bash-completion firewalld

# 3. Configure Timezone and NTP
echo "[3/6] Configuring timezone to UTC and enabling NTP..."
timedatectl set-timezone UTC
timedatectl set-ntp true

# 4. Implement Activity Logging
echo "[4/6] Configuring bash history logging for all users..."
cat << 'EOF' > /etc/profile.d/history.sh
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
EOF
chmod 644 /etc/profile.d/history.sh

# 5. Basic SSH Hardening
echo "[5/6] Hardening SSH configuration..."
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
# Restarting SSH conditionally
systemctl restart sshd || echo "Warning: Could not restart SSH daemon."

# 6. Basic Firewall Setup (firewalld)
echo "[6/6] Configuring firewalld..."
systemctl enable --now firewalld
firewall-cmd --permanent --add-service=ssh
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload

echo "CentOS/AlmaLinux setup complete! Please reboot the server when convenient."
