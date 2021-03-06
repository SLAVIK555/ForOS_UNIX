#!/bin/bash
 
# полный путь до скрипта
ABSOLUTE_FILENAME=`readlink -e "$0"`
# каталог в котором лежит скрипт
DIRECTORY=`dirname "$ABSOLUTE_FILENAME"`

echo $DIRECTORY

NAME="timeinnet"
#LOGNAME=tin
MSPATH="$DIRECTORY/$NAME.sh"

cat > "/etc/systemd/system/$NAME.service" <<EOF
[Unit]
Description=Timeout logger

[Service]
ExecStart=$MSPATH

[Install]
WantedBy=multi-user.target
EOF
echo "/etc/systemd/system/$NAME.service successful installed"

cat > "$MSPATH" <<EOF
#!/bin/bash
dbus-monitor --system "sender=org.freedesktop.NetworkManager, path=/org/freedesktop/NetworkManager, member=StateChanged" | sed -u -n -e 's/uint32 70/sudo bash connected.sh/p; s/uint32 60/sudo bash disconnected.sh/p; s/uint32 50/sudo bash disconnected.sh/p; s/uint32 40/sudo bash disconnected.sh/p; s/uint32 30/sudo bash disconnected.sh/p; s/uint32 20/sudo bash disconnected.sh/p; s/uint32 10/sudo bash disconnected.sh/p; s/uint32 0/sudo bash disconnected.sh/p' | sh
EOF
chmod +x "$MSPATH"
echo "$MSPATH successful installed"

cat > "/usr/local/bin/connected.sh"<<\EOF
#!/bin/bash
NAME="timeinnet"
. usr/local/bin/$NAME.cfg

filename="usr/local/bin/$NAME.cfg"

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
. usr/local/bin/$NAME.cfg
sed -i "s/$last_connected_date_time/$date_time_of_connection/" $filename
. usr/local/bin/$NAME.cfg
sed -i "s/$last_connected_dps/$newdps/" $filename
. usr/local/bin/$NAME.cfg

fi

exit 0
EOF
chmod +x "/usr/local/bin/connected.sh"
echo "/usr/local/bin/connected.sh successful installed"

cat > "/usr/local/bin/disconnected.sh"<<\EOF
#!/bin/bash
NAME="timeinnet"
. usr/local/bin/$NAME.cfg

filename="usr/local/bin/$NAME.cfg"

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
. usr/local/bin/$NAME.cfg

fi

exit 0
EOF
chmod +x "/usr/local/bin/disconnected.sh"
echo "/usr/local/bin/disconnected.sh successful installed"

cat > "/usr/local/bin/$NAME.cfg" <<EOF
LOG_PATH='/usr/local/bin/$NAME.log'
netflag="false"
last_connected_date_time="2021-03-03 23:47:59"
last_connected_dps=1614804479
EOF
echo "/usr/local/bin/$NAME.cfg successful installed"

cat > "/usr/local/bin/$NAME.log" <<EOF
/dev/null

EOF
echo "/usr/local/bin/$NAME.log successful installed"
echo "---------------------"
echo "---------------------"
echo "---------------------"
echo "For start your service enter 'sudo systemctl start $NAME.service' in console"
echo "For stop your service enter 'sudo systemctl stop $NAME.service' in console"
echo "For check status of your service enter 'systemctl status $NAME.service' in console"
echo "To add your service to auto-run enter 'sudo systemctl enable $NAME.service' in console"
echo "To delete your service from auto-run enter 'sudo systemctl disable $NAME.service' in console"
echo "For check if the service is already in auto-run enter 'sudo systemctl is-enabled $NAME.service' in console"

#####deinstalator (uncomment and run)#####
#sudo systemctl stop $NAME.service
#sudo rm /etc/systemd/system/$NAME.service
#sudo rm $MSPATH
#sudo rm /usr/local/bin/connected.sh
#sudo rm /usr/local/bin/disconnected.sh
#sudo rm /usr/local/bin/$NAME.cfg
#sudo rm /usr/local/bin/$NAME.log
#echo "all service files successfil uninstalled"
#####deinstallator#####
