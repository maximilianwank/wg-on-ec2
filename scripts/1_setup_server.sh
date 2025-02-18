#!/bin/bash -ex

# Generate server keys
wg genkey | tee /etc/wireguard/server_private.key | wg pubkey > /etc/wireguard/server_public.key
wg genkey | tee /etc/wireguard/client1_private.key | wg pubkey > /etc/wireguard/client1_public.key
wg genkey | tee /etc/wireguard/client2_private.key | wg pubkey > /etc/wireguard/client2_public.key

# Get default interface name
default_if_name=$(ip route | grep '^default' | awk '{print $5}')

# Create WireGuard configuration file
cat <<EOF > /etc/wireguard/wg0.conf
[Interface]
PrivateKey = $(cat /etc/wireguard/server_private.key)
Address = 10.0.0.1/24
ListenPort = 51820
PostUp = echo 1 > /proc/sys/net/ipv4/ip_forward; iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -s 10.0.0.1./24 -o $default_if_name -j MASQUERADE
PostDown = echo 0 > /proc/sys/net/ipv4/ip_forward; iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -s 10.0.0.1./24 -o $default_if_name -j MASQUERADE

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
