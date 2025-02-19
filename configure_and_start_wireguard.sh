#!/bin/bash -ex

function add_client() {  # first argument is the index of the client, second the server public IP
    # use printf to pad the index with zeros for the filenames
    local idx=$(printf "%03d" $1)

    # Generate client keys
    wg genkey | tee /etc/wireguard/client_${idx}_private.key | wg pubkey > /etc/wireguard/client_${idx}_public.key

    # Add client configuration to WireGuard configuration file
    cat <<EOF >> /etc/wireguard/wg0.conf
[Peer]
PublicKey = $(cat /etc/wireguard/client_${idx}_public.key)
AllowedIPs = 10.0.0.$1/32
EOF

    # Create a client configuration file
    cat <<EOF > /etc/wireguard/client_${idx}.conf
[Interface]
PrivateKey = $(cat /etc/wireguard/client_${idx}_private.key)
Address = 10.0.0.$1/24
DNS = 8.8.8.8

[Peer]
PublicKey = $(cat /etc/wireguard/server_public.key)
Endpoint = $2:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF

    # Generate a QR code of the client configuration file
    qrencode -t png -o /etc/wireguard/client_${idx}.png < /etc/wireguard/client_${idx}.conf
}

# Generate server keys
wg genkey | tee /etc/wireguard/server_private.key | wg pubkey > /etc/wireguard/server_public.key

# Get default interface name
default_if_name=$(ip route | grep '^default' | awk '{print $5}')
server_public_ip=$(curl -s https://checkip.amazonaws.com/)

# Create WireGuard configuration file
cat <<EOF > /etc/wireguard/wg0.conf
[Interface]
PrivateKey = $(cat /etc/wireguard/server_private.key)
Address = 10.0.0.0/24
ListenPort = 51820
PostUp = echo 1 > /proc/sys/net/ipv4/ip_forward; iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -s 10.0.0.1./24 -o $default_if_name -j MASQUERADE
PostDown = echo 0 > /proc/sys/net/ipv4/ip_forward; iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -s 10.0.0.1./24 -o $default_if_name -j MASQUERADE
EOF

# Enable IP forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# Create client configurations
for i in {1..255}
do
    add_client $i $server_public_ip
done

# Create a zip archive with all client configurations and QR codes
zip /etc/wireguard/clients.zip /etc/wireguard/client_*.conf /etc/wireguard/client_*.png
mv /etc/wireguard/clients.zip /home/ubuntu/clients.zip
chown ubuntu:ubuntu /home/ubuntu/clients.zip

# Enable and start WireGuard
systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0
