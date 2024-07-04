#!/bin/bash

# Check for nmap
if ! command -v nmap &> /dev/null
then
    echo "nmap could not be found, please install it."
    exit
fi

TARGET_IP=$1
PORT_RANGE=$2

if [ -z "$TARGET_IP" ] || [ -z "$PORT_RANGE" ]; then
    echo "Usage: ./advanced_scan.sh <target-ip> <port-range>"
    exit 1
fi

perform_scan() {
    echo "Performing $1 Scan..."
    nmap $2 $TARGET_IP -p $PORT_RANGE -oN "$1_Scan_Result.txt"
    if [ $? -eq 0 ]; then
        echo "$1 Scan completed successfully."
    else
        echo "$1 Scan failed."
    fi
}

# Sequential scanning with delay for rate limiting
perform_scan "TCP Connect" "-sT --min-rate 10"
sleep 10
perform_scan "TCP SYN" "-sS --min-rate 10"
sleep 10
perform_scan "ACK" "-sA --min-rate 10"
sleep 10
perform_scan "Xmas" "-sX --min-rate 10"

echo "All scans completed. Check the output files for results."
