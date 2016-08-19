#!/bin/bash
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -r|--repo)
    REPO="$2"
    shift # past argument
    ;;
    -b|--branch)
    BRANCH="$2"
    shift # past argument
    ;;
    -w|--web)
    WEB_DIR="$2"
    shift # past argument
    ;;
    --default)
    DEFAULT=YES
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done
cd "${WEB_DIR}" \
	&& git clone --branch "${BRANCH}" "${REPO}" "${WEB_DIR}" \
        && COMPOSER_PROCESS_TIMEOUT=2000 composer install --prefer-dist \
	&& chown -R www-data:www-data /sites \
	&& service apache2 restart \
	&& service mysql restart \
su - www-data -s /bin/bash -c "php -f ${WEB_DIR}/framework/cli-script.php dev/build"
/bin/bash
