#!/bin/bash

# This script will setup the Raspberry Pi for use with a BU-353S4 Serial over
# USB GPS device.  The original idea was to use GPS time to update system time
# where no RTC is available.  The original credit goes to Peter Mount's Blog at
# http://http://blog.retep.org/2012/06/18/getting-gps-to-work-on-a-raspberry-pi/
# However, since Raspbian updated from Wheezy to Jessie, there have been
# issues.  The fixes come from the Raspberry Pi forums, curtosey of EricS
# who provides the advice to update /etc/default/gpsd in post 869964 at
# https://www.raspberrypi.org/forums/viewtopic.php?f=28&t=128028&p=869964

clear

echo "Installing gpsd, gpsd-clients, and python-gps."

sudo apt-get install -y gpsd                # Installs the GPS daemon
sudo apt-get install -y gpsd-clients	    # Installs more GPS stuff
sudo apt-get install -y python-gps          # Installs Python GPS libraries

echo "Now to get things working."

# This will overwrite the /etc/default/gpsd file to contain the following contents.

sudo printf '# Default settings for the gpsd init script and the hotplug wrapper.\n\n# Start the gpsd daemon automatically at boot time\nSTART_DAEMON="true"\n\n# Use USB hotplugging to add new USB devices automatically to the daemon\nUSBAUTO="false"\n\n# Devices gpsd should collect to at boot time.\n# They need to be read/writeable, either by user gpsd or the group dialout.\nDEVICES="/dev/ttyUSB0"\n\n# Other options you want to pass to gpsd\nGPSD_OPTIONS="n"\n\nGPSD_SOCET="/var/run/gpsd.sock' > /etc/default/gpsd
