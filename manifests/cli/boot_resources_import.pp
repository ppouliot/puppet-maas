# == Class: maas::cli::boot_resources_import
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
# class{'maas::cli::boot_resources_import':}
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class maas::cli::boot_resources_import (){
  exec{'maas-cli-boot-resources-import':
    command     => "/usr/bin/maas ${maas::profile_name} boot-resources import",
    before      => Exec["logout-superuser-with-api-key-${maas::maas_superuser}"],
    cwd         => '/etc/maas/.puppet',
    refreshonly => true,
    logoutput   => true,
    require     => Package['maas'],
  }
}
