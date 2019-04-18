# == Class: maas::cluster_controller
#
# Control of MAAS cluster_controller files and service
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class maas::cluster_controller (
  $cluster_region_controller = $maas::cluster_region_controller
){

  # The following is essentially what I used in the node definition to create a secondary cluster controller
  # There is an additional template needed.
  include apt
  include stdlib

  package{'software-properties-common':
    ensure => latest,
  }
->apt::ppa{'ppa:maas-maintainers/stable':}
  package{'maas-cluster-controller':
    ensure => latest,
  }
  ## /etc/maas/maas_cluster.conf
->file{ '/etc/maas/maas_cluster.conf':
    ensure => present,
#    content => template('maas/maas_cluster.yaml.erb')
  }
->file_line{ 'maas_cluster.conf-region_controller_address':
    path  => '/etc/maas/maas_cluster.conf',
    match => 'MAAS_URL=http://localhost/MAAS',
    line  => "MAAS_URL=\"http://${cluster_region_controller}/MAAS\"",
  }
  ## /etc/maas/pserv.yaml
->file{ '/etc/maas/pserv.yaml':
    ensure => present,
#    content => template('maas/pserv.yaml.erb')
  }
->file_line{ 'pserv.yaml-region_controller_address':
    path  => '/etc/maas/pserv.yaml',
    match => '\ \ generator: http://localhost:5240/MAAS/api/1.0/pxeconfig/',
    line  => "  generator: http://${cluster_region_controller}:5240/MAAS/api/1.0/pxeconfig/",
  }
->file{ '/var/lib/maas/secret':
    ensure  => file,
    owner   => 'maas',
    group   => 'maas',
    mode    => '0640',
    # FIXME really use /extra_files/maas/secret?
    # maybe:
    source  => 'puppet:///modules/maas/extra_files/maas/secret',
    # source  => 'puppet:///extra_files/maas/secret',
    require => Package['maas-cluster-controller'],
  }
->service {'maas-clusterd':
    ensure  => running,
    enable  => true,
    require => Package['maas-cluster-controller'],
  }
}
