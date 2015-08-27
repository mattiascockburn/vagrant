#!/bin/bash
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

