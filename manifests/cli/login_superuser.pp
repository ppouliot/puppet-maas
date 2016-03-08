# == Class: maas::cli::login_superuser
# A class to login the superuser
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
# class{'maas::cli::login_superuser':}
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class maas::cli::login_superuser (){
  exec{'maas-cli-login-user-name':
    command     => "/usr/bin/maas login ${maas::maas_superuser} ${maas::server_url}`/user/bin/maas-region-admin apikey ${maas::profile_name} --username ${maas::maas_superuser}`",
    before      => Exec["logout-superuser-with-api-key-${maas::maas_superuser}"],
    cwd         => '/etc/maas/.puppet',
#    refreshonly => true,
    logoutput   => true,
    require     => Package['maas'],
  }
}
