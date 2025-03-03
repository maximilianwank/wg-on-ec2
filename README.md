# :dragon: wg-on-ec2

Create a [WireGuard®](https://www.wireguard.com/) server with as few configuration steps as possible.

## :receipt: Short Description

The CloudFormation template in this repository will

1. Deploy an EC2 instance
2. Add security groups only opening two ports (for WireGuard® and SSH from a single IP)
3. Install WireGuard® and other small dependencies
4. Configure a WireGuard® server with suitable client configuration files

## :magic_wand: Deployment

As mentioned above, there is almost nothing to configure other than the source IP address and the certificate for SSH access.

1. If necessary: Create a key pair for EC2 in the AWS account you want to use.
2. Go to CloudFormation and upload the CloudFormation template `cloudformation.yaml`.
3. Specify the key and [your IP address](https://checkip.amazonaws.com/) for the SSH connection later.
4. Create the CloudFormation stack.
5. After a while there will be a zip archive on the EC2 instance at `/home/ubuntu/clients.zip` containing 255 client configurations (each as a file and a QR code). Use for example `scp` to download it.
6. Unpack the zip archive and distribute the client configurations.

## :point_up: Remarks

* Keep in mind that using this VPN does not make you anonymous when surfing the web. The IP address of the server is still exposed and can easily be linked to your AWS account (including payment information, the source IP for the deployment of the server, ...).
* The supported AWS regions are to be expanded step by step, the current list can be found in the [CloudFormation template](https://github.com/maximilianwank/wg-on-ec2/blob/main/cloudformation.yaml#L19).
* The lack of configuration options is considered a feature of this project - a more flexible approach can be found in the repositorty [wireguard-on-ec2](https://github.com/LINALIN1979/wireguard-on-ec2) by [LINALIN1979](https://github.com/LINALIN1979).
* It's generally a bad idea to pipe scripts from the internet directly to `bash`.

## :seedling: Feedback & Contributions

Any kind of feedback or contributions are welcome!
