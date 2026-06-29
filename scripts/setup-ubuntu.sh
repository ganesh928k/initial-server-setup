#!/bin/bash
# Setup script for Ubuntu / Debian systems

# Exit immediately if a command exits with a non-zero status
set -e

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or using sudo."
  exit 1
fi

echo "Starting Ubuntu post-installation setup..."

# 1. Update and Upgrade Packages
echo "[1/6] Updating package lists and upgrading system..."
apt update && apt full-upgrade -y

# 2. Install Essential Tools
echo "[2/6] Installing essential administrator tools..."
apt install -y htop tmux curl wget vim git net-tools tree rsync bash-completion ufw

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

# 6. Basic Firewall Setup (UFW)
echo "[6/6] Configuring UFW (Uncomplicated Firewall)..."
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https
# Enable UFW non-interactively
ufw --force enable

echo "Ubuntu setup complete! Please reboot the server when convenient."
