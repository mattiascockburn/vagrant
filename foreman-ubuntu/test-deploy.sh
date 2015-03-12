#!/bin/bash
set -x 
echo Hello World
echo "deb http://deb.theforeman.org/ trusty 1.8" > /etc/apt/sources.list.d/foreman.list
echo "deb http://deb.theforeman.org/ plugins 1.8" >> /etc/apt/sources.list.d/foreman.list
wget -q http://deb.theforeman.org/pubkey.gpg -O- | apt-key add -
wget http://apt.puppetlabs.com/puppetlabs-release-trusty.deb -O /tmp/puppetlabs-release-trusty.deb
dpkg -i /tmp/puppetlabs-release-trusty.deb

apt-get update
##apt-get -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'  -f -q -y install foreman-installer
DEBIAN_FRONTEND=noninteractive apt-get install \
	-o Dpkg::Options::='--force-confdef' \
	-o Dpkg::Options::='--force-confold'  -y -f -q --force-yes \
	foreman-installer puppet

foreman-installer
service puppet restart

