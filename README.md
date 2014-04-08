# Intro

It is a development environment for jboss and splunk. It contains docker definition files.

# Usage

1. Download necessary files - see filelist.txt

2. Build images for each of containers 

	for c in jboss5 splunk;do
	  docker build -t $c $c
	done

3. Copy ta-jboss and jboss_inside sources to src/

4. Start containers with a script

	sudo ./manage.sh start


