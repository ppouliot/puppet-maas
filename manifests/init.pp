# == Class: maas
#  Metal as a Service – MAAS – lets you treat physical servers
#  like virtual machines in the cloud. Rather than having to 
#  manage each server individually, MAAS turns your bare metal 
#  into an elastic cloud-like resource.
#  More information can be found here:
#  https://maas.ubuntu.com/docs/
#
#  This Puppet module deploys the MAAS packages and provides puppetized
#  Administration of the MAAS Server/Cluster
#
# Full description of class maas here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
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
#  class { 'maas':
#  }
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class maas (

  $cloud_archive_release = $maas::params::cloud_archive_release,
  $maas_packages         = $maas::params::maas_packages,
  $maas_root_user        = $maas::params::maas_root_user,
  $maas_root_passwd      = $maas::params::maas_root_passwd,
  $maas_root_email       = $maas::params::maas_root_email,

) inherits maas::params {

  include apt
  apt::ppa{"cloud-archive:${cloud_archive_release}":}
  package { $maas_packages:
    ensure => latest,
    require => Apt::Ppa["cloud-archive:${cloud_archive_release}"],
  }
  exec{'maas-import-boot-resources':
    command => "/usr/sbin/maas my-maas-session boot-resources import",
    require => Exec['create-maas-admin-account'],
    logoutput => true,
  }
}
