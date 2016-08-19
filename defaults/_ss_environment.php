<?php

/* Change this from 'dev' to 'live' for a production environment. */
define('SS_ENVIRONMENT_TYPE', 'dev');
define('SS_ENVIRONMENT_STYLE', 'single');
define('SS_ENVIRONMENT_ID', '$DEFAULT_NAME');

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
$_FILE_TO_URL_MAPPING['/sites/$DEFAULT_NAME/www'] = 'http://localhost';

