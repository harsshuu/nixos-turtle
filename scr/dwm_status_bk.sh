#!/bin/sh

# Function to get the current status with icons
get_status() {
    # Get date and time
    datetime=$(date +"%d %b | %H:%M")

    # Get battery percentage
    battery=$(acpi | grep -o '[0-9]*%' | head -n 1)
    battery_icon="🔋"  # Battery icon

    # Get volume level
    volume=$(amixer get Master | grep -o '[0-9]*%' | head -n 1)
    volume_icon="🔊"  # Volume icon

    # Get connected Wi-Fi SSID
    wifi=$(iwgetid -r)
    wifi_icon="📶"  # Wi-Fi icon

    # Combine all into one status string with separators
    echo "$datetime | $battery_icon $battery | $volume_icon $volume | $wifi_icon $wifi"
}

# Update the status every second
while true; do
    # Call the get_status function and set the root window name
    xsetroot -name "$(get_status)"
    sleep 1
done 


