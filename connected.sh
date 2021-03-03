#!/bin/bash
. timeinnet.cfg

filename="timeinnet.cfg"

if [[ $netflag == "false" ]] #now disconnected and we will connect #0 - disconnected, 1 - connected
then
#echo "OK"
date_time_of_connection="`date "+%Y-%m-%d %H:%M:%S"`"
newdps=$(date +%s)
echo "--------------------------------------------------------" >> "$LOG_PATH"
echo "last date time of connection: [$date_time_of_connection]" >> "$LOG_PATH"
# bla bla bla
newnetflag="true"

#echo $last_connected_date_time
#echo $date_time_of_connection
#echo $(( ($newdps - $last_connected_dps ) ))

sed -i "s/$netflag/$newnetflag/" $filename
. timeinnet.cfg
sed -i "s/$last_connected_date_time/$date_time_of_connection/" $filename
. timeinnet.cfg
sed -i "s/$last_connected_dps/$newdps/" $filename
. timeinnet.cfg

fi

exit 0


