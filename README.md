# Persistence Bash Script for Linux and OSX

### Linux
Script for Linux downloads an elf payload from external url and set cron persistence on reboot, then remove itself. It checks if script is launched as root or as user.

### OSX
Script for OSX downloads a Mach-O file from external url then making persistence downloading a plist and LaunchAgents from external url, lastly executes macho reverse shell.
