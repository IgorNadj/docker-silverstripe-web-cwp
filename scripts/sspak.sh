#!/bin/bash

## Arguments
## Change the container name if you updated docker container name
CONTAINER="web-cwp"


SITE_DIR="/sites/cwp/www"
SSPAK_DIR="/sites/sspak"
USAGE="######################
 HOW TO USE:
######################
  ./$(basename "$0") <command> <file>

 Load an SSPAK
 - Copy file to /silverstripe/$CONTAINER/sspak/
  ./sspak.sh load site.sspak
  ./sspak.sh load --db site.sspak       	(Database only)
  ./sspak.sh load --assets site.sspak		(Assets only)


 Save an SSPAK
  ./sspak.sh save site.sspak
  ./sspak.sh save --db site			(Database only)
  ./sspak.sh save --assets site			(Assets only)"
EXTRA_CMD=""


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

if [[ -n $1 && -n $2 ]]; then
    case "$1" in
	--db)
	    EXTRA_CMD="--db"
	    shift 1;
	    ;;
	--assets)
	    EXTRA_CMD="--assets"
	    shift 1;
	    ;;
    esac

    # Commands
    case "$1" in
        load)
	    echo "Restoring snapshot $2 into $CONTAINER ..."
            docker exec $CONTAINER script -q /dev/null -c "sspak load $EXTRA_CMD \"${SSPAK_DIR}/$2\" \"${SITE_DIR}\""
	    echo "Restoration Completed"
	    exit 1
	    ;;
	save)
	    echo "Creating snapshot $2.sspak"
	    docker exec $CONTAINER script -q /dev/null -c "sspak save $EXTRA_CMD \"${SITE_DIR}\" \"${SSPAK_DIR}/$2.sspak\""
	    echo "Snapshot completed /silverstripe/web-cwp/sspak/$2.sspak"
	    exit 1
	    ;;
	*)
	;;
    esac
fi

echo "$USAGE" >&2
exit 1
