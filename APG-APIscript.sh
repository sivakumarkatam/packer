#!/bin/bash
env='UAT'
sudo su
sudo yum update -y
sudo yum install -y epel-release wget awscli ruby python nginx ntp zip unzip
wget http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
sudo rpm -ivh nginx-release-centos-7-0.el7.ngx.noarch.rpm
#sudo yum install -y nginx
sudo rm -rf nginx-release-centos-7-0.el7.ngx.noarch.rpm
sudo service nginx start
sudo mkdir -u /var/log/unicorn
sudo chkconfig nginx on
#sudo yum install ntp -y
sudo timedatectl set-timezone Asia/Singapore
sudo systemctl enable ntpd
sudo systemctl disable chronyd
sudo systemctl start ntpd

cd /tmp/
wget https://aws-codedeploy-ap-southeast-1.s3.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo systemctl start codedeploy-agent


wget https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py
chmod +x awslogs-agent-setup.py
pwd

echo "[general]
state_file = /var/awslogs/state/agent-state  
 
[/var/log/nginx/error.log]

datetime_format = %Y/%m/%d %H:%M:%S
file = /var/log/nginx/error.log
buffer_duration = 5000
log_stream_name = NginxErrorLogs
initial_position = end_of_file
log_group_name = $env-UNICORN-UI-logs

[/var/log/syslogs]
datetime_format = %Y/%m/%d %H:%M:%S
file = /var/log/messages
buffer_duration = 5000
log_stream_name = UI-Syslogs
initial_position = end_of_file
log_group_name = $env-UNICORN-UI-logs

[/var/log/unicorn]

datetime_format = %Y/%m/%d %H:%M:%S
file = /var/log/unicorn/ui.log
buffer_duration = 5000
log_stream_name = UI-Debuglogs
initial_position = end_of_file
log_group_name = $env-UNICORN-UI-logs" >> /tmp/config

#echo '[Unit]
#Description=Service for CloudWatch Logs agent
#After=rc-local.service
#[Service]
#Type=simple
#Restart=always
#KillMode=process
#TimeoutSec=infinity
#PIDFile=/var/awslogs/state/awslogs.pid
#ExecStart=/var/awslogs/bin/awslogs-agent-launcher.sh --start --background --pidfile $PIDFILE --user awslogs --chuid awslogs &
#[Install]
#WantedBy=multi-user.target' >> /home/centos/serv

sudo ./awslogs-agent-setup.py -c /tmp/config -r ap-southeast-1 -n
#cd /etc/systemd/system
#sudo cp /home/centos/serv /etc/systemd/system/awslogs.service
sudo systemctl daemon-reload
sudo service awslogs start
sudo systemctl restart awslogs.service
sudo systemctl enable awslogs.service
sudo systemctl start awslogs.service
sudo systemctl restart awslogs.service
cd /tmp/
sudo yum install perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https perl-Digest-SHA -y
#sudo yum install zip unzip -y
sudo curl http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip -O
sudo unzip CloudWatchMonitoringScripts-1.2.1.zip
sudo rm -f CloudWatchMonitoringScripts-1.2.1.zip
cd aws-scripts-mon

#sudo echo './mon-put-instance-data.pl --mem-used-incl-cache-buff --mem-util --disk-space-util --disk-path=/ --from-cron' >>/home/centos/aws-scripts-mon/custommetrics.sh

(crontab -l ; echo "*/2 * * * * /tmp/aws-scripts-mon/mon-put-instance-data.pl --mem-used-incl-cache-buff --mem-util --disk-space-util --disk-path=/ --from-cron")| sudo crontab -
