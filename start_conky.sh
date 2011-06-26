#!/bin/bash

conky -c /home/michael/.config/conky/.conkyrc_clock &
conky -c /home/michael/.config/conky/.conkyrc_rings &
conky -c /home/michael/.config/conky/.conkyrc_bills &
sleep 1
conky -c /home/michael/.config/conky/.conkyrc_tv &
sleep 1
conky -c /home/michael/.config/conky/.conkyrc_todo &
