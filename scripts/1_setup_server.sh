#!/bin/bash -ex

# Generate server keys
wg genkey | tee /etc/wireguard/server_private.key | wg pubkey > /etc/wireguard/server_public.key
wg genkey | tee /etc/wireguard/client1_private.key | wg pubkey > /etc/wireguard/client1_public.key
wg genkey | tee /etc/wireguard/client2_private.key | wg pubkey > /etc/wireguard/client2_public.key

# Create WireGuard configuration file
cat <<EOF > /etc/wireguard/wg0.conf
[Interface]
PrivateKey = $(cat /etc/wireguard/server_private.key)
Address = 10.0.0.1/24
ListenPort = 51820

[Peer]
PublicKey = $(cat /etc/wireguard/client1_public.key)
AllowedIPs = 10.0.0.2/32

[Peer]
PublicKey = $(cat /etc/wireguard/client2_public.key)
AllowedIPs = 10.0.0.3/32
EOF

# Enable IP forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# sleep 10 second
sleep 10

# Start and enable WireGuard
# systemctl enable wg-quick@wg0
