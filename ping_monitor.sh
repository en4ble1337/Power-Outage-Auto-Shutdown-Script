#!/bin/bash

# ping_monitor.sh
# Script to monitor connectivity to 1.1.1.1 and shutdown if 5 consecutive failures occur
# To be placed in /usr/local/bin/

# Log file locations
LOG_FILE="/var/log/ping_monitor.log"
COUNTER_FILE="/var/log/ping_monitor_counter"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Create log file if it doesn't exist
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
    log_message "Log file created"
fi

# Check if counter file exists, create if not
if [ ! -f "$COUNTER_FILE" ]; then
    echo "0" > "$COUNTER_FILE"
    log_message "Counter file created and initialized to 0"
fi

# Ping test function
ping_test() {
    ping -c 1 -W 5 1.1.1.1 > /dev/null 2>&1
    return $?
}

# Read current failure counter
FAILURES=$(cat "$COUNTER_FILE")

# Perform ping test and update counter
if ping_test; then
    # Ping successful
    if [ "$FAILURES" -gt 0 ]; then
        log_message "Ping successful - Resetting failure counter from $FAILURES to 0"
    fi
    echo "0" > "$COUNTER_FILE"
else
    # Ping failed
    FAILURES=$((FAILURES + 1))
    echo "$FAILURES" > "$COUNTER_FILE"
    log_message "Ping failed - Failure count: $FAILURES"
    
    # If 5 consecutive failures, shutdown the system
    if [ "$FAILURES" -ge 5 ]; then
        log_message "CRITICAL: 5 consecutive ping failures detected. Initiating graceful shutdown..."
        # Send a notification to all logged-in users
        wall "SYSTEM ALERT: Network connectivity to 1.1.1.1 lost for 5 consecutive minutes. System will be shut down in 60 seconds."
        # Sleep for 60 seconds to allow users to save their work
        sleep 60
        log_message "Executing shutdown command"
        # Execute shutdown
        /sbin/shutdown -h now "Network connectivity lost - automatic shutdown triggered"
    fi
fi
