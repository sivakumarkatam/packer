#!/bin/bash
yum -y update
yum -y install wget
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"  "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jre-8u131-linux-x64.rpm"
yum -y localinstall jre-8u131-linux-x64.rpm
rm jre-8u131-linux-x64.rpm
yum -y install epel-release
yum -y install nginx
systemctl start nginx
systemctl enable nginx
