#!/bin/bash

enabled=$(xinput --list-props 12 | grep Enabled | awk '{print $4}')

if [ "$enabled" = 1 ]; then
    xinput --set-prop 12 'Device Enabled' 0
else
    xinput --set-prop 12 'Device Enabled' 1
fi
