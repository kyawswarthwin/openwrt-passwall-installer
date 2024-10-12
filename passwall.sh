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

# Add feeds to customfeeds.conf
echo "Adding Passwall feeds to customfeeds.conf..."
for feed in passwall_luci passwall_packages passwall2; do
    echo "Adding feed: $feed"
    echo "src/gz $feed $base_url/$feed" >> /etc/opkg/customfeeds.conf
done
echo "All feeds added successfully."

# Update package lists
echo "Updating package lists..."
if opkg update; then
    echo "Package lists updated successfully."
else
    echo "Error: Failed to update package lists."
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

echo "Installation completed successfully!"
