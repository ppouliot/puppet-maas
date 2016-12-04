# == Class: maas::account
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
#  class { 'maas::account': }
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class maas::account (

  $cloud_archive_release = $maas::params::cloud_archive_release,
  $maas_packages         = $maas::params::maas_packages,
  $maas_root_user        = $maas::params::maas_root_user,
  $maas_root_passwd      = $maas::params::maas_root_passwd,
  $maas_root_email       = $maas::params::maas_root_email,
  $maas_profile_name     = $maas::params::maas_profile_name,
  $maas_api_key          = $maas::params::maas_api_key,
  $maas_server_url       = $maas::params::maas_server_url,

){

  exec{'maas-create-auth-token':
    command   => '/usr/sbin/maas create-authorisation-token -d',
    require   => Package[$maas_packages],
    logoutput => true,
    unless    => "/usr/sbin/maas-region-admin apikey ${maas_profile_name} --username ${maas_root_user}",
  }
  exec{'maas-delete-auth-token':
    command   => "/usr/sbin/maas delete-authorisation-token token_key ${maas_api_key} -d",
    require   => Package[$maas_packages],
    logoutput => true,
    unless    => "/usr/sbin/maas-region-admin apikey ${maas_profile_name} --username ${maas_root_user}",
  }
}
