# == Class: maas::params
#
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
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class maas::params {
  case $operatingsystem {
    'Ubuntu':{
      case $operatingsystemrelease {
        '14.04':{
          $cloud_archive_release = 'juno'
          $maas_root_user        = 'root'
          $maas_root_password    = 'maas'
          $maas_root_user_email  = 'ppouliot@microsoft.com'

          # Installed MAAS Packages
          #   maas                            - MAAS server all-in-one metapackage
          # A maas-cli                        - MAAS command line API tool
          # A maas-cluster-controller         - MAAS server cluster controller
          # A maas-common                     - MAAS server common files
          # A maas-dhcp                       - MAAS DHCP server
          # A maas-dns                        - MAAS DNS server
          # A maas-region-controller          - MAAS server complete region controller
          # A maas-region-controller-min      - MAAS Server minimum region controller
          # A python-django-maas              - MAAS server Django web framework
          # A python-maas-client              - MAAS python API client
          # A python-maas-provisioningserver  - MAAS server provisioning libraries

          $maas_packages  = [
            'maas',
            'maas-cli',
            'maas-cluster-controller',
            'maas-common',
            'maas-dhcp',
            'maas-dns',
            'maas-region-controller',
            'maas-region-controller-min',
            'python-django-maas',
            'python-maas-provisioningserver']

        }
        default:{
          warning("This is currently untested on your ${operatingsystemrelease}")
        }
      }
    }
    default:{
      warning("This is not meant for this ${operatingsystem}")
    }
  }
}
