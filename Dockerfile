FROM brettt89/silverstripe-web-base:dev

# Install CWP dependencies
RUN apt-get update -y && apt-get install -y \
	libapache2-mod-rpaf \
	mysql-server \
	php5-apcu

# Disable default apache configuration
RUN a2dissite -q 000-default
RUN a2dismod -f autoindex && a2enmod expires remoteip cgid

# Site name & directory setup
ENV SITE_DIR=/sites/cwp
ENV WEB_DIR=$SITE_DIR/www
ENV LOG_DIR=$SITE_DIR/logs
# Replace default apache configuration
COPY defaults/site.conf /etc/apache2/sites-available/cwp.conf
COPY defaults/_ss_environment.php $SITE_DIR/_ss_environment.php
COPY scripts/startup.sh /root/startup.sh

# Install Apache configuration
RUN mkdir --parents $WEB_DIR $LOG_DIR /root/scripts \
        && chown --recursive www-data:www-data /sites /var/www \
	&& chmod 755 /root/startup.sh \
        && a2ensite cwp
ENTRYPOINT /bin/bash /root/startup.sh
