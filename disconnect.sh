#!/bin/bash

read -p "Name of Wi-Fi to disconnect from " ssid
if nmcli con down "$ssid"; then
echo "Disconnected successfully"
else
echo "Error encountered while disconnecting. Make sure you entered the right name"
fi
