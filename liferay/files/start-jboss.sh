#!/bin/bash

# set admin login
/opt/liferay-portal-6.2-ce-ga2/jboss-7.1.1/bin/add-user.sh admin admin@123 --silent

IPADDR=$(ip a s | sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')


conf=`find /opt -name standalone.xml`

sed -i '/<\/system-properties>/i<property name="org.apache.tomcat.util.ENABLE_MODELER" value="true"/>' $conf

#export JAVA_HOME=/usr/java/latest

#/opt/jboss-eap-6.2/bin/standalone.sh -c standalone-ha.xml -Djboss.bind.address=$IPADDR -Djboss.bind.address.management=$IPADDR -Djboss.node.name=server-$IPADDR
/opt/liferay-portal-6.2-ce-ga2/jboss-7.1.1/bin/standalone.sh -Djboss.bind.address=$IPADDR -Djboss.node.name=server-$IPADDR
