# == Class: maas::admin
#
# Creates the mass admin user account
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
#  class { 'maas::admin': }
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class maas::admin (

  $cloud_archive_release = $maas::params::cloud_archive_release,
  $maas_packages         = $maas::params::maas_packages,
  $maas_root_user        = $maas::params::maas_root_user,
  $maas_root_passwd      = $maas::params::maas_root_passwd,
  $maas_root_email       = $maas::params::maas_root_email,
  $maas_profile_name     = $maas::params::maas_profile_name,
  $maas_api_key          = $maas::params::maas_api_key,
  $maas_server_url       = $maas::params::maas_server_url,

) inherits maas::params {

  exec{'create-maas-admin-account':
    command   => "/usr/sbin/maas-region-admin createadmin --username=${maas_root_user} --email=${maas_root_user_email} --password=${maas_root_passwd}",
    require   => Package[$maas_packages],
    logoutput => true,
    unless    => "/usr/sbin/maas-region-admin apikey ${maas_profile_name} --username ${maas_root_user}",

  }

## Command to get the MAAS User's Key
  exec{'get-api-key-maas-admin-account':
    command     => "/usr/sbin/maas-region-admin apikey ${maas_profile_name} --username ${maas_root_user}",
    refreshonly => true,
    require     => Package[$maas_packages],
    logoutput   => true,
  }

## Command to Login to the MAAS profile using the api-key
  exec{'get-api-key-maas-admin-account':
    command     => "/usr/sbin/maas maas_login ${maas_profile_name} ${maas_server_url} ${maas_api_key}",
    refreshonly => true,
    require     => Package[$maas_packages],
    logoutput   => true,
  }
}
