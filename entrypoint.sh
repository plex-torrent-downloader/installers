#!/bin/bash

# Start systemd
exec /sbin/init &
systemd_pid=$!

# Run your installer script
/app/installer.sh

# Wait for systemd to exit
wait $systemd_pid
