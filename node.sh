#!/bin/bash


sudo wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm &&  rpm -ivh epel-release-latest-7.noarch.rpm

#sudo echo '[gluster38]
#name=Gluster 3.8
#baseurl=http://mirror.centos.org/centos/7/storage/$basearch/gluster-3.8/
#gpgcheck=0
#enabled=1' >  /etc/yum.repos.d/Gluster.repo
sudo yum install -y centos-release-gluster
sudo yum install -y glusterfs-client
sudo yum install -y wget curl vim zip
sudo echo '[gluster38]
name=Gluster 3.8
baseurl=http://mirror.centos.org/centos/7/storage/$basearch/gluster-3.8/
gpgcheck=0
enabled=1' >  /etc/yum.repos.d/Gluster.repo
echo "display repo file"
cat /etc/yum.repos.d/Gluster.repo

sleep 10
az=`curl http://169.254.169.254/latest/meta-data/placement/availability-zone/`
sudo mkdir -p /var/www/magento2/pub/media
touch /var/www/magento2/pub/media/new.html

#echo "AZ is: $az"
sleep 5


if [ "$az" == "ap-southeast-1a" ]
 then
 
grep -q -F 'gfs2.unicorn.cloud:/gv0 /var/www/magento2/pub/media/ glusterfs context=system_u:object_r:httpd_sys_rw_content_t:s0,defaults,_netdev,backupvolfile-server=gfs1.unicorn.cloud,fetch-attempts=10 0 2' /etc/fstab || echo 'gfs2.unicorn.cloud:/gv0 /var/www/magento2/pub/media/ glusterfs context=system_u:object_r:httpd_sys_rw_content_t:s0,defaults,_netdev,backupvolfile-server=gfs1.unicorn.cloud,fetch-attempts=10 0 2' >> /etc/fstab
sudo mount -t glusterfs -o context=system_u:object_r:httpd_sys_rw_content_t:s0  gfs1.unicorn.cloud:/gv0 /var/www/magento2/pub/media/

echo "AZ is: $az"
cat /etc/fstab
elif [ "$az" == "ap-southeast-1b" ]
 then
grep -q -F 'gfs2.unicorn.cloud:/gv0 /var/www/magento2/pub/media/ glusterfs context=system_u:object_r:httpd_sys_rw_content_t:s0,defaults,_netdev,backupvolfile-server=gfs1.unicorn.cloud,fetch-attempts=10 0 2' /etc/fstab || echo 'gfs2.unicorn.cloud:/gv0 /var/www/magento2/pub/media/ glusterfs context=system_u:object_r:httpd_sys_rw_content_t:s0,defaults,_netdev,backupvolfile-server=gfs1.unicorn.cloud,fetch-attempts=10 0 2' >> /etc/fstab
sudo mount -t glusterfs -o context=system_u:object_r:httpd_sys_rw_content_t:s0  gfs2.unicorn.cloud:/gv0 /var/www/magento2/pub/media/
echo "AZ is: $az"
cat /etc/fstab
elif [ "$az" == "ap-southeast-1c" ]
 then

sudo mount -t glusterfs -o context=system_u:object_r:httpd_sys_rw_content_t:s0  gfs3.unicorn.cloud:/gv0 /var/www/magento2/pub/media/
grep -q -F 'gfs2.unicorn.cloud:/gv0 /var/www/magento2/pub/media/ glusterfs context=system_u:object_r:httpd_sys_rw_content_t:s0,defaults,_netdev,backupvolfile-server=gfs1.unicorn.cloud,fetch-attempts=10 0 2' /etc/fstab || echo 'gfs2.unicorn.cloud:/gv0 /var/www/magento2/pub/media/ glusterfs context=system_u:object_r:httpd_sys_rw_content_t:s0,defaults,_netdev,backupvolfile-server=gfs1.unicorn.cloud,fetch-attempts=10 0 2' >> /etc/fstab
echo "AZ is: $az"
cat /etc/fstab
else

exit 1

fi

sleep 10
echo "mount -a command is running..."
mount -a
echo "sucessfully mounted..."
df -h
echo "Changing ownership of pub directory "
chown -R nginx: /var/www/magento2/pub

ls -Z /var/www/magento2/pub
sudo chcon -R -t httpd_sys_rw_content_t /var/www/magento2/
sudo df -h
