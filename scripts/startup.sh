#!/bin/bash
##########################################################
##                                                      ##
##                                                      ##
##           !!!   DO NOT RUN THIS FILE   !!!           ##
##                                                      ##
##                                                      ##
##########################################################

set -e
NETWORK_PUBLISH_HOST=${NETWORK_PUBLISH_HOST:-`/sbin/ip route|awk '/src/ { print $9 }'`}

service apache2 start > /dev/null 2>&1
service mysql start > /dev/null 2>&1

echo "Webserver is ready"
echo "http://$NETWORK_PUBLISH_HOST/"

tail -f /dev/null
