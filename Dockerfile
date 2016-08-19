FROM brettt89/silverstripe-web

# Disable default apache configuration
RUN a2dissite -q 000-default

# Site name & directory setup
ENV DEFAULT_NAME="cwp-dev"
ENV SITE_DIR=/sites/$DEFAULT_NAME
ENV WEB_DIR=$SITE_DIR/www
ENV LOG_DIR=$SITE_DIR/logs
# Replace default apache configuration
COPY defaults/site.conf /etc/apache2/sites-available/$DEFAULT_NAME.conf
COPY defaults/_ss_environment.php $SITE_DIR/_ss_environment.php
COPY scripts/startup.sh /tmp/startup.sh
RUN sed -i "s/\$DEFAULT_NAME/$DEFAULT_NAME/g" $SITE_DIR/_ss_environment.php \
	&& sed -i "s/\$NAME/$DEFAULT_NAME/g" /etc/apache2/sites-available/$DEFAULT_NAME.conf

# Install Apache configuration
RUN mkdir --parents $WEB_DIR $LOG_DIR \
        && chown --recursive www-data:www-data /sites /var/www \
	&& chmod 755 /tmp/startup.sh \
        && a2ensite $DEFAULT_NAME

# Install Repository and build
ARG repo=$DEFAULT_REPO
ARG branch=$DEFAULT_BRANCH
ENV REPO=${repo:-"https://gitlab.cwp.govt.nz/brett.tasker/cwp-dev-web.git"}
ENV BRANCH=${branch:-"master"}

# Expose Network
EXPOSE 80
ENTRYPOINT ["sh", "-c", "/tmp/startup.sh", "-r", "$REPO", "-b", "$BRANCH", "-w", "$WEB_DIR"]
