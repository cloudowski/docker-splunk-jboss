#!/bin/bash

# set admin login
#/opt/jboss-eap-6.2/bin/add-user.sh admin admin#123 --silent

# start splunk forwarder
/start-splunk-forwarder.sh

# start sshd
/usr/sbin/sshd

# start splunk forwarder
/start-jboss.sh
