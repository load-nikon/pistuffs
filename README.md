# pistuffs
Things for my raspberry pi
I will use this readme as a guide to what I'm trying to accomplish with my Raspberry Pi.

# ap.sh

I have added the ap.sh bash script to this repo.  Credit goes to the Realies website at https://realiesone.wordpress.com/2015/03/11/the-raspberry-pi-as-an-internet-pass-through-web-server-using-two-wireless-adapters/.  This will, upon running with sudo, create a working access point with passthrough from wlan1 to wlan0 and eth0, set up a web-server with lighttpd, and configure the AP, DHCP, and hostapd.  It will run after a reboot.

Note, this version uses the nl80211 driver for use with the Ralink 3070 chipset found in the Alfa AWUS036NH wireless adapter.  At some point in the future, I will include support for the RTL8188CUS chipset commonly found in Edimax adapters.


# gps.sh

This script will setup the Raspberry Pi for use with a BU-353S4 Serial over
USB GPS device.  The original idea was to use GPS time to update system time
where no RTC is available.  The original credit goes to Peter Mount's Blog at
http://http://blog.retep.org/2012/06/18/getting-gps-to-work-on-a-raspberry-pi/
However, since Raspbian updated from Wheezy to Jessie, there have been
issues.  The fixes come from the Raspberry Pi forums, curtosey of EricS
who provides the advice to update /etc/default/gpsd in post 869964 at
https://www.raspberrypi.org/forums/viewtopic.php?f=28&t=128028&p=869964
