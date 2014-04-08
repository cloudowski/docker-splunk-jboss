#!/bin/bash

# set admin login
/opt/jboss-eap-6.2/bin/add-user.sh admin admin@123 --silent

IPADDR=$(ip a s | sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')

#JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.port=1999"
#JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.ssl=false"
#JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.authenticate=false"
#JAVA_OPTS="$JAVA_OPTS -Djboss.platform.mbeanserver"
#JAVA_OPTS="$JAVA_OPTS -Djavax.management.builder.initial=org.jboss.system.server.jmx.MBeanServerBuilderImpl"

#export JAVA_OPTS

export JAVA_HOME=/usr/java/latest

/opt/jboss-eap-6.2/bin/standalone.sh -c standalone-ha.xml -Djboss.bind.address=$IPADDR -Djboss.bind.address.management=$IPADDR -Djboss.node.name=server-$IPADDR
