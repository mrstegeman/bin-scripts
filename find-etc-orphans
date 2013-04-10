#!/bin/bash

sudo find /etc -type f -exec pacman -Qo {} \; | grep '^error: No package owns'
