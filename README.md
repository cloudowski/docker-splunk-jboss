# Intro

It is a development environment for jboss and splunk. It contains docker definition files.

# Usage

1. Download necessary files - see filelist.txt. 
2. Build images for all containers 

`
    ./manage.sh build all
`

or selected

`
	for c in jboss{5,6} splunk;do
	  ./manage sh build $c
	done
`

3. Copy ta-jboss and jboss_inside sources to src/
4. Start containers with a script

`
	./manage.sh start splunk
`

See **splunk/README.txt** for details on how to control splunk configuration using environment variables.

