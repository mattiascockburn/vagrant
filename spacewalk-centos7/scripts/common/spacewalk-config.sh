#!/bin/bash

echo Running spacewalk-setup and configuring service
spacewalk-setup --disconnected --answer-file=/vagrant/config/spacewalk-answers.cfg
if [ $? -ne 0 ];then
	echo spacewalk-setup failed. please check the appropriate logfiles
	exit 1
else
	cat <<EOF
	You may now navigate to the spacewalk webinterface and create a user
	After that, adjust config/spacewalk-config-post.cfg
	and start scripts/common/spacewalk-config-post.sh in order to setup channels,
	activationkeys and so on
EOF

fi
