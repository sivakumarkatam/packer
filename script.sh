#!/bin/bash
sudo apt-get update
sudo apt-get install default-jdk -y
sudo apt-get install nginx -y
sudo apt-get install awscli
sudo apt-get install ruby -y
sudo apt-get install wget
cd /home/ubuntu
wget https://aws-codedeploy-ap-southeast-1.s3.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent start
sudo apt-get install python3 -y
cd /home/ubuntu
wget https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py
chmod +x awslogs-agent-setup.py
pwd
echo '[general]
state_file = /var/awslogs/state/agent-state  
 
[/var/log/messages]
file = /var/log/messages
log_group_name = /var/log/messages
log_stream_name = {instance_id}
datetime_format = %b %d %H:%M:%S' >> conf
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
sudo systemctl start awslogs.service
