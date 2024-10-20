#!/usr/bin/bash env
tar -czf backup_$(date +"%Y%m%d").tar.gz archive/
echo "Backup created."

