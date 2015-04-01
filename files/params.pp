# == Class: maas::params
#
#
# === Parameters
#
# === Variables
#
# [*cloud_archive_release*]
#   Release of the Cloud-archive:tools to use for maas packages
#   Default is currently the OpenStack Juno release
#
# [*maas_packages*]
#   Default MAAS Packages to install
#
# [*maas_root_user*]
#   Default MAAS Root Username
#
# [*maas_root_user_email*]
#   Default MAAS Root User email address
#
# [*maas_root_password*]
#   Password for the MAAS Root Account
#
# [*maas_profile_name*]
#   The name with which you will later refer to this
#   remote server and credentials within this tool.
#
# [*maas_server_url*]
#   The URL of the remote API, e.g. http://example.com/MAAS/
#   or http://example.com/MAAS/api/1.0/ if you wish to specify the API version.
#
# [*maas_api_version*]
#   Version of the MAAS API to use.   Default is 1.0.
#
# [*maas_db_name*]
#   Default maas database name: maasdb
#
# [*maas_db_user*]
#   Default maas db username: maas
#
# [*maas_db_passwd*]
#   Maas database password
#
# [*maas_db_host*]
#   MAAS db Host address
#
# [*maas_api_key*]
#   The credentials, also known as the API key, for the remote
#   MAAS server. These can be found in the user preferences page
#   in the web UI; they take the form of a long random-looking
#   string composed of three parts, separated by colons.
#
# [*maas_cluster_uuid*]
#   The UUID of for the  MAAS Cluster
#
# [*maas_local_celeryconfig_user*]
#   Default setting = 'maas_workers'
#
# [*maas_local_celeryconfig_passwd*]
#   Default setting = 'I2c8Fsw14gySkiT9COSx'
#
# [*maas_local_celeryconfig_vhost*]
#   Default vhost setting  = '/maas_workers'
#
# [*maas_txlongpoll_frontend_port*]
#   Default Port used for the MAAS txlongpoll frontend service
#   The default Uses 5242
#
# [*maas_txlongpoll_prefix*]
#   If specified, queue names requested must have the given prefix.
#
# [*maas_txlongpoll_oops_dir*]
#   Directory in which to place OOPS reports.  Must not contain any files
#   or directories other than what the oops machinery creates there.
#   default directory: "/var/log/maas/oops"
#
# [*maas_txlongpoll_oops_reporter*]
#   The reporter used when generating OOPS reports.
#   Default reporter: "maas-txlongpoll"
#
# [*maas_txlongpoll_broker_host*]
#   Default Broker host: "localhost"
#
# [*maas_txlongpoll_broker_port*]
#   Default broker port: 5672
#
# [*maas_txlongpoll_broker_user*]
#   Default broker username: "maas_longpoll"
#
# [*maas_txlongpoll_broker_passwd*]
#   Default broker password: "w0hAKHs8ZGUhHuAyOzge"
#
# [*maas_txlongpoll_broker_vhost*]
#   Default broker vhost: "/maas_longpoll"
#
# [*maas_txlongpoll_logfile*]
#   Where to log the txlongpoll server to. This log can be rotated by sending SIGUSR1 to the
#   running server.
#   Default logfile: "/var/log/maas/txlongpoll.log"
#
# [*maas_pserv_logfile*]
#    Where to log the provisioning server to. This log can be rotated by sending SIGUSR1 to the
#    running server.
#    Default provisioning server logfile: "/var/log/maas/pserv.log"
#
# [*maas_pserv_oops_reporter*]
#   The reporter used when generating provisioning server OOPS reports.
#   Default reporter: "maas-pserv"
#
# [*maas_pserv_oops_dir*]
#   Directory in which to place OOPS reports.  Must not contain any files
#   or directories other than what the oops machinery creates there.
#   default directory: "/var/log/maas/oops"
#
# [*maas_pserv_broker_host*]
#   Default Broker host: "localhost"
#
# [*maas_pserv_broker_port*]
#   Default broker port: 5673
#
# [*maas_pserv_broker_user*]
#   Default broker username: "maas_pserv"
#
# [*maas_pserv_resource_root*]
#   The tftp "root" setting has been replaced by "resource_root".  The old setting
#   is used one final time when upgrading a pre-14.04 cluster controller to a
#   14.04 version.  After that upgrade, it can be removed.
#   Default resource_root: /var/lib/maas/boot-resources/current/
#
# [*maas_pserv_tftp_port*]
#   Default TFTP port 69
#
# [*maas_boot_resource_storage*]
#
# [*maas_boot_resource_url*]
#
# [*maas_default_cloudimage_keyring*]
#
# [*maas_media_root*]
#   Where to store the user uploaded files.
#   Default MEDIA_ROOT = '/var/lib/maas/media/'
#
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class maas::params {
  case $operatingsystem {
    'Ubuntu':{
      case $operatingsystemrelease {
        '14.04':{
          $version            = undef
          $ensure             = present 
          $prerequired_packages          = undef
          $cloud_archive_release         = 'juno'
          $maas_root_user             = 'root'
          $maas_root_password            = 'maas'
          $maas_root_user_email          = "root@${::fqdn}"

          $maas_profile_name             = "${::fqdn}"
          $maas_server_url            = "http://${::ipaddress}/MAAS"
          $maas_api_version              = '1.0'
          $maas_api_key               = undef
          $maas_cluster_uuid             = undef

          $maas_root_directories   = [
             '/etc/maas',
             '/etc/maas/templates',
             '/etc/maas/preseeds',
             '/usr/share/maas',
             '/var/lib/maas']

          # Default Settings
          $maas_debug_mode         = 'False' 
          $maas_media_root         = '/var/lib/maas/media/'
          $maas_db_engine          = 'django.db.backends.postgresql_psycopg2'
          $maas_db_name            = 'maasdb'
          $maas_db_user            = 'maas'
          $maas_db_passwd          = 'ky460LTuLfIl'
          $maas_db_host            = 'localhost'


          $maas_local_celeryconfig_user   = 'maas_workers'
          $maas_local_celeryconfig_passwd = 'I2c8Fsw14gySkiT9COSx'
          $maas_local_celeryconfig_vhost  = '/maas_workers'


          # MAAS TXLONGPOLL 
          $maas_txlongpoll_config_file   = '/etc/maas/txlongpoll.yaml'
          $maas_txlongpoll_initi_file    = '/etc/init/maas-txlongpoll.conf'
          $maas_txlongpoll_frontend_port = '5242'
          $maas_txlongpoll_prefix        = undef
          $maas_txlongpoll_oops_dir      = '/var/log/maas/oops'
          $maas_txlongpoll_oops_reporter = 'maas-txlongpoll'
          $maas_txlongpoll_broker_host   = 'localhost'
          $maas_txlongpoll_broker_port   = '5672'
          $maas_txlongpoll_broker_user   = 'maas_longpoll'
          $maas_txlongpoll_broker_passwd = 'w0hAKHs8ZGUhHuAyOzge' 
          $maas_txlongpoll_broker_vhost  = '/maas_longpoll'
          $maas_txlongpoll_logfile       = '/var/log/maas/txlongpoll.log'

          # MAAS Provisioning Server
          $maas_pserv_config_file     = '/etc/maas/pserv.yaml'
          $maas_pserv_initi_file      = '/etc/init/maas-pserv.conf'
          $maas_pserv_oops_dir        = '/var/log/maas/oops'
          $maas_pserv_oops_reporter   = 'maas-pserv'
          $maas_pserv_broker_host     = 'localhost'
          $maas_pserv_broker_port     = '5673'
          $maas_pserv_broker_user     = '<current_user>'
          $maas_pserv_broker_passwd   = 'test' 
          $maas_pserv_broker_vhost    = '/'
          $maas_pserv_logfile         = '/var/log/maas/pserv.log'
          $maas_pserv_resource_root   = '/var/lib/maas/boot-resources/current'
          $maas_pserv_tftp_port       = '69'
          $maas_boot_resource_storage = '/var/lib/maas/boot-resources/' 
          $maas_boot_resource_url     = 'http://maas.ubuntu.com/images/ephemeral-v2/releases/' 
          $maas_default_cloudimage_keyring = '/usr/share/keyrings/ubuntu-cloudimage-keyring.gpg'
 




          # Installed MAAS Packages
          #   maas              - MAAS server all-in-one metapackage
          # A maas-cli             - MAAS command line API tool
          # A maas-cluster-controller         - MAAS server cluster controller
          # A maas-common            - MAAS server common files
          # A maas-dhcp            - MAAS DHCP server
          # A maas-dns             - MAAS DNS server
          # A maas-region-controller          - MAAS server complete region controller
          # A maas-region-controller-min      - MAAS Server minimum region controller
          # A python-django-maas              - MAAS server Django web framework
          # A python-maas-client              - MAAS python API client
          # A python-maas-provisioningserver  - MAAS server provisioning libraries

          $maas_packages  = [
            'python-maas-provisioningserver',
            'maas-dhcp',
            'maas-dns',
            'maas-common',
            'maas-cli',
            'maas',
            'maas-region-controller',
            'maas-cluster-controller',
            'python-django-maas',
            'maas-region-controller-min']

          $region_controller_new_packages = [
            'apache2',
            'apache2-bin',
            'apache2-data',
            'avahi-daemon',
            'avahi-utils',
            'bind9',
            'bind9utils',
            'curtin-common',
            'dbconfig-common',
            'distro-info-data',
            'docutils-common',
            'docutils-doc',
            'erlang-asn1',
            'erlang-base',
            'erlang-corba',
            'erlang-crypto',
            'erlang-diameter',
            'erlang-edoc',
            'erlang-eldap',
            'erlang-erl-docgen',
            'erlang-eunit',
            'erlang-ic',
            'erlang-inets',
            'erlang-mnesia',
            'erlang-nox',
            'erlang-odbc',
            'erlang-os-mon',
            'erlang-parsetools',
            'erlang-percept',
            'erlang-public-key',
            'erlang-runtime-tools',
            'erlang-snmp',
            'erlang-ssh',
            'erlang-ssl',
            'erlang-syntax-tools',
            'erlang-tools',
            'erlang-webtool',
            'erlang-xmerl',
            'ieee-data',
            'iproute',
            'libapache2-mod-wsgi',
            'libapr1',
            'libaprutil1',
            'libaprutil1-dbd-sqlite3',
            'libaprutil1-ldap',
            'libavahi-client3',
            'libavahi-common-data',
            'libavahi-common3',
            'libavahi-core7',
            'libdaemon0',
            'libecap2',
            'libjbig0',
            'libjpeg-turbo8',
            'libjpeg8',
            'libjs-jquery',
            'libjs-raphael',
            'libjs-sphinxdoc',
            'libjs-underscore',
            'libjs-yui3-common',
            'libjs-yui3-full',
            'libjs-yui3-min',
            'liblcms2-2',
            'libltdl7',
            'libmnl0',
            'libnetfilter-conntrack3',
            'libnss-mdns',
            'libodbc1',
            'libpaper-utils',
            'libpaper1',
            'libpython2.7',
            'libsctp1',
            'libtiff5',
            'libwebp5',
            'libwebpmux1',
            'libxslt1.1',
            'lksctp-tools',
            'maas-common',
            'maas-dns',
            'maas-region-controller',
            'maas-region-controller-min',
            'postgresql',
            'pwgen',
            'python-amqp',
            'python-amqplib',
            'python-anyjson',
            'python-babel',
            'python-babel-localedata',
            'python-billiard',
            'python-boto',
            'python-bson',
            'python-bson-ext',
            'python-celery',
            'python-cl',
            'python-convoy',
            'python-crochet',
            'python-crypto',
            'python-curtin',
            'python-dateutil',
            'python-dbus',
            'python-dbus-dev',
            'python-decorator',
            'python-distro-info',
            'python-django',
            'python-django-maas',
            'python-django-piston',
            'python-django-south',
            'python-djorm-ext-pgarray',
            'python-dns',
            'python-docutils',
            'python-ecdsa',
            'python-egenix-mxdatetime',
            'python-egenix-mxtools',
            'python-formencode',
            'python-gi',
            'python-httplib2',
            'python-iscpy',
            'python-iso8601',
            'python-jinja2',
            'python-jsonschema',
            'python-keyring',
            'python-kombu',
            'python-launchpadlib',
            'python-lazr.restfulclient',
            'python-lazr.uri',
            'python-lockfile',
            'python-lxml',
            'python-maas-client',
            'python-maas-provisioningserver',
            'python-mailer',
            'python-markupsafe',
            'python-memcache',
            'python-mock',
            'python-netaddr',
            'python-netifaces',
            'python-oauth',
            'python-oops',
            'python-oops-amqp',
            'python-oops-datedir-repo',
            'python-oops-twisted',
            'python-oops-wsgi',
            'python-openid',
            'python-openssl',
            'python-pam',
            'python-paramiko',
            'python-paste',
            'python-pbr',
            'python-pexpect',
            'python-pil',
            'python-pkg-resources',
            'python-prettytable',
            'python-psycopg2',
            'python-pyasn1',
            'python-pygments',
            'python-pyparsing',
            'python-roman',
            'python-scgi',
            'python-seamicroclient',
            'python-secretstorage',
            'python-serial',
            'python-setuptools',
            'python-simplejson',
            'python-simplestreams',
            'python-sphinx',
            'python-tempita',
            'python-twisted',
            'python-twisted-bin',
            'python-twisted-conch',
            'python-twisted-core',
            'python-twisted-lore',
            'python-twisted-mail',
            'python-twisted-names',
            'python-twisted-news',
            'python-twisted-runner',
            'python-twisted-web',
            'python-twisted-words',
            'python-txamqp',
            'python-txlongpoll',
            'python-txtftp',
            'python-tz',
            'python-wadllib',
            'python-yaml',
            'python-zope.interface',
            'rabbitmq-server',
            'sphinx-common',
            'sphinx-doc',
            'squid-deb-proxy',
            'squid-langpack',
            'squid3',
            'squid3-common']

      $region_controller_suggested_packages = [
            'www-browser',
            'apache2-doc',
            'apache2-suexec-pristine',
            'apache2-suexec-custom',
            'apache2-utils',
            'avahi-autoipd',
            'bind9-doc',
            'erlang',
            'erlang-manpages',
            'erlang-doc',
            'xsltproc',
            'fop',
            'erlang-ic-java',
            'erlang-observer',
            'javascript-common',
            'liblcms2-utils',
            'libmyodbc',
            'odbc-postgresql',
            'tdsodbc',
            'unixodbc-bin',
            'python-amqp-doc',
            'python-amqplib-doc',
            'python-billiard-doc',
            'python-gevent',
            'python-pytyrant',
            'python-redis',
            'python-sqlalchemy',
            'python-celery-doc',
            'python-crypto-dbg',
            'python-crypto-doc',
            'python-dbus-doc',
            'python-dbus-dbg',
            'python-psycopg',
            'python-mysqldb',
            'python-flup',
            'python-sqlite',
            'geoip-database-contrib',
            'gettext',
            'python-django-doc',
            'ipython',
            'bpython',
            'libgdal1',
            'texlive-latex-recommended',
            'texlive-latex-base',
            'texlive-lang-french',
            'fonts-linuxlibertine',
            'ttf-linux-libertine',
            'python-egenix-mxdatetime-dbg',
            'python-egenix-mxdatetime-doc',
            'python-egenix-mxtools-dbg',
            'python-egenix-mxtools-doc',
            'python-gi-cairo',
            'python-jinja2-doc',
            'gir1.2-gnomekeyring-1.0',
            'python-gdata',
            'python-keyczar',
            'python-kde4',
            'python-beanstalkc',
            'python-kombu-doc',
            'python-pika',
            'python-pymongo',
            'python-testresources',
            'python-lxml-dbg',
            'memcached',
            'python-mock-doc',
            'python-netaddr-docs',
            'python-openssl-doc',
            'python-openssl-dbg',
            'python-pam-dbg',
            'python-pastedeploy',
            'python-pastescript',
            'python-pastewebkit',
            'libjs-mochikit',
            'libapache2-mod-python',
            'libapache2-mod-scgi',
            'python-pgsql',
            'python-pexpect-doc',
            'python-pil-doc',
            'python-pil-dbg',
            'python-distribute',
            'python-distribute-doc',
            'python-psycopg2-doc',
            'doc-base',
            'ttf-bitstream-vera',
            'gnome-keyring',
            'python-secretstorage-doc',
            'python-wxgtk2.8',
            'python-wxgtk',
            'jsmath',
            'libjs-mathjax',
            'dvipng',
            'texlive-latex-extra',
            'texlive-fonts-recommended',
            'python-twisted-bin-dbg',
            'python-tk',
            'python-gtk2',
            'python-glade2',
            'python-qt3',
            'python-twisted-runner-dbg',
            'squidclient',
            'squid-cgi',
            'squid-purge',
            'smbclient',
            'winbindd']

     $region_controller_extrapackages = [ 
               'apache2',
               'apache2-bin',
               'apache2-data',
               'avahi-daemon',
               'avahi-utils',
               'bind9',
               'bind9utils',
               'curtin-common',
               'dbconfig-common',
               'distro-info-data',
               'docutils-common',
               'docutils-doc',
               'erlang-asn1',
               'erlang-base',
               'erlang-corba',
               'erlang-crypto',
               'erlang-diameter',
               'erlang-edoc',
               'erlang-eldap',
               'erlang-erl-docgen',
               'erlang-eunit',
               'erlang-ic',
               'erlang-inets',
               'erlang-mnesia',
               'erlang-nox',
               'erlang-odbc',
               'erlang-os-mon',
               'erlang-parsetools',
               'erlang-percept',
               'erlang-public-key',
               'erlang-runtime-tools',
               'erlang-snmp',
               'erlang-ssh',
               'erlang-ssl',
               'erlang-syntax-tools',
               'erlang-tools',
               'erlang-webtool',
               'erlang-xmerl',
               'ieee-data',
               'iproute',
               'libapache2-mod-wsgi',
               'libapr1',
               'libaprutil1',
               'libaprutil1-dbd-sqlite3',
               'libaprutil1-ldap',
               'libavahi-client3',
               'libavahi-common-data',
               'libavahi-common3',
               'libavahi-core7',
               'libdaemon0',
               'libecap2',
               'libjbig0',
               'libjpeg-turbo8',
               'libjpeg8',
               'libjs-jquery',
               'libjs-raphael',
               'libjs-sphinxdoc',
               'libjs-underscore',
               'libjs-yui3-common',
               'libjs-yui3-full',
               'libjs-yui3-min',
               'liblcms2-2',
               'libltdl7',
               'libmnl0',
               'libnetfilter-conntrack3',
               'libnss-mdns',
               'libodbc1',
               'libpaper-utils',
               'libpaper1',
               'libpython2.7',
               'libsctp1',
               'libtiff5',
               'libwebp5',
               'libwebpmux1',
               'libxslt1.1',
               'lksctp-tools',
               'maas-common',
               'maas-dns',
               'maas-region-controller-min',
               'postgresql',
               'pwgen',
               'python-amqp',
               'python-amqplib',
               'python-anyjson',
               'python-babel',
               'python-babel-localedata',
               'python-billiard',
               'python-boto',
               'python-bson',
               'python-bson-ext',
               'python-celery',
               'python-cl',
               'python-convoy',
               'python-crochet',
               'python-crypto',
               'python-curtin',
               'python-dateutil',
               'python-dbus',
               'python-dbus-dev',
               'python-decorator',
               'python-distro-info',
               'python-django',
               'python-django-maas',
               'python-django-piston',
               'python-django-south',
               'python-djorm-ext-pgarray',
               'python-dns',
               'python-docutils',
               'python-ecdsa',
               'python-egenix-mxdatetime',
               'python-egenix-mxtools',
               'python-formencode',
               'python-gi',
               'python-httplib2',
               'python-iscpy',
               'python-iso8601',
               'python-jinja2',
               'python-jsonschema',
               'python-keyring',
               'python-kombu',
               'python-launchpadlib',
               'python-lazr.restfulclient',
               'python-lazr.uri',
               'python-lockfile',
               'python-lxml',
               'python-maas-client',
               'python-maas-provisioningserver',
               'python-mailer',
               'python-markupsafe',
               'python-memcache',
               'python-mock',
               'python-netaddr',
               'python-netifaces',
               'python-oauth',
               'python-oops',
               'python-oops-amqp',
               'python-oops-datedir-repo',
               'python-oops-twisted',
               'python-oops-wsgi',
               'python-openid',
               'python-openssl',
               'python-pam',
               'python-paramiko',
               'python-paste',
               'python-pbr',
               'python-pexpect',
               'python-pil',
               'python-pkg-resources',
               'python-prettytable',
               'python-psycopg2',
               'python-pyasn1',
               'python-pygments',
               'python-pyparsing',
               'python-roman',
               'python-scgi',
               'python-seamicroclient',
               'python-secretstorage',
               'python-serial',
               'python-setuptools',
               'python-simplejson',
               'python-simplestreams',
               'python-sphinx',
               'python-tempita',
               'python-twisted',
               'python-twisted-bin',
               'python-twisted-conch',
               'python-twisted-core',
               'python-twisted-lore',
               'python-twisted-mail',
               'python-twisted-names',
               'python-twisted-news',
               'python-twisted-runner',
               'python-twisted-web',
               'python-twisted-words',
               'python-txamqp',
               'python-txlongpoll',
               'python-txtftp',
               'python-tz',
               'python-wadllib',
               'python-yaml',
               'python-zope.interface',
               'rabbitmq-server',
               'sphinx-common',
               'sphinx-doc',
               'squid-deb-proxy',
               'squid-langpack',
               'squid3',
               'squid3-common']

        }

        default:{
          warning("This is currently untested on your ${operatingsystemrelease}")
        }
      }
    }
    default:{
      warning("This is not meant for this ${operatingsystem}")
    }
  }
}

