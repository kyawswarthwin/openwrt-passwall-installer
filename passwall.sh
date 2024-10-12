#!/bin/sh

# Prompt user for Passwall version selection
echo "Select the Passwall version to install:"
echo "1) Passwall 1"
echo "2) Passwall 2 (Requires at least 256 MB RAM)"
read -p "Enter your choice (1 or 2): " choice

# Validate user input
case "$choice" in
    1|2) ;;
    *) 
        echo "Error: Invalid choice. Please select either 1 or 2."
        exit 1 
        ;;
esac

# Download and add the Passwall public key
echo "Downloading the Passwall public key..."
if ! wget -O passwall.pub https://master.dl.sourceforge.net/project/openwrt-passwall-build/passwall.pub; then
    echo "Error: Unable to download the Passwall public key."
    exit 1
fi
opkg-key add passwall.pub
echo "Passwall public key added successfully."

# Load OpenWrt version and architecture
echo "Loading OpenWrt version and architecture information..."
. /etc/openwrt_release

# Determine the architecture based on OpenWrt version
if echo "$DISTRIB_RELEASE" | grep -q "SNAPSHOT"; then
    arch="$DISTRIB_ARCH"
    base_url="https://master.dl.sourceforge.net/project/openwrt-passwall-build/snapshots/packages/$arch"
    echo "Detected SNAPSHOT version. Using architecture: $arch."
else
    release="${DISTRIB_RELEASE%.*}"
    arch="$DISTRIB_ARCH"
    base_url="https://master.dl.sourceforge.net/project/openwrt-passwall-build/releases/packages-$release/$arch"
    echo "Detected stable version $DISTRIB_RELEASE. Using architecture: $arch."
fi

# Add feeds to customfeeds.conf if they are not already present
echo "Adding Passwall feeds to customfeeds.conf..."
for feed in passwall_luci passwall_packages passwall2; do
    if ! grep -q "^src/gz $feed" /etc/opkg/customfeeds.conf; then
        echo "Adding feed: $feed"
        echo "src/gz $feed $base_url/$feed" >> /etc/opkg/customfeeds.conf
    else
        echo "Feed $feed already exists in customfeeds.conf, skipping."
    fi
done
echo "All feeds checked and added successfully."

# Update package lists
echo "Updating package lists..."
if opkg update; then
    echo "Package lists updated successfully."
else
    echo "Error: Failed to update package lists."
    exit 1
fi

# Remove dnsmasq and install dnsmasq-full
echo "Removing dnsmasq and installing dnsmasq-full..."
if opkg remove dnsmasq && opkg install dnsmasq-full; then
    echo "dnsmasq replaced with dnsmasq-full successfully."
else
    echo "Error: Failed to install dnsmasq-full."
    exit 1
fi

# Install required kernel modules
echo "Installing required kernel modules..."
if opkg install kmod-nft-socket && opkg install kmod-nft-tproxy; then
    echo "Kernel modules installed successfully!"
else
    echo "Error: Failed to install kernel modules."
    exit 1
fi

# Install the chosen version
if [ "$choice" = "1" ]; then
    echo "Installing Passwall 1..."
    if opkg install luci-app-passwall; then
        echo "Passwall 1 installed successfully!"
    else
        echo "Error: Failed to install Passwall 1."
        exit 1
    fi
else
    echo "Installing Passwall 2..."
    if opkg install luci-app-passwall2; then
        echo "Passwall 2 installed successfully!"
    else
        echo "Error: Failed to install Passwall 2."
        exit 1
    fi
fi
