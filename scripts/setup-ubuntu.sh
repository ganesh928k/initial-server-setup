#!/bin/bash
# =============================================================================
# Setup Script for Ubuntu / Debian Systems
# Repository: initial-server-setup
# =============================================================================
# USAGE:
#   sudo bash scripts/setup-ubuntu.sh
#
# WHAT THIS DOES (in order):
#   1. Updates and upgrades all system packages
#   2. Installs essential administrator tools
#   3. Configures timezone (UTC) and enables NTP
#   4. Configures global bash history with timestamps
#   5. Installs and configures Fail2Ban for SSH protection
#   6. Hardens SSH configuration (requires SSH keys to be set up first!)
#   7. Configures UFW firewall with safe defaults
#
# All actions are logged to: /var/log/server-setup.log
# =============================================================================

set -euo pipefail   # -e: exit on error | -u: error on undefined var | -o pipefail: catch pipe errors

# --- Color Codes for Pretty Output ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# --- Logging Setup ---
LOG_FILE="/var/log/server-setup.log"
exec > >(tee -a "$LOG_FILE") 2>&1  # Log all output to file AND terminal

# --- Helper Functions ---
info()    { echo -e "${BLUE}[INFO]${NC}  $1"; }
success() { echo -e "${GREEN}[OK]${NC}    $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
step()    { echo -e "\n${BOLD}${BLUE}==[ $1 ]==${NC}"; }

# --- Root Check ---
if [ "$EUID" -ne 0 ]; then
  error "This script must be run as root. Use: sudo bash $0"
fi

# --- OS Check ---
if ! grep -qi "ubuntu\|debian" /etc/os-release; then
  error "This script is intended for Ubuntu/Debian systems only."
fi

echo ""
echo -e "${BOLD}============================================${NC}"
echo -e "${BOLD}  Ubuntu Server Post-Installation Setup    ${NC}"
echo -e "${BOLD}============================================${NC}"
echo -e "  Log file: ${LOG_FILE}"
echo -e "  Started:  $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# =============================================================================
# STEP 1: Update and Upgrade Packages
# =============================================================================
step "1/7 — Updating and Upgrading Packages"
info "Running apt update and full-upgrade..."
apt update -qq && apt full-upgrade -y -qq
success "System packages are up to date."

# =============================================================================
# STEP 2: Install Essential Tools
# =============================================================================
step "2/7 — Installing Essential Administrator Tools"
TOOLS="htop tmux screen curl wget vim nano git net-tools tree rsync bash-completion lsof unzip fail2ban ufw"
info "Installing: $TOOLS"
apt install -y -qq $TOOLS
success "Essential tools installed."

# =============================================================================
# STEP 3: Configure Timezone and NTP
# =============================================================================
step "3/7 — Configuring Timezone and NTP"
timedatectl set-timezone UTC
timedatectl set-ntp true
success "Timezone set to UTC. NTP synchronization enabled."
info "Current time: $(date)"

# =============================================================================
# STEP 4: Configure Global Bash History Logging
# =============================================================================
step "4/7 — Configuring Bash History Logging for All Users"
cat << 'EOF' > /etc/profile.d/history.sh
# Global bash history configuration — applied to all users
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
EOF
chmod 644 /etc/profile.d/history.sh
success "Bash history logging configured at /etc/profile.d/history.sh"

# =============================================================================
# STEP 5: Configure Fail2Ban
# =============================================================================
step "5/7 — Configuring Fail2Ban"
cat << 'EOF' > /etc/fail2ban/jail.local
[DEFAULT]
bantime  = 3600
findtime = 600
maxretry = 5

[sshd]
enabled  = true
port     = ssh
logpath  = %(sshd_log)s
backend  = %(syslog_backend)s
maxretry = 3
EOF
systemctl enable --now fail2ban
success "Fail2Ban configured and started. IPs will be banned after 3 failed SSH attempts."

# =============================================================================
# STEP 6: SSH Hardening
# =============================================================================
step "6/7 — Hardening SSH Configuration"

warn "IMPORTANT: This step disables password authentication and root login."
warn "Ensure your SSH public key is already in ~/.ssh/authorized_keys before proceeding."
echo ""
read -r -p "$(echo -e "${YELLOW}Do you have SSH key-based access set up? [yes/NO]: ${NC}")" SSH_CONFIRM

if [[ "$SSH_CONFIRM" =~ ^[Yy][Ee][Ss]$ ]]; then
  cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
  info "Backup saved to /etc/ssh/sshd_config.bak"

  sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
  sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
  sed -i 's/^#\?X11Forwarding.*/X11Forwarding no/' /etc/ssh/sshd_config

  # Test config before restarting
  if sshd -t; then
    systemctl restart sshd
    success "SSH hardened: root login disabled, password auth disabled."
  else
    warn "SSH config test failed! Restoring backup..."
    cp /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
    error "SSH hardening aborted. Please review /etc/ssh/sshd_config manually."
  fi
else
  warn "Skipping SSH hardening. Run manually after setting up SSH keys."
fi

# =============================================================================
# STEP 7: Configure UFW Firewall
# =============================================================================
step "7/7 — Configuring UFW Firewall"
ufw --force reset > /dev/null 2>&1   # Reset to a clean state
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https
ufw --force enable
success "UFW firewall enabled with rules: SSH, HTTP, HTTPS allowed."

# =============================================================================
# Summary
# =============================================================================
echo ""
echo -e "${BOLD}${GREEN}============================================${NC}"
echo -e "${BOLD}${GREEN}  Setup Complete!                           ${NC}"
echo -e "${BOLD}${GREEN}============================================${NC}"
echo ""
echo -e "  ${GREEN}✓${NC} Packages updated"
echo -e "  ${GREEN}✓${NC} Essential tools installed"
echo -e "  ${GREEN}✓${NC} Timezone: UTC | NTP: enabled"
echo -e "  ${GREEN}✓${NC} Bash history logging: /etc/profile.d/history.sh"
echo -e "  ${GREEN}✓${NC} Fail2Ban: active (SSH jail enabled)"
if [[ "$SSH_CONFIRM" =~ ^[Yy][Ee][Ss]$ ]]; then
  echo -e "  ${GREEN}✓${NC} SSH hardened: root login disabled, keys only"
else
  echo -e "  ${YELLOW}!${NC} SSH hardening: skipped (run manually)"
fi
echo -e "  ${GREEN}✓${NC} UFW firewall: enabled"
echo ""
echo -e "  Full log: ${LOG_FILE}"
echo -e "  Completed: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""
echo -e "${YELLOW}  Recommendation: Reboot the server now.${NC}"
echo -e "  Run: ${BOLD}sudo reboot${NC}"
echo ""
