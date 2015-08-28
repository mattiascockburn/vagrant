#!/bin/bash
# This script prepares a base centos7 install so that Spacewalk may be configured
set -u
DISTRO=${1:-centos}
RELEASE=${2:-7}

CONF=/vagrant/config/spacewalk-install.conf

[[ ! -r "$CONF" ]] && {
	echo Failed to load Config $CONF
	exit 1
}

. "$CONF"

configure_repos() {

	echo Configuring repos in order to install Spacewalk
	if [ "$DISTRO" = 'centos' ]; then
		REPODIR=/etc/yum.repos.d
		if [ "$RELEASE" -eq 7 ]; then
			set -e
			if [ "$MIRROR" -eq 1 ];then 
				mkdir -p "${REPODIR}/dist"
				mv "${REPODIR}"/*.repo "${REPODIR}/dist/"
				for repo in "${!SWREPOS[@]}";do
					cat <<EOF >"${REPODIR}/${repo}.repo"	
[${repo}]
name=Local ${repo} mirror
baseurl="${SWREPOS[$repo]}"
enabled=1
gpgcheck=0
EOF
				done
				echo Deactivating unused yum plugins
				for plugin in fastestmirror; do
					sed -i -e 's|enabled=1|enabled=0|g' "/etc/yum/pluginconf.d/${plugin}.conf"
				done
			else
				rpm -Uhv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
				rpm -Uhv http://yum.spacewalkproject.org/2.3/RHEL/7/x86_64/spacewalk-repo-2.3-4.el7.noarch.rpm
				cat <<EOF >/etc/yum.repos.d/jpackage.repo
[jpackage-generic]
name=JPackage generic
baseurl=http://vesta.informatik.rwth-aachen.de/ftp/pub/comp/Linux/jpackage/5.0/generic/free/
#mirrorlist=http://www.jpackage.org/mirrorlist.php?dist=generic&type=free&release=5.0
enabled=1
gpgcheck=1
gpgkey=http://www.jpackage.org/jpackage.asc
EOF
			fi
			echo Refreshing repository cache
			yum makecache
		fi
	else
		echo Unsupported distro
		exit 1
	fi

}

install_packages() {

	echo Installing all packages needed for Spacewalk
	yum -y install spacewalk-setup-postgresql	spacewalk-postgresql spacecmd spacewalk-utils

}

configure_repos
install_packages

