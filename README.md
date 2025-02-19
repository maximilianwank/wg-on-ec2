# wg-on-ec2

The CloudFormation template in this repository will

1. Deploy an EC2 instance
2. Add security groups only opening two ports (for SSH with IP whitelist and WireGuard)
3. Install WireGuard and small other dependencies
4. Configure a WireGuard server with suitable client configuration files

## Remarks

* The lack of configuration options is considered a feature of this project - a more flexible approach can be found in the repositorty [wireguard-on-ec2](https://github.com/LINALIN1979/wireguard-on-ec2) by [LINALIN1979](https://github.com/LINALIN1979).
* It's generally a bad idea to pipe scripts from the internet directly to `bash`.

## Feedback & Contributions

Any kind of feedback or contributions are welcome!
