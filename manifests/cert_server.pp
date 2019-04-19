# Class maas::cert_server
# ===================
# class to install an update-to-date version of maas-cert-server from
# ppa:hardware-certification/public
# This installs on Ubunt based distributions only.
# http://certification-static.canonical.com/docs/MAAS_Advanced_NUC_Installation_And_Configuration.pdf
#
# Parameters
# ----------
#
# * `maas_cert_server`
# Installs maas-cert-server from maas::maas_cert_server_version. Default is false.
#
# * `maas_cert_server_version`
# Version of maas-cert-server to install. Default is undef.
#
# * `maas_cert_server_ensure`
# Ensure of maas-cert-server to install. Default is undef.
#
# Variables
# ----------
# * `version`
# * `ensure`
# * `package_name`

class maas::cert_server (
  $ensure  = present,
  $version = undef,
){

  notice("MAAS installation is occuring on node ${::fqdn}." )
  include apt

  case $::operatingsystem {
    'Ubuntu': {
      notice("Node ${::fqdn} is using the maas ppa:hardware-certification/public package repository for MAAS Cert Server installation." )
      apt::ppa{'ppa:hardware-certification/public':}
      if ($maas::manage_package) {
        Apt::Ppa['ppa:hardware-certification/public'] -> Package['maas-cert-server']
      }
      if $version and $ensure != 'absent' {
        $ensure = $version
      }

      if $version {
        $maascertserverpackage = "${::package_name}-${::version}"
      } else {
        $maascertserverpackage = $::package_name
      }

      package { 'maas-cert-server':
        ensure  => $ensure,
        name    => $maascertserverpackage,
        require => [
          Class['apt::update'],
          Class['maas'],
        ],
      }
    }
    default: {
      fail("MaaS Cert Server does not support installation on operatingsystem: ${::operatingsystem} ")
    }
  }
}
