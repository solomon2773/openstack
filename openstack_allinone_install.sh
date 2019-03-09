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
yum install -y deltarpm

#### Install Packstack Installer
##echo "Install Packstack Installer"

yum install -y openstack-packstack 

# Edit hostname file
hostname cloud0.yottacommerce.com
cat <<- EOF > /etc/hostname
cloud0.yottacommerce.com
EOF

# Create proper /etc/hosts file

cat <<- EOF > /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.11.100 cloud0 cloud0.yottacommerce.com
192.168.11.101 cloud1 cloud1.yottacommerce.com
192.168.11.102 cloud2 cloud2.yottacommerce.com
EOF

# Create proper /etc/sysconfig/network file
cat <<- EOF > /etc/sysconfig/network
HOSTNAME=cloud0.yottacommerce.com
EOF

#### Run Packstack to install OpenStack

echo "Run Packstack to install OpenStack All in One"
#packstack --gen-answer-file=answers.txt
#packstack  --answer-file=answers.txt
packstack --allinone --provision-demo=n --os-heat-install=y --os-sahara-install=y --ntp-servers=0.rhel.pool.ntp.org,1.rhel.pool.ntp.org --os-swift-storage-size=190G --cinder-volumes-size=2800G --os-neutron-ovs-bridge-mappings=extnet:br-ex,extnet1:br-ex1 --os-neutron-ovs-bridge-interfaces=br-ex:eno0,br-ex1:eno1 --os-neutron-ml2-type-drivers=vxlan,flat

#packstack --allinone --provision-demo=n --os-heat-install=y --os-sahara-install=y --ntp-servers=0.rhel.pool.ntp.org,1.rhel.pool.ntp.org --os-swift-storage-size=100G --cinder-volumes-size=900G --os-neutron-ovs-bridge-mappings=extnet:br-ex,extnet1:br-ex1 --os-neutron-ovs-bridge-interfaces=br-ex:eno0,br-ex1:eno1 --os-neutron-ml2-type-drivers=vxlan,flat


. keystonerc_admin
neutron net-create external_network --provider:network_type flat --provider:physical_network extnet  --router:external

neutron subnet-create --name public_subnet --enable_dhcp=False --allocation-pool=start=xxx.xxx.xxx.xxx,end=xxx.xxx.xxx.xxx \
                        --gateway=xxx.xxx.xxx.xxx external_network xxx.xxx.xxx.0/24


END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo "Done"
echo "Total time spend :" $DIFF
