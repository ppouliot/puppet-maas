# == Class: maas::cli::nodes_accept_all
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
# class{'maas::cli::nodes_accept_all':}
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class maas::cli::nodes_accept_all (){
  exec{'maas-import-boot-images':
    command     => "/usr/bin/maas ${maas::profile_name} nodes accept-all",
    before      => Exec["logout-superuser-with-api-key-${maas::default_superuser}"],
    cwd         => '/etc/maas/.puppet',
    refreshonly => true,
    logoutput   => true,
    require     => Package['maas'],
  }
}
