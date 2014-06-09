#!/bin/bash

# all containers
containers="base splunk jboss5 jboss6 jboss7 liferay"

# images prefix
img_prefix='slashroot'

# path to apps
BASE=$(cd $(dirname $0);pwd)
fwd_app="$BASE/src/ta-jboss"
srv_app="$BASE/src/jboss_inside"

usage() {
cat <<EOF

Usage: $0 start|stop|restart|rm|status|build|ssh CONTAINER

where

CONTAINER can be one of the following:

$containers

EOF
}

start_splunk() {
	echo -n "Starting splunk server"
	srv_id=$(docker run -t -P --name splunk -d -v $srv_app:/opt/splunk/etc/apps/jboss_app slashroot/splunk)
	if [ $? -eq 0 ];then
		echo " ..started: $srv_id"
		return 0
	else
		echo " FAILED"
		return 1
	fi
}

start_jb() {
	local ver=$1
	echo -n "Starting $ver"
	fwd_id=$(docker run -P -d -t --name ${ver} --link splunk:splunk -v $fwd_app:/opt/splunkforwarder/etc/apps/ta-jboss $img_prefix/${ver})
	if [ $? -eq 0 ];then
		echo " ..started: $fwd_id"
		return 0
	else
		echo " FAILED"
		return 1
	fi
}

c_isvalid() {
    local c=$1
    for i in $containers;do
        [ $i = $c ] && return 0
    done
    echo "Container $c does not exist" 1>&2
    return 1
}

c_start() {
	local c=$1
    c_isvalid $c || return 1
	case $c in
		splunk) start_splunk;;
		*) start_jb ${c} ;;
	esac
}
c_stop() {
	local c=$1
    c_isvalid $c || return 1
	case $c in
		all) for c in $containers;do echo "Stoppping $c";docker stop $c;done;;
		*) docker stop $c ;;
	esac
}
c_rm() {
	local c=$1
    c_isvalid $c || return 1
	case $c in
		all) for c in $containers;do echo "Removing $c";docker rm $c;done;;
		*) docker rm $c;;
	esac
}
c_build() {
	local c=$1
    c_isvalid $c || return 1
	case $c in
		all) for i in $containers;do echo "Building $c";c_build $i;done;;
		*) docker build -t slashroot/$c $BASE/$c ;;
	esac
}
c_ssh() {
	local c=$1
    c_isvalid $c || return 1
	local port=$(docker port $c 22|awk -F:  '{print $2}')
	if [ -z "$port" ];then
		echo "Unable to determine port.." 1>&2
		return 1
	fi
	ssh -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no localhost -lroot -p$port
}

cmd=$1
arg=${2:-all}

[ -n "$cmd" ] || { usage; exit 2; }


case ${1:-none} in
	start) c_start $arg ;;
	restart) c_stop $arg;c_rm $arg;c_start $arg ;;
	stop) c_stop $arg ;;
	rm) c_rm $arg ;;
	ssh) c_ssh $arg ;;
	status) docker ps ;;
	build) c_build $arg ;;
	*) usage; exit 2 ;;
esac

