#!/bin/bash
check_wifi="$(nmcli device status | grep -w wifi | grep -w connected | awk '{ print $2 }')"
check_ethernet="$(nmcli device status | grep -w ethernet | grep -w connected | awk '{ print $2 }')"
check_ethernet_wifi="$(nmcli device status | grep -e ethernet -e wifi | grep -w connected | awk '{ print $2 }' | sed 'N;s/\n/ /')"

if [[ $check_ethernet_wifi = "ethernet wifi" ]]; then
	echo " "
elif [[ $check_wifi = "wifi" ]]; then
	echo ""
elif [[ $check_ethernet = "ethernet" ]]; then
	echo ""
else
	echo ""
fi

