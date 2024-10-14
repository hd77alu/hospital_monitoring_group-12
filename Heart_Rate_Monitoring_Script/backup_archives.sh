#!/bin/bash
tar -czf backup_$(date +"%Y%m%d").tar.gz archive/
echo "Backup created."

