#!/bin/bash
##########################################################
##                                                      ##
##                                                      ##
##           !!!   DO NOT RUN THIS FILE   !!!           ##
##                                                      ##
##                                                      ##
##########################################################

service apache2 restart > /dev/null 2>&1
service mysql restart > /dev/null 2>&1
lsyncd -rsync /sites/src /sites/cwp/www/
cp -f /root/deploy.sh /sites/scripts/deploy.sh
cp -f /root/sspak.sh /sites/scripts/sspak.sh
echo "Webserver is ready 

 Build Database:
  http://localhost:8888/dev/build

 Your Website:
  http://localhost:8888

 Database Connection Details:
  host: locahost
  port: 333806
  user: root
  pass: <blank>

 Scripts and SSPAKs can be found:
  /silverstripe/web-cwp/scripts
  /silverstripe/web-cwp/sspak"
tail -f /dev/null
