# Class: maas
# ===========================
#  Metal as a Service (MAAS) lets you treat physical servers
#  like virtual machines in the cloud. Rather than having to
#  manage each server individually, MAAS turns your bare metal
#  into an elastic cloud-like resource.
#  More information can be found here:
#  https://maas.ubuntu.com/docs/
#
#  This Puppet module deploys the MAAS packages and provides puppetized
#  Administration of the MAAS Server/Cluster
#
# Parameters
# ----------
#
# * `version`
# Specify a version of MAAS to install
#
# * `ensure`
# Valid options are 'present' or 'absent'
#
# * `cloud_archive_release`
# Release of the Cloud-archive:tools to use for maas packages
# Default is currently the OpenStack Juno release
#
# * `profile_name`
# The name with which you will later refer to this
# remote server and credentials within this tool.
#
# * `server_url`
# The URL of the remote API, e.g. http://example.com/MAAS/
# or http://example.com/MAAS/api/1.0/ if you wish to specify the API version.
#
# * `api_version`
# Version of the MAAS API to use.   Default is 1.0.
#
# * `hyperv_power_adapter`
# Install HyperV Power Adapter. Default is true.
#
# * `maas_packages`
# Default MAAS Packages to install
#
# * `maas_superuser`
# Default MAAS Root Username
#
# * `maas_superuser_email`
# Default MAAS Root User email address
#
# * `maas_superuser_passwd`
# Password for the MAAS Root Account
#
# * `import_boot_image_flags`
# Used in the maas::superuser class to deal with api changes from 1.9 to 2.0 
# 
#
# * `cluster_region_controller`
# IP Address of the region controller master for new cluster controller nodes.
# Used in the maas::cluster_controller class
#
# * `manage_package`
# Wheter to manage packages or not
#
# * `maas_release_ppa`
# PPA for maas release, stable or next are supported.
#
# * `package_name`
# Name of maas package to install
#
# Examples
# --------
#
#  Install a maas region controller
#
#  --------------------------------
#
#    class { 'maas':
#    }
#
#  Install additional cluster controllers
#
#  --------------------------------------
#
#    class{ 'maas::cluster_controller':
#      cluster_region_controller => '192.168.1.1',
#    }
#
#
# Authors
# -------
#
# Peter J. Pouliot <peter@pouliot.net>
#
# Copyright
# -------
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class maas (

Optional[String] $version                          = undef,
String $ensure                                     = present,
Optional[String] $maas_release_ppa                 = undef,
Optional[String] $profile_name                     = 'admin',
Variant[Array[String], Hash] $maas_packages        = [ 'maas', 'maas-cli', 'maas-common', 'maas-dhcp', 'maas-dns', 'maas-proxy', 'maas-rack-controller', 'maas-region-api', 'maas-region-controller', 'python3-django-maas', 'python3-maas-client', 'python3-maas-provisioningserver' ], # lint:ignore:140chars
String $package_name                               = 'maas',
String $server_url                                 = 'http://localhost:5240/MAAS/api/2.0',
String $default_superuser                          = 'admin',
String $default_superuser_password                 = 'maasadmin',
String $default_superuser_email                    = "admin@${::fqdn}",
Optional[String] $cluster_region_controller        = undef,
Boolean $manage_package                            = true,
Boolean $hyperv_power_adapter                      = false,
){

  if $::operatingsystem {
    assert_type(Pattern[/(^Ubuntu)$/], $::operatingsystem) |$a, $b| {
      fail('This Module only works on Ubuntu based systems.')
    }
  }
  if $::operatingsystemrelease {
    assert_type(Pattern[/(^12.04|14.04|16.04|18.04)$/], $::operatingsystemrelease) |$a, $b| {
      fail('This Module only works on Ubuntu releases 14.04, 16.04 and 18.04.')
    }
  }

  notice("MAAS on node ${::fqdn} is managed by the maas puppet module." )

  if ($maas::maas_release_ppa) {
    assert_type(Pattern[/(^stable|next)$/], $maas_release_ppa) |$a, $b| {
      fail('This Module supports the Maas "Stable" and "Next" releases.')
    }
  }

  class{'maas::install':}
->class{'maas::config':}
  if $maas::hyperv_power_adapter == true {
    class{'maas::hyperv_power_adapter':
      require => Class['maas::config'],
    }
  }
  # TODO maas::service

  contain 'maas::install'
  contain 'maas::config'
  contain 'maas::hyperv_power_adapter'

#  Class['maas'] -> Maas::Superuser <||>
# TODO: Create a define out of import_resources.pp
#  Class['maas'] -> Maas::Import_resources <||>

}
