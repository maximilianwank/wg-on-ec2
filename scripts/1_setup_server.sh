#!/bin/bash -ex

# Generate server keys
wg genkey | tee /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey

# Create WireGuard configuration file
cat <<EOF > /etc/wireguard/wg0.conf
[Interface]
PrivateKey = $(cat /etc/wireguard/privatekey)
Address = 10.0.0.1/24
ListenPort = 51820

[Peer]
PublicKey = $(cat /etc/wireguard/publickey)
AllowedIPs = 10.0.0.2/32
EOF

# Enable IP forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# Start and enable WireGuard
systemctl enable wg-quick@wg0
