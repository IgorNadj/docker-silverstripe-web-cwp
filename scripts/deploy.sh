#!/bin/bash

CONTAINER="web-cwp"

## Check if web-server is running
RUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER 2> /dev/null)

if [ $? -eq 1 ]; then
  echo "ERROR:- $CONTAINER does not exist.
Make sure you have started the docker containers"
  exit 1
fi

if [ "$RUNNING" == "false" ]; then
  echo "ERROR:- $CONTAINER is not running.
Make sure you have started the docker containers"
  exit 1
fi

STARTED=$(docker inspect --format="{{ .State.StartedAt }}" $CONTAINER)
NETWORK=$(docker inspect --format="{{ .NetworkSettings.IPAddress }}" $CONTAINER)

echo "OK - $CONTAINER is running. IP: $NETWORK, StartedAt: $STARTED"

WEB_DIR="/sites/cwp/www"
REPO_DIR="/sites/src"

docker exec $CONTAINER script -q /dev/null -c "cd \"${WEB_DIR}\" && rm -Rf *"
docker exec $CONTAINER script -q /dev/null -c "cp -Rf ${REPO_DIR}/* ${WEB_DIR}/"
docker exec $CONTAINER script -q /dev/null -c "cd \"${WEB_DIR}\" \
        && mv composer.lock composer.lock.bak \
        && cat composer.lock.bak | jq '
def walk(f):
  . as \$in
  | if type == \"object\" then
      reduce keys[] as \$key
        ( {}; . + { (\$key):  (\$in[\$key] | walk(f)) } ) | f
  elif type == \"array\" then map( walk(f) ) | f
  else f
  end;

def mapper(f):
  if type == \"array\" then map(f)
  elif type == \"object\" then
  . as \$in
  | reduce keys[] as \$key
      ({};
       [\$in[\$key] | f ] as \$value
       | if \$value | length == 0 then . 
         else . + {(\$key): \$value[0]} end)
  else .
  end;
walk( mapper(select((type == \"object\" and .name == \"silverstripe/fulltextsearch-localsolr\") | not )) )' >> composer.lock \
        && COMPOSER_PROCESS_TIMEOUT=2000 composer -n install"
docker exec $CONTAINER script -q /dev/null -c "chown -R www-data:www-data /sites/cwp/"
docker exec $CONTAINER script -q /dev/null -c "su - www-data -s /bin/bash -c \"/usr/bin/php ${WEB_DIR}/framework/cli-script.php dev/build\""
