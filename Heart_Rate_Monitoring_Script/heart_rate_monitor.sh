#!/bin/bash

# Prompt for device name
read -p "Enter device name (e.g., Monitor_A): " DEVICE_NAME

# Create or clear the log file
LOG_FILE="heart_rate_log.txt"
> $LOG_FILE

# Function to generate a random heart rate
generate_heart_rate() {
    echo $(( RANDOM % 100 + 40 ))  # Simulated heart rate between 40 and 139
}

# Infinite loop to log heart rates every second
while true; do
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    HEART_RATE=$(generate_heart_rate)
    echo "$TIMESTAMP $DEVICE_NAME $HEART_RATE" >> $LOG_FILE
    sleep 1
done &

# Output the process ID
echo "Heart rate monitoring started with PID: $!"

