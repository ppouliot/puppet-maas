# == Class:maas::install
# 
# class to install an update-to-date version of maas from
# the default package repository or the Cloud-Archive repo
# This installs on Ubunt based distributions only.

class maas::install {
  validate_string($maas::version)
  validate_re($::operatingsystem, '(^Ubuntu)$', 'This Module only works on Ubuntu based systems.')
  validate_re($::operatingsystemrelease, '(^12.04|14.04)$', 'This Module only works on Ubuntu releases 12.04 and 14.04.')
  notice("MAAS installation is occuring on node ${::fqdn}." )


  case $operatingsystem {
    'Ubuntu':{
      if ($maas::cloud_archive_release) {
        include apt
        notice("Node ${::fqdn} is using the cloud-archive:${maas::cloud_archive_release} package repository for MAAS installation." )
        apt::ppa{"cloud-archive:${maas::cloud_archive_release}":}
      }

      if ($maas::manage_package) and ($maas::cloud_archive_release) {
        Apt::Ppa["cloud-archive:${maas::cloud_archive_release}"] -> Package[ $maaspackage ]
      }

      if $maas::version {
        $maaspackage = "${maas::package_name}-${maas::version}"
      } else {
        $maaspackage = $maas::package_name
      }
      if $maas::manage_package {
        package { 'maas':
          ensure => $maas::ensure,
          name   => $maaspackage
        }
      }
    }

    default:{
      fail("MAAS does not support installation on your operation system: ${::osfamily} ")
    }
  }
}
