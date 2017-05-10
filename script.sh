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
sudo cp /var/lib/jenkins/workspace/bakeAMI/conf /home/ubuntu/conf
sudo cp /var/lib/jenkins/workspace/bakeAMI/ser /home/ubuntu/ser
sudo python3 ./awslogs-agent-setup.py -c /home/ubuntu/conf -r ap-southeast-1 -n
cd /etc/systemd/system
sudo cp /home/ubuntu/ser /etc/systemd/system/awslogs.service
sudo systemctl start awslogs.service
