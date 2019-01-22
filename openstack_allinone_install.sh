#!/bin/bash
START=$(date +%s.%N)
###  Network Setup
echo "Network Setup"

systemctl disable firewalld
systemctl stop firewalld
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl enable network
systemctl start network

###   Software repositories
echo "Software Repositories Setup"

yum install -y centos-release-openstack-rocky
yum install -y yum-utils --enablerepo="base"
yum-config-manager --enable openstack-rocky
yum update -y


#### Install Packstack Installer
##echo "Install Packstack Installer"

yum install -y openstack-packstack 


#### Run Packstack to install OpenStack

echo "Run Packstack to install OpenStack All in One"
packstack --gen-answer-file=answers.txt
packstack --allinone --answer-file=answers.txt

END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo "Done"
echo "Total time spend :" $DIFF
