# == Class: maas::import_resources
# A class to import boot-resources into maas
#
# === Parameters
#
# Document parameters here.
#
# === Variables
# Document variables here.
#
# === Examples
#
# class{'maas::import_resources':}
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class maas::import_resources () inherits maas::params {
  exec{'maas-import-boot-resources':
    command => "/usr/sbin/maas my-maas-session boot-resources import",
    require => Exec['create-maas-admin-account'],
    logoutput => true,
  }
}
