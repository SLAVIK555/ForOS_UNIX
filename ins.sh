#!/bin/bash

LOG_PATH='/home/slava/Source/ITS/tm.log'
echo /dev/null > "$LOG_PATH"

echo "Scrip started. For kill script push Ctrl+C"

while (true)
do
    current_date_time="`date "+%Y-%m-%d %H:%M:%S"`"
    echo "[$current_date_time]: im allive" >> "$LOG_PATH"
    sleep 1;
    echo "1 second"
done;
