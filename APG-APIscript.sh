#!/bin/bash
sudo apt-get update
sudo apt-get install default-jdk awscli ruby wget -y
sudo apt-get install nginx -y
sudo service nginx start

cd /home/ubuntu
wget https://aws-codedeploy-ap-southeast-1.s3.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent start
sudo apt-get install python3 -y

sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update
sudo apt-get install ansible -y

cd /home/ubuntu
wget https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py
chmod +x awslogs-agent-setup.py
pwd

echo '[general]
state_file = /var/awslogs/state/agent-state  
 
[/home/ubuntu/cloudwatch/logs/Debug.log]

datetime_format = %Y/%m/%d %H:%M:%S
file = /home/ubuntu/cloudwatch/logs/Debug.log
buffer_duration = 5000
log_stream_name = API-Debug
initial_position = end_of_file
log_group_name = /home/ubuntu/cloudwatch/logs/Debug.log 

[/var/log/messages]
datetime_format = %Y/%m/%d %H:%M:%S
file = /var/log/messages
buffer_duration = 5000
log_stream_name = API-Syslogs
initial_position = end_of_file
log_group_name = /var/log/syslog' >> conf

echo '[Unit]
Description=Service for CloudWatch Logs agent
After=rc-local.service
[Service]
Type=simple
Restart=always
KillMode=process
TimeoutSec=infinity
PIDFile=/var/awslogs/state/awslogs.pid
ExecStart=/var/awslogs/bin/awslogs-agent-launcher.sh --start --background --pidfile $PIDFILE --user awslogs --chuid awslogs &
[Install]
WantedBy=multi-user.target' >> serv

sudo python3 ./awslogs-agent-setup.py -c conf -r ap-southeast-1 -n
cd /etc/systemd/system
sudo cp /home/ubuntu/serv /etc/systemd/system/awslogs.service
sudo systemctl daemon-reload
sudo systemctl enable awslogs.service
sudo systemctl start awslogs.service
