# == Class: maas::import_boot_images
# A class to import boot-images into maas
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
# class{'maas::import_boot_images':}
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class maas::import_boot_images () inherits maas::params {
  exec{'maas-import-boot-images':
    command     => "/usr/bin/maas ${maas::profile_name} node-groups import-boot-images",
    before      => Exec["logout-superuser-with-api-key-$name"],
    cwd         => '/etc/maas/.puppet',
    refreshonly => true,
    logoutput   => true,
    require     => Package['maas'],
  }
}
