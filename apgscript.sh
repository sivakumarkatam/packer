#!/bin/bash
yum update -y
yum install rpm -y
cd /opt
sudo wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jre-8u45-linux-x64.rpm"
sudo rpm -Uvh jre-8u45-linux-x64.rpm
sudo yum install nginx -y
