#!/bin/bash

S=/opt/splunk/
export PATH=$PATH:$S/bin

IPADDR=$(ip a s | sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')

# ssh part
/usr/sbin/sshd 

splunk start --accept-license

# disable password change screen
touch $S/etc/.ui_login

# new "complex" password ;)
splunk edit user admin -password admin -auth admin:changeme

# enable receiver
splunk enable listen 9997 -auth admin:admin

echo "IP: $IPADDR"

tail -f $S/var/log/splunk/splunkd.log

