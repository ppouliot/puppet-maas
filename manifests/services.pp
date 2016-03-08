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
class maas::admin (){


# MAAS Services
#maas-cluster-celery
#maas-dhcp-server
#maas-pserv.conf
#maas-region-celery

##maas-cluster-celery
### file: /etc/init/maas-cluster-celery.conf
  file {'/etc/init/maas-cluster-celery.conf',
    ensure => present,
  }
  service {'maas-cluster-celery':
    ensure  => running,
    require => File['/etc/init/maas-cluster-celery.conf'],
  }

### file: /etc/init/maas-region-celery.conf

  file{'/etc/init/maas-region-celery.conf':
    ensure => present,
  }

  service {'maas-region-celery':
    ensure  => running,
    require => File['/etc/init/maas-region-celery.conf'],
  }

##maas-dhcp-server
### /etc/init/maas-dhcp-server.conf
  file{'/etc/init/maas-dhcp-server.conf':
    ensure => present,
  }

  service {'maas-dhcp-server':
    ensure  => running,
    require => File['/etc/init/maas-dhcp-server.conf'],
  }

## maas-pserv
### file: /etc/init/maas-pserv.conf
  file{'/etc/init/maas-pserv.conf':
    ensure => present,
  }
  service {'maas-pserv':
    ensure  => running,
    require => File['/etc/init/maas-pserv.conf']:
  }
## /etc/init/maas-txlongpoll.conf
  file{'/etc/init/maas-txlongpoll.conf':
    ensure => present,
  }
  service {'maas-txlongpoll':
    ensure  => running,
    require => File['/etc/init/maas-txlongpoll.conf'],
  }

}
