#!/bin/bash


# all containers
containers="splunk jb5 jb6 jb7"

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
	srv_id=$(docker run -t -P --name splunk -d -v $srv_app:/opt/splunk/etc/apps/jboss_app splunk)
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
	echo -n "Starting JBoss $ver"
	fwd_id=$(docker run -P -d -t --name jb${ver} --link splunk:splunk -v $fwd_app:/opt/splunkforwarder/etc/apps/ta-jboss jboss${ver})
	if [ $? -eq 0 ];then
		echo " ..started: $fwd_id"
		return 0
	else
		echo " FAILED"
		return 1
	fi
}

c_start() {
	local c=$1
	case $c in
		splunk) start_splunk;;
		jb*) start_jb ${c##jb} ;;
		*) echo "Unknown container $1" 1>&2;;
	esac
}
c_stop() {
	local c=$1
	case $c in
		all) for c in $containers;do echo "Stoppping $c";docker stop $c;done;;
		splunk) docker stop splunk ;;
		jb*) docker stop $c ;;
		*) echo "Unknown container $1" 1>&2;;
	esac
}
c_rm() {
	local c=$1
	case $c in
		all) for c in $containers;do echo "Removing $c";docker rm $c;done;;
		splunk) docker rm splunk ;;
		jb*) docker rm $c;;
		*) echo "Unknown container $1" 1>&2;;
	esac
}
c_build() {
	local c=$1
	case $c in
		all) for c in $containers;do echo "Building $c";docker build -t $c $BASE/$c;done;;
		splunk|jboss*) docker build -t $c $BASE/$c ;;
		*) echo "Unknown container $1" 1>&2;;
	esac
}
c_ssh() {
	local c=$1
	if [ $c = "all" ];then
		echo "You need to specify one container: $containers"
		return 1
	fi
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

