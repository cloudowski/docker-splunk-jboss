#!/bin/bash

# set admin login
/opt/jboss-eap-6.2/bin/add-user.sh admin admin@123 --silent

IPADDR=$(ip a s | sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')

export JAVA_HOME=/usr/java/latest

conf=`find /opt -name standalone-ha.xml`

sed -i '/<\/extensions>/a<system-properties>\n<property name="org.apache.tomcat.util.ENABLE_MODELER" value="true"/>\n</system-properties>' $conf

#/opt/jboss-eap-6.2/bin/standalone.sh -c standalone-ha.xml -Djboss.bind.address=$IPADDR -Djboss.bind.address.management=$IPADDR -Djboss.node.name=server-$IPADDR
/opt/jboss-eap-6.2/bin/standalone.sh -c standalone-ha.xml -Djboss.bind.address=$IPADDR -Djboss.node.name=server-$IPADDR
