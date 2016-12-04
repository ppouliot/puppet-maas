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
# * `maas_maintainers_release`
# * `manage_package`
# * `package_name`
# FIXME undef
#
class maas::install {
  $version                    = $::maas::version
  $maas_maintainers_release   = $::maas::maas_maintainers_release
  $manage_package             = $::maas::manage_package
  $ensure                     = $::maas::ensure
  $package_name               = $::maas::package_name
  $default_superuser          = $::maas::default_superuser
  $default_superuser_password = $::maas::default_superuser_password
  $default_superuser_email    = $::maas::default_superuser_email

  validate_string($version)
  validate_re($::operatingsystem, '(^Ubuntu)$', 'This Module only works on Ubuntu based systems.')
  validate_re($::operatingsystemrelease, '(^12.04|14.04|16.04)$', 'This Module only works on Ubuntu releases 12.04, 14.04, and 16.04.')
  notice("MAAS installation is occuring on node ${::fqdn}." )


  case $::operatingsystem {
    'Ubuntu': {

#      from selyx-maas:
#      if $::operatingsystemrelease == '14.04' {
#        apt::ppa {'ppa:cloud-installer/stable': }
#      }
      if ($maas_maintainers_release) {
        include apt
        notice("Node ${::fqdn} is using the maas-maintainers ${maas::maas_maintiners_release} package repository for MAAS installation." )
        apt::ppa{"ppa:maas-maintainers/${maas_maintainers_release}":}
        if ($manage_package) {
          Apt::Ppa["ppa:maas-maintainers/${maas_maintainers_release}"] -> Package['maas']
        }
      } else {
        if $version and $::maas::ensure != 'absent' {
          $ensure = $version
        } else {
          $ensure = $::maas::ensure
        }
      }

      if $version {
        $maaspackage = "${package_name}-${version}"
      } else {
        $maaspackage = $package_name
      }

      if $manage_package {
        package { 'maas':
          ensure  => $maas::ensur,
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
        maas::superuser{ $default_superuser:
          password => $default_superuser_password,
          email    => $default_superuser_email,
          require  => Package['maas'],
        }
      }
    }
    default: {
      fail("MAAS does not support installation on operatingsystem: ${::operatingsystem} ")
    }
  }
}
