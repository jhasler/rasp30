if [ -e /home/cadsp/rasp30/remote_server/fpaa_available ]
then
    rm /home/cadsp/rasp30/remote_server/fpaa_available
    /opt/python3.4/bin/python3.4 /home/cadsp/rasp30/remote_server/get_email.py >> /home/cadsp/Desktop/receive.log 2>&1
    grep -v 'Message can be printed here (Lot of garbage will appear on prompt)' /home/cadsp/Desktop/receive.log > /home/cadsp/Desktop/receive_temp.log
    mv /home/cadsp/Desktop/receive_temp.log /home/cadsp/Desktop/receive.log
    grep -v 'You have 0 new messages' /home/cadsp/Desktop/receive.log > /home/cadsp/Desktop/receive_temp.log
    mv /home/cadsp/Desktop/receive_temp.log /home/cadsp/Desktop/receive.log
    touch /home/cadsp/rasp30/remote_server/fpaa_available
fi
