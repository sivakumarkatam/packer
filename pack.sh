#!/bin/bash
cd /home/ubuntu
sudo cp /var/lib/jenkins/workspace/packer/* /home/ubuntu/packer/
cd /home/ubuntu/packer
packer build coe.json
