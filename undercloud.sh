
sudo useradd stack
sudo passwd stack  # specify a password

echo "stack ALL=(root) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/stack
sudo chmod 0440 /etc/sudoers.d/stack
su - stack

# Enable optional repo:
sudo yum install -y yum-utils
sudo yum-config-manager --enable rhelosp-rhel-7-server-opt

sudo yum install -y https://trunk.rdoproject.org/centos7/current/python2-tripleo-repos-0.0.1-0.20190308044951.8f0397e.el7.noarch.rpm

#Rocky
#Enable the current Rocky repositories
sudo -E tripleo-repos -b rocky current
#Ceph
#Include the Ceph repo in the tripleo-repos call
sudo -E tripleo-repos -b rocky current ceph

#Run tripleo-repos to install the appropriate repositories. The option below will enable the latest master TripleO packages, the latest promoted packages for all other OpenStack services and dependencies and the latest stable Ceph packages. There are other repository configurations available in tripleo-repos, see its --help output for details.
sudo -E tripleo-repos current-tripleo-dev ceph
sudo yum install -y python-tripleoclient
sudo yum install -y ceph-ansible

#Prepare the configuration file:
#cp /usr/share/python-tripleoclient/undercloud.conf.sample ~/undercloud.conf

# undercloud config file generate http://ucw.tripleo.org/

