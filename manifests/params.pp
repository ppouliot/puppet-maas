# Class: maas::params
# ===================
#
# Variables
# ---------
#
# * `cloud_archive_release`
# Release of the Cloud-archive:tools to use for maas packages
# Default is currently the OpenStack Juno release
# Valid options are 'icehouse','juno', and 'kilo'.
#
# * `maas_packages`
# Default MAAS Packages to install
#
# * `default_superuser`
# Default MAAS SuperUser Username
#
# * `default_superuser_email`
# Default MAAS SuperUser email address
#
# * `default_superuser_password`
# Password for the MAAS Root Account
#
# * `profile_name`
# The name with which you will later refer to this
# remote server and credentials within this tool.
#
# * `server_url`
# The URL of the remote API, e.g. http://example.com/MAAS/
# or http://example.com/MAAS/api/1.0/ if you wish to specify the API version.
#
# * `api_version`
# Version of the MAAS API to use.   Default is 1.0.
#
# * `maas_db_name`
# Default maas database name: maasdb
#
# * `maas_db_user`
# Default maas db username: maas
#
# * `maas_db_passwd`
# Maas database password
#
# * `maas_db_host`
# MAAS db Host address
#
# * `maas_api_key`
# The credentials, also known as the API key, for the remote
# MAAS server. These can be found in the user preferences page
# in the web UI; they take the form of a long random-looking
# string composed of three parts, separated by colons.
#
# * `maas_cluster_uuid`
# The UUID of for the  MAAS Cluster
#
# * `maas_local_celeryconfig_user`
# Default setting = 'maas_workers'
#
# * `maas_local_celeryconfig_passwd`
# Default setting = 'I2c8Fsw14gySkiT9COSx'
#
# * `maas_local_celeryconfig_vhost`
# Default vhost setting  = '/maas_workers'
#
# * `maas_txlongpoll_frontend_port`
# Default Port used for the MAAS txlongpoll frontend service
# The default Uses 5242
#
# * `maas_txlongpoll_prefix`
# If specified, queue names requested must have the given prefix.
#
# * `maas_txlongpoll_oops_dir`
# Directory in which to place OOPS reports.  Must not contain any files
# or directories other than what the oops machinery creates there.
# default directory: "/var/log/maas/oops"
#
# * `maas_txlongpoll_oops_reporter`
# The reporter used when generating OOPS reports.
# Default reporter: "maas-txlongpoll"
#
# * `maas_txlongpoll_broker_host`
# Default Broker host: "localhost"
#
# * `maas_txlongpoll_broker_port`
# Default broker port: 5672
#
# * `maas_txlongpoll_broker_user`
# Default broker username: "maas_longpoll"
#
# * `maas_txlongpoll_broker_passwd`
# Default broker password: "w0hAKHs8ZGUhHuAyOzge"
#
# * `maas_txlongpoll_broker_vhost`
# Default broker vhost: "/maas_longpoll"
#
# * `maas_txlongpoll_logfile`
# Where to log the txlongpoll server to. This log can be rotated by sending SIGUSR1 to the
# running server.
# Default logfile: "/var/log/maas/txlongpoll.log"
#
# * `maas_pserv_logfile`
# Where to log the provisioning server to. This log can be rotated by sending SIGUSR1 to the
# running server.
# Default provisioning server logfile: "/var/log/maas/pserv.log"
#
# * `maas_pserv_oops_reporter`
# The reporter used when generating provisioning server OOPS reports.
# Default reporter: "maas-pserv"
#
# * `maas_pserv_oops_dir`
# Directory in which to place OOPS reports.  Must not contain any files
# or directories other than what the oops machinery creates there.
# default directory: "/var/log/maas/oops"
#
# * `maas_pserv_broker_host`
# Default Broker host: "localhost"
#
# * `maas_pserv_broker_port`
# Default broker port: 5673
#
# * `maas_pserv_broker_user`
# Default broker username: "maas_pserv"
#
# * `maas_pserv_resource_root`
# The tftp "root" setting has been replaced by "resource_root".  The old setting
# is used one final time when upgrading a pre-14.04 cluster controller to a
# 14.04 version.  After that upgrade, it can be removed.
# Default resource_root: /var/lib/maas/boot-resources/current/
#
# * `maas_pserv_tftp_port`
# Default TFTP port 69
#
# * `maas_boot_resource_storage`
#
# * `maas_boot_resource_url`
#
# * `maas_default_cloudimage_keyring`
#
# * `maas_media_root`
# Where to store the user uploaded files.
# Default MEDIA_ROOT = '/var/lib/maas/media/'
#
# Authors
# -------
#
# Peter J. Pouliot <peter@pouliot.net>
#
# Copyright
# ---------
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class maas::params {
  case $::operatingsystem {
    'Ubuntu': {
      case $::operatingsystemrelease {
        '14.04': {
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
          $maas_command            = 'maas-region-admin'
          $maas_region_admin       = '/usr/sbin/maas-region-admin'
          $import_boot_image_flags = 'node-groups import-boot-images'
        }
        '16.04': {
          $maas_packages = [
            'maas',
            'maas-cli',
            'maas-common',
            'maas-dhcp',
            'maas-dns',
            'maas-enlist',
            'maas-proxy',
            'maas-rack-controller',
            'maas-region-api',
            'maas-region-controller',
            'maas-region-controller-min',
            'python3-django-maas',
            'python3-maas-client',
            'python3-maas-provisioningserver',
          ]
          $maas_command            = 'maas'
          $maas_region_admin       = '/usr/sbin/maas-region'
          $import_boot_image_flags = 'boot-resources import'
        }
        default: {
          warning("This is currently untested on your ${::operatingsystemrelease}")
        }
      }
    }
    default: {
      warning("This is not meant for this ${::operatingsystem}")
    }
  }

  $version                         = undef
  $ensure                          = present
  $prerequired_packages            = undef
  $manage_package                  = true
  $maas_maintainers_release        = undef
  $profile_name                    = $::fqdn
  $server_url                      = "http://${::ipaddress}/MAAS"
  $api_version                     = '1.0'
  $default_superuser               = 'admin'
  $default_superuser_password      = 'maas'
  $default_superuser_email         = "admin@${::fqdn}"
  # Region Controller address for adding new cluster controllers

  $cluster_region_controller       = undef

  $hyperv_power_adapter            = true

  $maas_api_key                    = undef
  $maas_cluster_uuid               = undef

  $maas_root_directories           = ['/etc/maas',
                                      '/etc/maas/templates',
                                      '/etc/maas/preseeds',
                                      '/usr/share/maas',
                                      '/var/lib/maas',]
  # Default Settings
  $maas_debug_mode                 = 'False'
  $maas_media_root                 = '/var/lib/maas/media/'
  $maas_db_engine                  = 'django.db.backends.postgresql_psycopg2'
  $maas_db_name                    = 'maasdb'
  $maas_db_user                    = 'maas'
  $maas_db_passwd                  = 'ky460LTuLfIl'
  $maas_db_host                    = 'localhost'


  $maas_boot_resource_storage      = '/var/lib/maas/boot-resources/'
  $maas_boot_resource_url          = 'http://maas.ubuntu.com/images/ephemeral-v2/releases/'
  $maas_default_cloudimage_keyring = '/usr/share/keyrings/ubuntu-cloudimage-keyring.gpg'

}
