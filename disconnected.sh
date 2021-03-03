#!/bin/bash
. timeinnet.cfg

filename="timeinnet.cfg"

function show_time () {
    num=$1
    min=0
    hour=0
    day=0
    if((num>59));then
        ((sec=num%60))
        ((num=num/60))
        if((num>59));then
            ((min=num%60))
            ((num=num/60))
            if((num>23));then
                ((hour=num%24))
                ((day=num/24))
            else
                ((hour=num))
            fi
        else
            ((min=num))
        fi
    else
        ((sec=num))
    fi
    resdhms=""$day"days "$hour"hours "$min"minutes "$sec"seconds"
    echo "time in net: $resdhms" >> "$LOG_PATH"
}

if [[ $netflag == "true" ]] #now disconnected and we will connect #0 - disconnected, 1 - connected
then
#echo "OK"
date_time_of_disconnection="`date "+%Y-%m-%d %H:%M:%S"`"
disdps=$(date +%s)
#echo $date_time_of_disconnection
#echo "TIN"
res=$(( ($disdps - $last_connected_dps ) ))
#echo "$res sec"
echo "last date time of disconnection: [$date_time_of_disconnection]" >> "$LOG_PATH"
show_time $res
echo "--------------------------------------------------------" >> "$LOG_PATH"
# bla bla bla
newnetflag="false"

#echo $last_connected_date_time
#echo $date_time_of_connection

sed -i "s/$netflag/$newnetflag/" $filename
. timeinnet.cfg

fi

exit 0
