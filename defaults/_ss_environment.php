<?php

/* Change this from 'dev' to 'live' for a production environment. */
define('SS_ENVIRONMENT_TYPE', 'dev');
define('SS_ENVIRONMENT_STYLE', 'single');
define('SS_ENVIRONMENT_ID', 'cwp');

define('SS_SESSION_KEY', 'pGF41g5hcbgVrY1c0S1kDqPP');

/* This defines a default database user */
define('SS_DATABASE_SERVER', 'localhost');
define('SS_DATABASE_USERNAME', 'root');
define('SS_DATABASE_PASSWORD', '');
define('SS_DATABASE_NAME', 'SS_cwp');

define('SS_DEFAULT_ADMIN_USERNAME', 'admin');
define('SS_DEFAULT_ADMIN_PASSWORD', 'password');

define('SS_SEND_ALL_EMAILS_TO', '');

global $_FILE_TO_URL_MAPPING;
$_FILE_TO_URL_MAPPING['/sites/cwp/www'] = 'http://localhost';

define('SOLR_SERVER', 'default-solr:password@solr-cwp');
define('SOLR_PORT', '80');
define('SOLR_PATH', '/default-solr');
define('SOLR_MODE', 'webdav');
define('SOLR_REMOTEPATH', '/default-solr');
define('SOLR_INDEXSTORE_PATH', '/default-solr/webdav');
