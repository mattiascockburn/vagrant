#!/bin/bash
rpm -Uhv http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

yum makecache
yum -y install puppet

# This will be done via puppet
#yum -y install jenkins

cat <<EOF >/etc/puppet/puppet.conf
[main]
server = foreman.puppet.int
EOF

cat <<EOF >/etc/resolv.conf
nameserver 10.4.4.100
search puppet.int
EOF
puppet agent -t -v 
