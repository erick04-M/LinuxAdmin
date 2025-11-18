#!/bin/bash
# CentOS 10 Security Hardening Script
# Run as root: sudo bash security_hardening.sh

set -e

echo "=== CentOS 10 Security Hardening ==="
echo "Starting security hardening process..."

# Update system
echo "[1/8] Updating system packages..."
dnf update -y

# Configure firewall
echo "[2/8] Configuring firewall..."
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --set-default-zone=public
firewall-cmd --permanent --add-service=ssh
firewall-cmd --reload

# SSH hardening
echo "[3/8] Hardening SSH configuration..."
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/X11Forwarding yes/X11Forwarding no/' /etc/ssh/sshd_config
echo "MaxAuthTries 3" >> /etc/ssh/sshd_config
echo "ClientAliveInterval 300" >> /etc/ssh/sshd_config
echo "ClientAliveCountMax 2" >> /etc/ssh/sshd_config
systemctl restart sshd

# Install and configure fail2ban
echo "[4/8] Installing and configuring fail2ban..."
dnf install -y epel-release
dnf install -y fail2ban
systemctl start fail2ban
systemctl enable fail2ban

cat > /etc/fail2ban/jail.local <<EOF
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
port = ssh
logpath = /var/log/secure
EOF

systemctl restart fail2ban

# Disable unused services
echo "[5/8] Disabling unnecessary services..."
for service in avahi-daemon cups bluetooth; do
    systemctl stop $service 2>/dev/null || true
    systemctl disable $service 2>/dev/null || true
done

# Set secure file permissions
echo "[6/8] Setting secure file permissions..."
chmod 644 /etc/passwd
chmod 600 /etc/shadow
chmod 644 /etc/group
chmod 600 /etc/gshadow

# Configure automatic security updates
echo "[7/8] Configuring automatic security updates..."
dnf install -y dnf-automatic
sed -i 's/apply_updates = no/apply_updates = yes/' /etc/dnf/automatic.conf
systemctl enable --now dnf-automatic.timer

# Enable SELinux
echo "[8/8] Ensuring SELinux is enforcing..."
setenforce 1
sed -i 's/SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config

echo ""
echo "=== Security Hardening Complete ==="
echo "Summary of changes:"
echo "✓ System updated"
echo "✓ Firewall configured and enabled"
echo "✓ SSH hardened (root login disabled)"
echo "✓ Fail2ban installed and configured"
echo "✓ Unnecessary services disabled"
echo "✓ File permissions secured"
echo "✓ Automatic security updates enabled"
echo "✓ SELinux enforcing mode enabled"
echo ""
echo "IMPORTANT: Test SSH access before closing this session!"
echo "Backup config saved: /etc/ssh/sshd_config.backup"