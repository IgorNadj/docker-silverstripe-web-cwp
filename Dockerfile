FROM brettt89/silverstripe-web-base:dev

# Install CWP dependencies
RUN apt-get update -y && apt-get install -y \
	libapache2-mod-rpaf \
	lsyncd \
	mysql-server \
	php5-apcu

# Disable default apache configuration
RUN a2dissite -q 000-default
RUN a2dismod -f autoindex && a2enmod expires remoteip cgid

# Site name & directory setup
ENV SITE_DIR=/sites/cwp
ENV WEB_DIR=$SITE_DIR/www
ENV LOG_DIR=$SITE_DIR/logs
ENV SCRIPTS_DIR=/sites/scripts

RUN mkdir --parents $WEB_DIR $LOG_DIR $SCRIPTS_DIR /root/scripts

# Replace default apache configuration
COPY defaults/site.conf /etc/apache2/sites-available/cwp.conf
COPY defaults/_ss_environment.php $SITE_DIR/_ss_environment.php
COPY scripts /root/

# Install Apache configuration
RUN chown --recursive www-data:www-data $SITE_DIR \
	&& chmod 755 /root/startup.sh $SCRIPTS_DIR 
RUN a2ensite cwp
ENTRYPOINT /bin/bash /root/startup.sh 
