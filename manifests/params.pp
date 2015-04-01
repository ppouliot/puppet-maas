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
# [*maas_api_key*]
#   The credentials, also known as the API key, for the remote
#   MAAS server. These can be found in the user preferences page
#   in the web UI; they take the form of a long random-looking
#   string composed of three parts, separated by colons.
#
# [*maas_cluster_uuid*]
#   The UUID of for the  MAAS Cluster
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
          $cloud_archive_release         = 'juno'
          $maas_root_user                = 'root'
          $maas_root_password            = 'maas'
          $maas_root_user_email          = 'ppouliot@microsoft.com'

          $maas_profile_name             = "${fqdn}"
          $maas_server_url               = "http://$ipaddress/MAAS"
          $maas_api_version              = '1.0'
          $maas_api_key                  = undef
          $maas_cluster_uuid             = undef

          # MAAS TXLONGPOLL 
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
          #   maas                            - MAAS server all-in-one metapackage
          # A maas-cli                        - MAAS command line API tool
          # A maas-cluster-controller         - MAAS server cluster controller
          # A maas-common                     - MAAS server common files
          # A maas-dhcp                       - MAAS DHCP server
          # A maas-dns                        - MAAS DNS server
          # A maas-region-controller          - MAAS server complete region controller
          # A maas-region-controller-min      - MAAS Server minimum region controller
          # A python-django-maas              - MAAS server Django web framework
          # A python-maas-client              - MAAS python API client
          # A python-maas-provisioningserver  - MAAS server provisioning libraries

          $maas_packages  = [
            'maas',
            'maas-cli',
            'maas-cluster-controller',
            'maas-common',
            'maas-dhcp',
            'maas-dns',
            'maas-region-controller',
            'maas-region-controller-min',
            'python-django-maas',
            'python-maas-provisioningserver']

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
