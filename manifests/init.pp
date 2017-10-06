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
# * `maas_region_admin`
# Used in the maas::superuser class to allow for api changes to using maas-region over maas-region-admin 
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
# * `maas_maintainers_release`
# PPA maas-maintainers release, currently only stable is supported
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

  $version                    = $::maas::params::version,
  $ensure                     = $::maas::params::ensure,
  $prerequired_packages       = $::maas::params::prerequired_packages,
  $maas_maintainers_release   = $::maas::params::maas_maintainers_release,
  $profile_name               = $::maas::params::profile_name,
  $maas_packages              = $::maas::params::maas_packages,
  $default_superuser          = $::maas::params::default_superuser,
  $default_superuser_password = $::maas::params::default_superuser_password,
  $default_superuser_email    = $::maas::params::default_superuser_email,
  $maas_region_admin          = $::maas::params::maas_region_admin,
  $import_boot_image_flags    = $::maas::params::import_boot_image_flags,
  $cluster_region_controller  = $::maas::params::cluster_region_controller,
  $manage_package             = $::maas::params::manage_package,
  $hyperv_power_adapter       = $::maas::params::hyperv_power_adapter,

) inherits maas::params {

  validate_string($version)
  validate_re($::operatingsystem, '(^Ubuntu)$', 'This Module only works on Ubuntu based systems.')
  validate_re($::operatingsystemrelease, '(^12.04|14.04|16.04)$', 'This Module only works on Ubuntu releases 12.04, 14.04 and 16.04.')
  notice("MAAS on node ${::fqdn} is managed by the maas puppet module." )

  if ($maas_maintainers_release) {
    validate_string($maas_maintainers_release, '^(stable)$', 'This module only supports the Stable Releases')
  }

  class{'maas::install':} ->
  class{'maas::config':} ->
  class{'maas::hyperv_power_adapter':}
  # TODO maas::service

  contain 'maas::install'
  contain 'maas::config'
  contain 'maas::hyperv_power_adapter'

#  Class['maas'] -> Maas::Superuser <||>
# TODO: Create a define out of import_resources.pp
#  Class['maas'] -> Maas::Import_resources <||>

}
