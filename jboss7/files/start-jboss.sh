#!/bin/bash

# set admin login
/opt/jboss-as-7.1.1.Final/bin/add-user.sh admin admin@123 --silent

IPADDR=$(ip a s | sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')

export JAVA_HOME=/usr/java/latest

#/opt/jboss-eap-6.2/bin/standalone.sh -c standalone-ha.xml -Djboss.bind.address=$IPADDR -Djboss.bind.address.management=$IPADDR -Djboss.node.name=server-$IPADDR
/opt/jboss-as-7.1.1.Final/bin/standalone.sh -c standalone-ha.xml -Djboss.bind.address=$IPADDR -Djboss.node.name=server-$IPADDR
