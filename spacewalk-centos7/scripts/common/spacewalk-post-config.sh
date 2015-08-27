#!/bin/bash
# hacked by giese@b1-systems.de
set -u

cat <<EOF
This script will setup some demo channels, activation keys
and configuration channel. Software will automatically be synced

Make sure you copied /vagrant/config/channels.ini.example to 
/vagrant/config/channels.ini and adjusted it according to your needs.
Take a close look at the mirror-variable and repo paths!

You should also edit /vagrant/config/spacewalk-post.cfg and adjust username/password
if you were not using defaults.

Continue with ENTER, cancel with CTRL+C
EOF
read foo

CONF='/vagrant/config/spacewalk-post.cfg'

[ -r "$CONF" ] || {
	echo Config $CONF could not be read
	exit 1
}

. "$CONF"

ohai() {
	GREEN="\e[1;32m\]"
	NORM="\[\e[0m\]"
	echo "${GREEN}===>${NORM} $@"
}

ohai Creating channels and activationkeys

for channel in $CHANNELS; do
	spacewalk-common-channels \
		-a $ARCH \
		-u $USER \
		-p $PASSWORD \
		-k unlimited \
		-v \
		-c $CHANNELCONF \
		"${channel}*"
done

ohai Bootstrapping API helpers

sed -e "s|__SWUSER__|$USER|g" -e "s|__SWPASS__|$PASSWORD|g" \
	/vagrant/config/b1-spacewalk-lib.conf.template \
	> /etc/b1-spacewalk-lib.conf

REPODIR=/var/www/html/pub/repos
ohai Syncing spacewalk-client repos and exporting to $REPODIR

pushd /vagrant/scripts/common
mkdir -p $REPODIR

for channel in $(spacecmd -u $USER -p $PASSWORD softwarechannel_list 2>/dev/null | grep spacewalk);do
	ohai Syncing $channel
	spacewalk-repo-sync -c $channel
	[ $? -eq 0 ] && {
		ohai Successfully synced ${channel}, exporting now	
		./b1-export-channel $channel
		pushd "${REPODIR}/${channel}"
		createrepo .
		popd
	}
done

ohai Copying bootstrap template and adjusting hostname

cp -R /vagrant/config/bootstrap /var/www/html/pub/
HOST=$(hostname -f)
for a in /var/www/html/pub/bootstrap/{bootstrap-custom.sh,client-config-overrides.txt}; do
	sed -i -e "s|__SPACEWALKHOST__|$HOST|g" "$a"
done
