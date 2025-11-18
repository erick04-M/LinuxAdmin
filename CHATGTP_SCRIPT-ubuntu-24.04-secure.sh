#!/usr/bin/env bash
# ubuntu-24.04-secure.sh
# Simple baseline hardening for Ubuntu 24.04
# Run as root: sudo ./ubuntu-24.04-secure.sh
#All of the comands and commentes below were created by ChatGTP
set -euo pipefail

# ---------- Configuration (edit if needed) ----------
SSH_PORT=22           # change if you use non-standard SSH port
ADMIN_IP=""           # optional: add your workstation IP (CIDR) to allow only it, e.g. "203.0.113.5/32"
EMAIL_FOR_UPDATES=""  # optional: set an email for unattended-upgrades notifications (requires a local MTA)
# ---------------------------------------------------

echo "Starting Ubuntu 24.04 baseline hardening..."

# 1) Update system packages
echo "Updating APT and upgrading packages..."
apt update
DEBIAN_FRONTEND=noninteractive apt -y upgrade

# 2) Ensure unattended-upgrades (automatic security updates) is installed and enabled
echo "Installing unattended-upgrades..."
apt -y install unattended-upgrades apt-listchanges

cat > /etc/apt/apt.conf.d/20auto-upgrades <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOF

# Optionally set email for reports (requires MTA like postfix)
if [ -n "${EMAIL_FOR_UPDATES}" ]; then
  sed -i "s|//Unattended-Upgrade::Mail \"\";|Unattended-Upgrade::Mail \"${EMAIL_FOR_UPDATES}\";|" /etc/apt/apt.conf.d/50unattended-upgrades || true
fi

systemctl enable --now unattended-upgrades
echo "Automatic security updates enabled."

# 3) Install and configure UFW (Uncomplicated Firewall)
echo "Installing and configuring UFW..."
apt -y install ufw

# reset to known state
ufw --force reset

# default policies
ufw default deny incoming
ufw default allow outgoing

# Allow SSH (before enabling firewall, to avoid locking yourself out)
if [ -n "${ADMIN_IP}" ]; then
  echo "Allowing SSH (port ${SSH_PORT}) only from ${ADMIN_IP}"
  ufw allow from ${ADMIN_IP} to any port ${SSH_PORT} proto tcp
else
  echo "Allowing SSH (port ${SSH_PORT}) from anywhere — change ADMIN_IP in script to restrict access."
  ufw allow ${SSH_PORT}/tcp
fi

# recommended common services (uncomment if you need them)
# ufw allow 80/tcp   # http
# ufw allow 443/tcp  # https

ufw logging on
ufw --force enable
echo "UFW is enabled and configured."

# 4) Install Fail2Ban and enable basic SSH protection
echo "Installing and configuring Fail2Ban..."
apt -y install fail2ban

# Drop default config to local for safe updates
mkdir -p /etc/fail2ban
cat > /etc/fail2ban/jail.local <<EOF
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
port = ${SSH_PORT}
logpath = /var/log/auth.log
EOF

systemctl enable --now fail2ban
echo "Fail2Ban installed and started."

# 5) Basic AppArmor status check (AppArmor is Ubuntu's local MAC)
echo "Checking AppArmor status..."
if command -v aa-status >/dev/null 2>&1; then
  aa-status || true
else
  echo "apparmor-utils not installed; installing..."
  apt -y install apparmor-utils
  aa-status || true
fi

# 6) Small housekeeping: remove old packages and auto-remove
echo "Cleaning up..."
apt -y autoremove
apt -y autoclean

echo "Hardening complete. Summary:"
echo "- unattended-upgrades: $(systemctl is-enabled unattended-upgrades 2>/dev/null || echo disabled)"
echo "- ufw status: $(ufw status verbose | sed -n '1,3p')"
echo "- fail2ban status: $(systemctl is-active fail2ban 2>/dev/null || echo inactive)"
echo "Tip: check /var/log/auth.log for SSH attempts and /var/log/fail2ban.log (if present)."

