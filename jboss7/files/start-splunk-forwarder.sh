#!/bin/bash

S=/opt/splunkforwarder
export PATH=$PATH:$S/bin

IPADDR=$(ip a s | sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')

splunk start --accept-license

# check if link to splunk server is defined
if [ -n "$SPLUNK_PORT" ];then
	SPLUNK_HOST=`echo $SPLUNK_PORT_9997_TCP|sed -e 's|.*tcp://\(.*\)|\1|'`
	echo "Splunk host discovered: $SPLUNK_HOST"
	splunk add forward-server $SPLUNK_HOST -auth admin:changeme
	exit 0
else
	echo "No splunk link detected - please provide link to splunk server as 'splunk' alias with access port exposed" 1>&2
	exit 1
fi

#tail -f $S/var/log/splunk/splunkd.log

