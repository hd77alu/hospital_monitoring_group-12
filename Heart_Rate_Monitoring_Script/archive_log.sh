#!/bin/bash
mkdir -p archive
mv heart_rate_log.txt archive/heart_rate_log_$(date +"%Y%m%d_%H%M%S").txt
echo "Log archived."

