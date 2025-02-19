# wg-on-ec2

The CloudFormation template in this repository

1. Deploys an EC2 instance
2. Adds security groups only opening two ports (for SSH with IP whitelist and WireGuard)
3. Installs WireGuard
4. Configures a WireGuard server with suitable client configuration files
