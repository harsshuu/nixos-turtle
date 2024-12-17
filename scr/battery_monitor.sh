#!/bin/bash

while true; do
    # Get battery percentage using acpi
    BATTERY_LEVEL=$(acpi -b | grep -P -o '[0-9]+(?=%)')

    # Check if battery level is below 20%
    if [[ $BATTERY_LEVEL -le 20 ]]; then
        notify-send "Battery Low" "Your laptop's battery is below 20%. Please charge it." --urgency=critical
        # Wait for 5 minutes before checking again
        sleep 300
    fi
    # Check every minute
    sleep 60
done

