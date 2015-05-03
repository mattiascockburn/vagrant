#!/bin/bash
rpm -i http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
rpm -i http://yum.theforeman.org/releases/latest/el7/x86_64/foreman-release.rpm
rpm --import RPM-GPG-KEY-CentOS-7
yum makecache
yum -y update
yum -y install foreman-installer puppet

#foreman-installer

