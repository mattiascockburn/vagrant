#!/bin/bash
rpm -Uhv http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
rpm -Uhv http://yum.theforeman.org/releases/latest/el7/x86_64/foreman-release.rpm
rpm -Uhv http://mirror.imt-systems.com/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
yum makecache
#yum -y update
yum -y install foreman-installer puppet
cp /vagrant/foreman/foreman-installer-answers.yaml /etc/foreman/
foreman-installer
gem install --verbose --conservative r10k
pushd /etc/puppet/environments/production/
ln -s /vagrant/puppet/Puppetfile .
/usr/local/bin/r10k puppetfile install -v
echo '*' >/etc/puppet/autosign.conf
rm /etc/hiera.yaml
cp /vagrant/puppet/hiera.yaml /etc/puppet
ln -s /etc/puppet/hiera.yaml /etc/
cp -f /vagrant/puppet/manifests/site.pp /etc/puppet/environments/production/manifests
service httpd restart
