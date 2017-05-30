sudo yum install -y epel-release wget rpm awscli ruby python
sudo yum -y install nodejs
sudo yum -y install npm
sudo npm install pm2 -g
pm2 startup




cd /home/centos
wget https://aws-codedeploy-ap-southeast-1.s3.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo systemctl start codedeploy-agent

cd /home/centos
wget https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py
chmod +x awslogs-agent-setup.py
pwd

echo '[general]
state_file = /var/awslogs/state/agent-state  
 
[/var/log/nginx/error.log]

datetime_format = %Y/%m/%d %H:%M:%S
file = /var/log/nginx/error.log
buffer_duration = 5000
log_stream_name = unicorn-UI
initial_position = end_of_file
log_group_name = /var/log/nginx/error.log' >> conf

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

sudo ./awslogs-agent-setup.py -c conf -r ap-southeast-1 -n
cd /etc/systemd/system
sudo cp /home/centos/serv /etc/systemd/system/awslogs.service
sudo systemctl start awslogs.service
