#!/bin/sh

# Function to get the current status with icons
get_status() {
    # Get date and time
    datetime=$(date +"%a, %d %b | %H:%M")

    # Define the username
    username="turtle"

    # Combine centered part (date | time | username)
    center_text="$datetime | $username"

    # Get battery percentage
    battery=$(acpi | grep -o '[0-9]*%' | head -n 1)
    battery_icon="🔋"  # Battery icon

    # Get volume level
    volume=$(amixer get Master | grep -o '[0-9]*%' | head -n 1)
    volume_icon="🔊"  # Volume icon

    # Get connected Wi-Fi SSID
    wifi=$(iwgetid -r)
    wifi_icon="📶"  # Wi-Fi icon

    # Combine all into one status string
    right_side="$battery_icon $battery | $volume_icon $volume | $wifi_icon $wifi"

    # Calculate the padding for centering
    padding="                                    "  # Adjust the number of spaces based on your screen size
    padded_status="$padding$center_text$padding"

    # Return the full status: padded center + right side
    echo "$padded_status | $right_side"
}

# Update the status every second
while true; do
    # Call the get_status function and set the root window name
    xsetroot -name "$(get_status)"
    sleep 1
done

