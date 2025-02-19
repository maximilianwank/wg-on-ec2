# wg-on-ec2

The CloudFormation template in this repository

1. Deploys an EC2 instance
2. Adds security groups only opening two ports (for SSH with IP whitelist and WireGuard)
3. Installs WireGuard
4. Configures a WireGuard server with suitable client configuration files

A more flexible approach can be found in the repositorty [wireguard-on-ec2](https://github.com/LINALIN1979/wireguard-on-ec2) by [LINALIN1979](https://github.com/LINALIN1979).
