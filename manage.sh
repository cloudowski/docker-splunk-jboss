#!/bin/bash


# all containers
containers="splunk jb5 jb6"

# path to apps
BASE=$(cd $(dirname $0);pwd)
fwd_app="$BASE/src/ta-jboss"
srv_app="$BASE/src/jboss_inside"



usage() {
cat <<EOF

Usage: $0 start|stop|rm|status|build jb6|jb5|splunk

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
	fwd_id=$(docker run -P -d -t --name jb${ver} --link splunk:splunk -v $fwd_app:/opt/splunkforwarder/etc/apps/jboss_ta jboss${ver})
	if [ $? -eq 0 ];then
		echo " ..started: $fwd_id"
		return 0
	else
		echo " FAILED"
		return 1
	fi
}

c_start() {
	case $1 in
		splunk) start_splunk;;
		jb5) start_jb 5;;
		jb6) start_jb 6;;
		*) echo "Unknown container $1" 1>&2;;
	esac
}
c_stop() {
	case $1 in
		all) for c in $containers;do echo "Stoppping $c";docker stop $c;done;;
		splunk) docker stop splunk ;;
		jb5) docker stop jb5 ;;
		jb6) docker stop jb6 ;;
		*) echo "Unknown container $1" 1>&2;;
	esac
}
c_rm() {
	case $1 in
		all) for c in $containers;do echo "Removing $c";docker rm $c;done;;
		splunk) docker rm splunk ;;
		jb5) docker rm jb5 ;;
		jb6) docker rm jb6 ;;
		*) echo "Unknown container $1" 1>&2;;
	esac
}

cmd=$1
arg=${2:-all}

[ -n "$cmd" ] || { usage; exit 2; }


case ${1:-none} in
	start) c_start $arg ;;
	stop) c_stop $arg ;;
	rm) c_rm $arg ;;
	status) docker ps ;;
	*) usage; exit 2 ;;
esac

