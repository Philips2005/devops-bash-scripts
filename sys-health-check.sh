#!/bin/bash


##################
#Author: PHILIPS
#Date: 14/07/2025
# A simple system health check script
# Checks CPU, Memory, Disk usage and Network connectivity
####################

# Error handling function
error_exit(){
    echo "$1" 1>&2
    exit 1
}

# Thresholds
CPU_THRESHOLD=70
MEM_THRESHOLD=70
DISK_THRESHOLD=70
LATENCY_THRESHOLD=100

# Usage checks for system parameters
CPU_USAGE=$(top -bn1 | grep -i "cpu(s)" | awk '{print $8}' | cut -d. -f1) || error_exit "Failed to get CPU usage"
MEM_USAGE=$(free | grep -i "mem" | awk '{print $3/$2 * 100.0}' | cut -d. -f1) || error_exit "Failed to get Memory usage"
DISK_USAGE=$(df / | grep -v Filesystem | awk '{print $3/$2 * 100.0}' | cut -d. -f1) || error_exit "Failed to get Disk usage"
LATENCY=$(ping -c 1 google.com | grep 'time=' | awk -F'time=' '{print $2}' | awk -F'ms' '{print $1}' || error_exit "Failed to get Network latency")


# Display current system health status
echo "welcome user..."
echo "***************************"
echo "current system health status" || error_exit "Failed to display status"
echo "--"
echo " cpu usage: $CPU_USAGE%" || error_exit "Failed to display CPU usage"
echo "--"
echo " memory usage: $MEM_USAGE%" || error_exit "Failed to display Memory usage"
echo "--"
echo " disk usage: $DISK_USAGE%" || error_exit "Failed to display Disk usage"
echo "--"
echo " network latency: $LATENCY ms" || error_exit "Failed to display Network latency"
echo "***************************"


# Threshold checks for system parameters
if [ "$CPU_USAGE" -ge "$CPU_THRESHOLD" ]; then
    echo "Checking against threshold standards..." || error_exit "Failed to check CPU threshold"
    echo "--loading--" || error_exit "Failed to display loading message"
      sleep 3
    echo "Warning: High CPU usage detected! ($CPU_USAGE%)" || error_exit "Failed to display CPU warning"
else
    echo "CPU usage is within acceptable limits." || error_exit "Failed to display CPU status"
fi 

if [ "$MEM_USAGE" -ge "$MEM_THRESHOLD" ]; then
    echo "Checking against threshold standards..." || error_exit "Failed to check Memory threshold"
    echo "--loading--" || error_exit "Failed to display loading message"
      sleep 3
    echo "Warning: High Memory usage detected! ($MEM_USAGE%)" || error_exit "Failed to display Memory warning"
else
    echo "Memory usage is within acceptable limits." || error_exit "Failed to display Memory status"
fi

if [ "$DISK_USAGE" -ge "$DISK_THRESHOLD" ]; then
    echo "Checking against threshold standards..." || error_exit "Failed to check Disk threshold"
    echo "--loading--" || error_exit "Failed to display loading message"
      sleep 3
    echo "Warning: High Disk usage detected! ($DISK_USAGE%)" || error_exit "Failed to display Disk warning"
else
    echo "Disk usage is within acceptable limits." || error_exit "Failed to display Disk status"
fi

if [ "$LATENCY" -ge "$LATENCY_THRESHOLD" ]; then
    echo "Checking against threshold standards..." || error_exit "Failed to check Latency threshold"
    echo "--loading--" || error_exit "Failed to display loading message"
      sleep 3
    echo "Warning: High Network latency detected! ($LATENCY ms)" || error_exit "Failed to display Latency warning"
else
    echo "Network latency is within acceptable limits." || error_exit "Failed to display Latency status"
fi

echo "-----------------------------"
echo "System health check completed." || error_exit "Failed to complete health check"
