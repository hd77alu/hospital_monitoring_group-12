#!/usr/bin/env bash

# Original log file
log_file="heart_rate_log.txt"

# Check if the log file exists
if [ ! -f "$log_file" ]; then
    echo "Log file does not exist."
    exit 1
fi

# Get the current timestamp
timestamp=$(date +"%Y%m%d_%H%M%S")
new_log_file="${log_file}_${timestamp}"

# Archive the log file
mv "$log_file" "$new_log_file"
echo "Archived log file as: $new_log_file"
