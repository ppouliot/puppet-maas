# Class maas::install
# ===================
# class to install an update-to-date version of maas from
# the default package repository or the Cloud-Archive repo
# This installs on Ubunt based distributions only.
#
# Variables
# ----------
# * `version`
# * `ensure`
# * `maas_superuser`
# * `maas_superuser_email`
# * `maas_superuser_passwd`
# * `maas_release_ppa`
# * `manage_package`
# * `package_name`

class maas::install {

  notice("MAAS installation is occuring on node ${::fqdn}." )
  include apt

  case $::operatingsystem {
    'Ubuntu': {

      if ($maas::maas_release_ppa) {
        notice("Node ${::fqdn} is using the maas-maintainers ${maas::maas_release_ppa} package repository for MAAS installation." )
        apt::ppa{"ppa:maas/${maas::maas_release_ppa}":}
        if ($maas::manage_package) {
          Apt::Ppa["ppa:maas/${maas::maas_release_ppa}"] -> Package['maas']
        }
      } else {
        if $maas::version and $maas::ensure != 'absent' {
          $ensure = $maas::version
        } else {
          $ensure = $maas::ensure
        }
      }

      if $maas::version {
        $maaspackage = "${package_name}-${maas::version}"
      } else {
        $maaspackage = $maas::package_name
      }

      if $maas::manage_package {
        package { 'maas':
          ensure  => $maas::ensure,
          name    => $maaspackage,
          require => Class['apt::update'],
        } ->
        package{['maas-dhcp','maas-dns']:
          ensure => $maas::ensure,
        }
        ## A Directory for help with MAAS related command automation
        file {'/etc/maas/.puppet/':
          ensure  => directory,
          require => Package['maas'],
        }
        ## Create MAAS Superuser
        maas::superuser{ $maas::default_superuser:
          password => $maas::default_superuser_password,
          email    => $maas::default_superuser_email,
          require  => Package['maas'],
        }
      }
    }
    default: {
      fail("MAAS does not support installation on operatingsystem: ${::operatingsystem} ")
    }
  }
}
