#!/bin/bash
#Create a directory /usr/lib/potd/
mkdir -p /usr/lib/potd/
#Creates an entry for potd.py in /usr/lib/potd/
cp ./potd.py /usr/lib/potd/
chmod a+x /usr/lib/potd/potd.py
cp ./potd.sh /usr/lib/potd/
chmod +x /usr/lib/potd/potd.sh
#Create the bonobo server file
cp ./potd.server /usr/lib/bonobo/servers/
#killall gnome-panel sadly the applet are not loaded correctly
echo "The applet will be loaded next time gdm restarts. Alternatively you can run 'sudo restart gdm' and login again";
