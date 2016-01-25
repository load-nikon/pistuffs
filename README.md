# pistuffs
Things for my raspi
I will use this readme as a guide to what I'm trying to accomplish with my Raspberry Pi.

# realies.sh

I have added the realies.sh bash script to this repo.  Credit goes to the Realies website at https://realiesone.wordpress.com/2015/03/11/the-raspberry-pi-as-an-internet-pass-through-web-server-using-two-wireless-adapters/.  This will, upon running with sudo, create a working access point with passthrough from wlan1 to wlan0 and eth0, set up a web-server with lighttpd, and configure the AP, DHCP, and hostapd.  It will run after a reboot.

Note, this version uses the nl80211 driver for use with the Ralink 3070 chipset found in the Alfa AWUS036NH wireless adapter.  At some point in the future, I will include support for the RTL8188CUS chipset commonly found in Edimax adapters.

Considerations for future:
 * Upon learning more bash scripting and most importantly, prompting the user, this script should be updated so that the user may decide variables like drivers, SSID, and password.
 * Learn to take better notes.

# GPS

This will allow use of a BU-353-S4 GPS antenna.
