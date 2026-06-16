#!/bin/bash
# Start a process that consumes 100% of a single CPU core in the background
# The 'yes' command outputs 'y' indefinitely, consuming CPU cycles
yes > /dev/null &
# Capture the Process ID (PID) of the background 'yes' command
YES_PID=$!
echo "Started 'yes' with PID $YES_PID"
# Use cpulimit to limit the 'yes' process to 10% CPU usage
# -p: specify the PID
# -l: set the CPU limit percentage
# -b: run cpulimit in the background (optional, but useful)
cpulimit -p $YES_PID -l 20 -b
echo "cpulimit is now managing PID $YES_PID at 10%"
echo "Script is running. To stop, use: killall yes"
# Keep the script running to allow cpulimit to work
wait $YES_PID

