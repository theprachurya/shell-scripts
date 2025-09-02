#!/bin/bash

    echo "List of Wi-Fi devices"
    nmcli device wifi list

    read -p "Enter Wi-Fi name from list :" ssid
    if nmcli device wifi connect "$ssid" --ask ; then
    echo "Connected to $ssid"
    else
    echo "Failed to connect to $ssid"
    fi
