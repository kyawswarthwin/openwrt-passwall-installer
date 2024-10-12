
# OpenWrt Passwall Installer

This repository provides a shell script to easily install **Passwall** (either Passwall 1 or Passwall 2) on OpenWrt-based routers. The script automatically downloads the necessary keys, adds custom feeds, updates package lists, and installs the selected Passwall version.

## Features

- Choose between **Passwall 1** or **Passwall 2**.
- Automatically detects your OpenWrt version and architecture.
- Adds appropriate custom feeds based on your system's architecture and version.
- Automatically updates the package lists.
- Installs the chosen version of Passwall.

## Prerequisites

- OpenWrt installed on your router.
- Access to your router via SSH.
- At least 256 MB of RAM if you choose Passwall 2.

## Installation

1. SSH into your OpenWrt router.

2. Download the script directly:

   ```sh
   wget https://raw.githubusercontent.com/kyawswarthwin/openwrt-passwall-installer/main/passwall.sh
   ```

3. Make the script executable:

   ```sh
   chmod +x passwall.sh
   ```

4. Run the script:

   ```sh
   ./passwall.sh
   ```

5. Follow the on-screen instructions to select the version of Passwall to install.

## Usage

The script will guide you through selecting the version of Passwall to install. You can choose between:

- **Passwall 1** for basic installations.
- **Passwall 2**, which requires at least 256 MB of RAM.

The script will:

- Download and add the Passwall public key.
- Detect your OpenWrt version and architecture.
- Add the necessary Passwall feeds.
- Update the package lists.
- Install the chosen version of Passwall.

## Troubleshooting

If the script encounters any issues, you will see an error message. Common errors include:

- Failure to download the public key.
- Problems with updating the package lists.
- Installation errors due to insufficient system resources.

Ensure your router meets the RAM requirement for Passwall 2 and that you have internet access during the installation.

## License

This project is licensed under the MIT License.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue for any improvements or bug fixes.
