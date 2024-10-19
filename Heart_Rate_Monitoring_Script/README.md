# Task 1 A

#!/usr/bin/env bash

# heart_rate_monitor.sh

# Function to generate random heart rate
generate_heart_rate() {
  # This function simulates a random heart rate between 40 and 139.
  # It uses `$RANDOM`, which generates a random number, and `% 100 + 40` ensures the value is within the specified range.
  echo $(( RANDOM % 100 + 40 ))
}

# Prompt for device name
# The `read -p` command prompts the user to input the device name (e.g., Monitor_A).
# The value entered by the user is stored in the variable `device_name`.
read -p "Enter the device name (e.g., Monitor_A): " device_name

# Log file
# The variable `log_file` holds the name of the file where heart rate data will be logged.
log_file="heart_rate_log.txt"

# Function to log heart rate data
log_heart_rate() {
  # This function logs the heart rate along with a timestamp and the device name.
  # The `while true` loop ensures continuous logging until the process is terminated.
  while true; do
    # `date +"%Y-%m-%d %H:%M:%S"` gets the current timestamp in a specific format.
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    
    # `generate_heart_rate` calls the function to get a simulated heart rate value.
    heart_rate=$(generate_heart_rate)
    
    # The log is written to the file in the format: timestamp, device name, and heart rate.
    echo "$timestamp $device_name $heart_rate" >> "$log_file"
    
    # The `sleep 1` command pauses the loop for 1 second between heart rate readings.
    sleep 1
  done
}

# Start logging in the background
# The `log_heart_rate &` starts the heart rate logging function as a background process.
log_heart_rate &

# The `pid=$!` command stores the Process ID (PID) of the background task.
pid=$!

# Output the process ID
# This command displays the PID of the background process, allowing the user to monitor or stop the process later if needed.
echo "Heart rate monitor started with PID: $pid"


# Task 1 B: Heart Rate Monitoring Script

# First, we check if the log file 'heart_rate_log.txt' exists.
# If it's not found, we display an error message and exit the script.
log_file="heart_rate_log.txt"
if [[ ! -f "$log_file" ]]; then
  echo "Log file not found: $log_file"
  exit 1
fi

# Now, we initialize some variables to calculate the total, average, max, and min heart rates:
# - 'total_heart_rate' keeps track of the sum of all heart rate readings.
# - 'count' stores how many readings we've processed.
# - 'max_heart_rate' will store the highest heart rate we've encountered.
# - 'min_heart_rate' is initially set to a very high number so that any real value will be lower.
total_heart_rate=0
count=0
max_heart_rate=0
min_heart_rate=1000  # Setting a high initial value to capture the real minimum heart rate.

# We then read the log file line by line.
# For each line, we extract the heart rate (we're assuming it's the 12th column in the file).
# The heart rate is added to the 'total_heart_rate', and we increase the count of readings.
while IFS= read -r line; do
  heart_rate=$(echo "$line" | awk '{print $12}')  # Extract heart rate from the log

  # Check if heart_rate is a number before performing arithmetic
  if [[ "$heart_rate" =~ ^[0-9]+$ ]]; then
      total_heart_rate=$((total_heart_rate + heart_rate))  # Add heart rate to total
      count=$((count + 1))  # Increase the count of readings

      # Now we check if the current heart rate is the highest we've seen so far (max).
      # If it is, we update 'max_heart_rate'.
      if (( heart_rate > max_heart_rate )); then 
          max_heart_rate=$heart_rate; 
      fi

      # Similarly, if the current heart rate is the lowest, we update 'min_heart_rate'.
      if (( heart_rate < min_heart_rate )); then 
          min_heart_rate=$heart_rate; 
      fi
  fi
done < "$log_file"

# After processing all the lines, we calculate the average heart rate.
# If we have readings, we calculate the average using 'bc' to handle floating point division.
if (( count > 0 )); then
  average_heart_rate=$(echo "scale=2; $total_heart_rate / $count" | bc)  # Calculate the average
else
  echo "No heart rate data available."
  exit 1
fi

# Finally, we print out the results of our analysis:
# - Total number of readings
# - Average heart rate
# - Maximum heart rate
# - Minimum heart rate

echo "Heart Rate Analysis:"
echo "Total Readings: $count"
echo "Average Heart Rate: $average_heart_rate bpm"
echo "Max Heart Rate: $max_heart_rate bpm"
echo "Min Heart Rate: $min_heart_rate bpm"


# Task 2

# First, we created a new directory called "archive" to store our logs.

# The '-p' flag ensures the directory is only created if it doesn't already exist.

mkdir -p archive

# Next, we moved the heart_rate_log.txt file into the "archive" directory.

# We renamed the file to include the current timestamp in the format YYYYMMDD_HHMMSS.

mv heart_rate_log.txt archive/heart_rate_log_$(date +"%Y%m%d_%H%M%S").txt

# Now, we made all the shell script files in this directory executable so they can be run.
chmod +x *.sh

# We then executed the heart rate monitor script to start tracking heart rate data.
./heart_rate_monitor.sh

# To watch the recorded heart rate data in real-time, we used 'tail' on the log file.
# We exited the real-time view by pressing 'CTRL + Z'.

tail -f heart_rate_log.txt  # Exit with CTRL + Z

# Finally, we ran the 'archive_log.sh' script to archive the log files.
./archive_log.sh

# At this point, the log file has been moved to the "archive" directory, and it now includes a timestamp in its name.



# Task 3

#!/bin/bash  # It tells the system which interpreter to use to run the script.

# Define variables

# We created variables that will store values used throughout the script.

# - 'group_number' stores the assigned group number.

# - 'archive_dir' stores the name of the directory for archived logs, incorporating the group number dynamically.

# - 'host' is the remote server hostname or IP address.

# - 'username' is the username for accessing the remote server.

# - 'remote_dir' is the destination directory on the remote server where the files will be backed up.

group_number=12
archive_dir="archived_logs_group$group_number"
host="fdb056dd42a9.6b7419f6.alu-cod.online"
username="fdb056dd42a9"
remote_dir="/home/"

# Create the archive directory if it doesn't exist
# The 'mkdir -p' command is used to create the directory specified by 'archive_dir'.
# The '-p' option ensures that no error is thrown if the directory already exists.
mkdir -p $archive_dir

# Move archived log files
# The 'mv' command moves all log files with the naming pattern 'heart_rate_log.txt_*' 
# into the directory specified by 'archive_dir'. This helps organize archived logs in a single place.

mv heart_rate_log.txt_* $archive_dir/
echo "Moved archived logs to $archive_dir."

# Backup to remote server

# The 'scp -r' command securely copies the entire contents of 'archive_dir' to a remote server.

# '-r' ensures that the entire directory is copied recursively.

# The connection uses SSH for secure file transfer, and files are placed into the 'remote_dir' on the remote server.

scp -r $archive_dir/* $username@$host:$remote_dir
echo "Backup to remote server completed."


# Team Attendance
# Team Members:

Deng Mayen Deng Akol 1: Present
Sonia Etuhoko wisdom 2: Present
Christopher Dushimimana 3: Present
Hamed Alfatih Hamed Abd Algader 4: Present
Rwigenza Niyoyandemye Davy 5: Present
RICHARD IRIHO              6: Present
