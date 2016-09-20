#!/bin/bash

## Arguments
## Change the container name if you updated docker container name
## docker command: docker exec $CONTAINER script -q /dev/null -c "cd \"${WEB_DIR}\" && rm -Rf *"
CONTAINER="web-cwp"

WEB_DIR="/sites/cwp/www"
COMPOSER_PHPUNIT="${WEB_DIR}/vendor/phpunit/phpunit"
PHPUNIT="/usr/local/bin/phpunit"

docker exec $CONTAINER script -q /dev/null -c "cd ${WEB_DIR} && 
if [ -f ${COMPOSER_PHPUNIT} ];
then
  ${COMPOSER_PHPUNIT} "$@"
else
  ${PHPUNIT} "$@"
fi"
