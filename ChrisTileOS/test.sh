#!/bin/bash

main_menu=$(echo -e "Connect to a Wifi Network\nEnable Or Disable Wifi\nForget a Wifi Network" | rofi -dmenu -p "WiFi Manager: What would you like to do?")

if [[ $main_menu = "Connect to a Wifi Network" ]]; then
    # List all available Wi-Fi networks and mark the active one
    wifi_list=$(nmcli --fields SSID,ACTIVE device wifi list | sed '/^$/d' | grep -v -e '^--' -e '^SSID' | awk -F'  +' '{if ($2 == "yes") print $1 " (active)"; else print $1}' | sort -u)
    wifi_ssid=$(echo "$wifi_list" | rofi -dmenu -p "WiFi Manager: Choose a Wifi Network")

    if [[ ! -z $wifi_ssid ]]; then
        # Remove "(active)" marker if present
        wifi_ssid=$(echo $wifi_ssid | sed 's/ (active)//')

        # List all saved Wi-Fi connections
        saved_connections=$(nmcli -f NAME,TYPE connection show | grep wifi | awk '{$NF=""; sub(/[ \t]+$/, ""); print}' | sort -u)

        # Check if the selected Wi-Fi network is already a saved connection
        is_saved=$(echo "$saved_connections" | grep -F "$wifi_ssid")

        if [[ -n $is_saved ]]; then
            # Connect to the saved Wi-Fi network without asking for password
            nmcli connection up "$wifi_ssid"
        else
            # Prompt for password and connect to the selected Wi-Fi network
            password=$(rofi -dmenu -password -p "WiFi Manager: Enter password for $wifi_ssid")
            nmcli device wifi connect "$wifi_ssid" password "$password"
        fi
    fi

elif [[ $main_menu = "Enable Or Disable Wifi" ]]; then
    # Toggle Wi-Fi status
    wifi_status=$(nmcli radio wifi)
    if [[ $wifi_status == "enabled" ]]; then
        nmcli radio wifi off
    else
        nmcli radio wifi on
    fi

elif [[ $main_menu = "Forget a Wifi Network" ]]; then
    # List all saved Wi-Fi connections
    saved_wifi_connections=$(nmcli -f NAME,TYPE connection show | grep wifi | awk '{$NF=""; sub(/[ \t]+$/, ""); print}' | sort -u)
    forget_ssid=$(echo "$saved_wifi_connections" | rofi -dmenu -p "WiFi Manager: Choose a Wifi Network to Forget")
    if [[ ! -z $forget_ssid ]]; then
        nmcli connection delete "$forget_ssid"
    fi
fi
















# #!/bin/bash

# main_menu=$(echo -e "Connect to a Wifi Network\nEnable Or Disable Wifi\nForget a Wifi Network" | rofi -dmenu -p "WiFi Manager: What would you like to do?")

# if [[ $main_menu = "Connect to a Wifi Network" ]]; then
#     # List all available Wi-Fi networks and mark the active one
#     wifi_list=$(nmcli -t --fields SSID,ACTIVE device wifi list | sed /^$/d | sort | uniq | awk -F: '{if ($2 == "yes") print $1 " (active)"; else print $1}' | sort | uniq)
#     wifi_ssid=$(echo "$wifi_list" | rofi -dmenu -p "WiFi Manager: Choose a Wifi Network")

#     if [[ ! -z $wifi_ssid ]]; then
#         # Remove "(active)" marker if present
#         wifi_ssid=$(echo $wifi_ssid | sed 's/ (active)//')

#         # List all saved Wi-Fi connections
#         saved_connections=$(nmcli -t --fields NAME connection show)

#         # Check if the selected Wi-Fi network is already a saved connection
#         is_saved=$(echo "$saved_connections" | grep -w "$wifi_ssid")

#         if [[ -n $is_saved ]]; then
#             # Connect to the saved Wi-Fi network without asking for password
#             nmcli connection up "$wifi_ssid"
#         else
#             # Prompt for password and connect to the selected Wi-Fi network
#             password=$(rofi -dmenu -password -p "WiFi Manager: Enter password for $wifi_ssid")
#             nmcli device wifi connect "$wifi_ssid" password "$password"
#         fi
#     fi

# elif [[ $main_menu = "Enable Or Disable Wifi" ]]; then
#     # Implement enabling or disabling Wi-Fi functionality
#     wifi_status=$(nmcli radio wifi)
#     if [[ $wifi_status == "enabled" ]]; then
#         nmcli radio wifi off
#     else
#         nmcli radio wifi on
#     fi

# elif [[ $main_menu = "Forget a Wifi Network" ]]; then
#     # Let the user choose which Wi-Fi network to forget
#     forget_ssid=$(nmcli -t --fields NAME connection show | rofi -dmenu -p "WiFi Manager: Choose a Wifi Network to Forget")
#     if [[ ! -z $forget_ssid ]]; then
#         nmcli connection delete "$forget_ssid"
#     fi

# fi
