#!/bin/bash
set -u

CONF=/vagrant/config/spacewalk-post.cfg
. $CONF

EXCLUDES='*i386*,*i586*,*i686*'
echo Will sync all channels with exclude filter $EXCLUDES
for channel in $(spacecmd -u $USER -p $PASSWORD softwarechannel_list 2>/dev/null);do
	spacewalk-repo-sync -c "$channel" -e "$EXCLUDES"
done
