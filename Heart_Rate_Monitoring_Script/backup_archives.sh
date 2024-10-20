#!/usr/bin/env bash

# Variables
group_number="group12" 
archive_dir="archived_logs_group$group_number"
username="fdb056dd42a9" 
host="fdb056dd42a9.6b7419f6.alu-cod.online" 
remote_dir="/home/"

# Create the archive directory if it doesn't exist
mkdir -p "$archive_dir"

# Move archived log files to the new directory
mv heart_rate_log.txt_* "$archive_dir/"
echo "Moved archived log files to: $archive_dir"

# Backup the contents to the remote server
scp -r "$archive_dir/" "$username@$host:$remote_dir"
if [ $? -eq 0 ]; then
    echo "Backup successful."
else
    echo "Backup failed."
fi
