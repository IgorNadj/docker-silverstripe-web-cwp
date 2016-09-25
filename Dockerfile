FROM brettt89/silverstripe-web-base:version1.1
ENV DEBIAN_FRONTEND=noninteractive

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
ENV SSPAK_DIR=$SITE_DIR/sspaks

RUN mkdir --parents $WEB_DIR $LOG_DIR $SSPAK_DIR /root/scripts

# Replace default apache configuration
COPY defaults/site.conf /etc/apache2/sites-available/cwp.conf
COPY defaults/_ss_environment.php $SITE_DIR/_ss_environment.php
COPY scripts /root/

RUN chmod 755 /root/*.sh
RUN ln -s /root/fix-permissions.sh $SITE_DIR/
RUN a2ensite cwp

VOLUME ["/var/lib/mysql", "/sites/cwp/logs", "/sites/cwp/sspaks"]
ENTRYPOINT /bin/bash /root/startup.sh  
