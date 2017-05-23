#!/bin/bash
sudo yum -y update
sudo yum -y install wget
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"  "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jre-8u131-linux-x64.rpm"
sudo yum -y localinstall jre-8u131-linux-x64.rpm
rm jre-8u131-linux-x64.rpm
sudo yum -y install epel-release
sudo yum -y install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
sudo yum -y install awscli
sudo yum -y install ruby
cd /home/centos
wget https://aws-codedeploy-ap-southeast-1.s3.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo systemctl start codedeploy-agent
