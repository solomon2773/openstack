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


export LC_TYPE="UTF-8"
export LANG="en-US.UTF-8"
export LC_ALL="C"

cat /etc/selinux/config | grep -v '^#' | grep disabled
 SELINUX=disabled
 
###   Software repositories
echo "Software Repositories Setup"

yum install -y centos-release-openstack-rocky
yum install -y yum-utils --enablerepo="base"
yum-config-manager --enable openstack-rocky
yum update -y


#### Install Packstack Installer
##echo "Install Packstack Installer"

yum install -y openstack-packstack 
hostname cloud0.mywebsite.com
###
# Create proper /etc/hosts file

cat <<- EOF > /etc/hosts
127.0.0.1   localhost
192.168.11.100 cloud0.yottacommerce.com
192.168.11.101 cloud1.yottacommerce.com
192.168.11.102 cloud2.yottacommerce.com
EOF

#### Run Packstack to install OpenStack

echo "Run Packstack to install OpenStack All in One"
packstack --gen-answer-file=answers.txt
packstack --allinone --answer-file=answers.txt

END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo "Done"
echo "Total time spend :" $DIFF
