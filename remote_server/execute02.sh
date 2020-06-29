if [ -e /home/ubuntu/rasp30/remote_server/fpaa_available ]
then
    rm /home/ubuntu/rasp30/remote_server/fpaa_available
    /opt/python3.4/bin/python3.4 /home/ubuntu/rasp30/remote_server/get_email02.py >> /home/ubuntu/Desktop/receive.log 2>&1
    grep -v 'Message can be printed here (Lot of garbage will appear on prompt)' /home/ubuntu/Desktop/receive.log > /home/ubuntu/Desktop/receive_temp.log
    mv /home/ubuntu/Desktop/receive_temp.log /home/ubuntu/Desktop/receive.log
    grep -v 'You have 0 new messages' /home/ubuntu/Desktop/receive.log > /home/ubuntu/Desktop/receive_temp.log
    mv /home/ubuntu/Desktop/receive_temp.log /home/ubuntu/Desktop/receive.log
    touch /home/ubuntu/rasp30/remote_server/fpaa_available
fi
