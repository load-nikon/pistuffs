#!/bin/bash
# This script is to setup and enable the raspberry pi as an internet passthrough web server.
# It is based on the guide at https://realiesone.wordpress.com
# It is also my first real bash script.  Good luck!

clear						# clear terminal window. To be honest, I dislike this.

# echo "The script starts now."

# read -p "Press enter to continue."

echo "Updating package manager list and upgrading installed packages."

sudo apt-get update				# Update package manager list
sudo apt-get upgrade -y			# Upgrade system to latest versions of packages

# read -p "Press enter to continue."

clear

echo "Installing Lighttpd web server, and that php and lighty things."

sudo apt-get install -y lighttpd		# Installs the Lighttpd web server
sudo apt-get install -y php5-cgi		# Installs php (interpreter?)
sudo lighty-enable-mod fastcgi-php		# I think this is a command executed by php thing above

# read -p "Press enter to continue."

clear

echo "Installing hostapd."

sudo apt-get install -y hostapd		# This is the IEEE 802.11 authenticator.  This creates the hotspot and checks connecting devices passwords

# read -p "Press enter to continue."

clear

# Now to create the default configuration for hostapd.
# When you're ready to run this for real, change the value of the file being written to to /etc/hostapd/hostapd.conf

echo "Creating hostapd default configuration."
read -p "Please enter your desired BSSID: " bssid
read -p "Please enter your desired passphrase: " pass

sudo printf "ctrl_interface=/var/run/hostapd\nctrl_interface_group=0\n# Hardware Configuration\ninterface=wlan0\nssid=$bssid\nchannel=6\ndriver=nl80211\nieee80211n=1\nhw_mode=g\n# WPA and WPA2 Configuration\nwpa=3\nwpa_passphrase=$pass\nwpa_key_mgmt=WPA-PSK\nwpa_pairwise=TKIP\nrsn_pairwise=CCMP\nauth_algs=1\n" > /etc/hostapd/hostapd.conf

# read -p "Press enter to continue."

clear

# Now use SED to enable hostapd authenticator to run every time by uncommenting a line and adding a value.
# Again, the target file will be a test dummy until this script is ready for production.

echo "Editing /etc/default/hostapd to run as daemon on every boot."

sudo sed -i 's:#DAEMON_CONF="":DAEMON_CONF="/etc/hostapd/hostapd.conf":' /etc/default/hostapd

# read -p "Press enter to continue."

clear

# Install a DHCP server, move it's default configuration file and make our own.

echo "Installing dhcp server, moving default config file, and writing new."

sudo apt-get install -y isc-dhcp-server
sudo mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.original

# read -p "Press enter to continue."

clear

echo "Creating /etc/dhcp/dhcpd.conf and populating."

sudo printf "ddns-update-style none;\ndefault-lease-time 600;\nmax-lease-time 7200;\nauthoritative;\nsubnet 10.10.0.0 netmask 255.255.255.0 {\n range 10.10.0.2 10.10.0.16;\n option domain-name-servers 8.8.8.8, 8.8.4.4;\n option routers 10.10.0.1;\n interface wlan0;\n}" > /etc/dhcp/dhcpd.conf

# read -p "Press enter to continue."

clear

# Enable packet forwarding between wlan1 and wlan0 and eth0.

echo "Enabling packet forwarding from wlan1 to wlan0 or eth0 and vise-versa."

sudo sysctl -w net.ipv4.ip_forward=1
sudo sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o wlan1 -j MASQUERADE
sudo bash -c "iptables-save > /etc/iptables.rules"

# read -p "Press enter to continue."

clear

# This configures /etc/network/interfaces by re-writing but keeping important stuffs from original file.
# sed would be better for this but I don't know sed well enough to not eff this up.

echo "Writing /etc/network/interfaces."

sudo printf "# interfaces(5) file used by ifup(8) and ifdown(8)\n\n# Please note that this file is written to be used with dhcpcd\n# For static IP, consult /etc/dhcpcd.conf and 'man dhcpcd.conf'\n\n# Include files from /etc/network/interfaces.d:\nsource-directory /etc/network/interfaces.d\n\nauto lo\niface lo inet loopback\n\niface eth0 inet dhcp\n\nauto wlan0\nallow-hotplug wlan0\niface wlan0 inet static\n  address 10.10.0.1\n  netmask 255.255.255.0\n  pre-up ifconfig wlan0 10.10.0.1\n  pre-up iptables-restore < /etc/iptables.rules\n\nauto wlan1\nallow-hotplug wlan1\niface wlan1 inet dhcp\n    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf" > /etc/network/interfaces

# read -p "Press enter to continue."

clear

echo "Good luck, now reboot and check available APs!"
