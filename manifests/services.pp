# == Class: maas::services
#
# Control of MAAS services
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
# === Examples
#
#  class { 'maas::services': }
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class maas::admin () inherits maas::params {


# MAAS Services
#maas-cluster-celery
#maas-dhcp-server
#maas-pserv.conf
#maas-region-celery

## /etc/init/maas-cluster-celery.conf
  service {'maas-cluster-celery':
    ensure => running,
  }
## /etc/init/maas-region-celery.conf 
  service {'maas-region-celery':
    ensure => running,
  }
## /etc/init/maas-dhcp-server.conf
  service {'maas-dhcp-server':
    ensure => running,
  }
## /etc/init/maas-pserv.conf 
  service {'maas-pserv':
    ensure => running,
  }
## /etc/init/maas-txlongpoll.conf
  service {'maas-txlongpoll':
    ensure => running,
  }

}
