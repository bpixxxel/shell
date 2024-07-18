#!/bin/bash

# Path to the authentication log
LOG_FILE="/var/log/auth.log"

# Output file to store results
OUTPUT_FILE="/var/log/ssh_monitor_report.txt"

# Current date and time
echo "Monitoring report generated on: $(date)" > $OUTPUT_FILE

# Search for failed SSH login attempts, extract relevant fields, and format the output
grep "Failed password" $LOG_FILE | awk '{print $1, $2, $3, $(NF-5), $(NF-3)}' | sed 's/invalid user //g' >> $OUTPUT_FILE

# Check if there are any failed attempts and send an email if there are
if [ -s $OUTPUT_FILE ]; then
    mail -s "Alert: Detected Failed SSH Login Attempts" admin@example.com < $OUTPUT_FILE
else
    echo "No failed SSH login attempts detected." >> $OUTPUT_FILE
fi
