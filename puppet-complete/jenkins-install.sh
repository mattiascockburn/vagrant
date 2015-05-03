#!/bin/bash
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
rpm --import RPM-GPG-KEY-CentOS-7

yum makecache
yum -y update
yum -y install jenkins

