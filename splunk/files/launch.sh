#!/bin/bash


# define default password
SPLUNK_PWD=${SPLUNK_PWD:-admin}

S=/opt/splunk/
export PATH=$PATH:$S/bin

IPADDR=$(ip a s | sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')

if [ -n "$SSH_PUBKEY" ];then
    echo ">> Setting ssh key"
    mkdir /root/.ssh
cat << EOF > /root/.ssh/authorized_keys
$SSH_PUBKEY
EOF
    chmod 600 /root/.ssh/authorized_keys;chmod 700 /root/.ssh/
fi

# ssh part
/usr/sbin/sshd 

if [ -n "$SPLUNK_ENDPOINT" ];then
    echo ">> Changing endpoint to $SPLUNK_ENDPOINT"
    sed -i "s|^root_endpoint.*|root_endpoint = /$SPLUNK_ENDPOINT|" /opt/splunk/etc/system/default/web.conf
fi

splunk start --accept-license

# disable password change screen
touch $S/etc/.ui_login

echo ">> Changing password to $SPLUNK_PWD"
# new "complex" password ;)
splunk edit user admin -password $SPLUNK_PWD -auth admin:changeme

# enable receiver
echo ">> Enabling receiver on port 9997"
splunk enable listen 9997 -auth admin:$SPLUNK_PWD

cat << EOF
=====================================

Access: 

http://$IPADDR:8000/$SPLUNK_ENDPOINT

Login: admin
Password: $SPLUNK_PWD

=====================================
EOF

tail -f $S/var/log/splunk/splunkd.log

