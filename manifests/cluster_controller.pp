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

#  $maas_cluster_controller_config_file   = $maas::params::maas_cluster_controller_config_file,
#  $maas_cluster_controller_initi_file    = $maas::params::maas_cluster_controller_initi_file,
#  $maas_cluster_controller_frontend_port = $maas::params::maas_cluster_controller_frontend_port,
#  $maas_cluster_controller_prefix        = $maas::params::maas_cluster_controller_prefix,
#  $maas_cluster_controller_oops_dir      = $maas::params::maas_cluster_controller_oops_dir,
#  $maas_cluster_controller_oops_reporter = $maas::params::maas_cluster_controller_oops_reporter,
#  $maas_cluster_controller_broker_host   = $maas::params::maas_cluster_controller_broker_host,
#  $maas_cluster_controller_broker_port   = $maas::params::maas_cluster_controller_broker_port,
#  $maas_cluster_controller_broker_user   = $maas::params::maas_cluster_controller_broker_user,
#  $maas_cluster_controller_broker_passwd = $maas::params::maas_cluster_controller_broker_passwd,
#  $maas_cluster_controller_broker_vhost  = $maas::params::maas_cluster_controller_broker_vhost,
#  $maas_cluster_controller_logfile       = $maas::params::maas_cluster_controller_logfile,

){

  # The following is essentially what I used in the node definition to create a secondary cluster controller
  # There is an additional template needed.
  include apt
  include stdlib

  package{'software-properties-common':
    ensure => latest,
  } ->
  apt::ppa{'ppa:maas-maintainers/stable':} ->
  package{'maas-cluster-controller':
    ensure => latest,
  } ->
  ## /etc/maas/maas_cluster.conf
  file{ '/etc/maas/maas_cluster.conf':
    ensure => present,
#    content => template('maas/maas_cluster.yaml.erb')
  } ->
  file_line{ 'maas_cluster.conf-region_controller_address':
    path  => '/etc/maas/maas_cluster.conf',
    match => 'MAAS_URL=http://localhost/MAAS',
    line  => "MAAS_URL=\"http://${cluster_region_controller}/MAAS\"",
  } ->
  ## /etc/maas/pserv.yaml
  file{ '/etc/maas/pserv.yaml':
    ensure => present,
#    content => template('maas/pserv.yaml.erb')
  } ->
  file_line{ 'pserv.yaml-region_controller_address':
    path  => '/etc/maas/pserv.yaml',
    match => '\ \ generator: http://localhost:5240/MAAS/api/1.0/pxeconfig/',
    line  => "  generator: http://${cluster_region_controller}:5240/MAAS/api/1.0/pxeconfig/",
  } ->
  file{ '/var/lib/maas/secret':
    ensure  => file,
    owner   => 'maas',
    group   => 'maas',
    mode    => '0640',
    # FIXME really use /extra_files/maas/secret?
    # maybe:
    # source  => 'puppet:///modules/maas/extra_files/maas/secret',
    source  => 'puppet:///extra_files/maas/secret',
    require => Package['maas-cluster-controller'],
  } ->
  service {'maas-clusterd':
    ensure  => running,
    enable  => true,
    require => Package['maas-cluster-controller'],
  }
#}
## /etc/maas/maas-cluster-http.conf
## /etc/maas/maas-http.conf
## /etc/maas/maas_local_celeryconfig.py
## /etc/maas/maas_local_celeryconfig_cluster.py


  ## /etc/maas/maas-cluster-http.conf
#  file{ '/etc/maas/maas-cluster-http.conf':
#    ensure => present,
#    content => template('maas/maas-cluster-http.conf.erb')
#  }

  ## /etc/maas/maas-http.conf
#  file{ '/etc/maas/maas-http.conf':
#    ensure => present,
#    content => template('maas/maas-http.conf.erb')
#  }

  ## /etc/maas/maas_local_celeryconfig.py
#  file{ '/etc/maas/maas_local_celeryconfig.py':
#    ensure => present,
#    content => template('maas/maas_local_celeryconfig.py.erb')
#  }

  ## /etc/maas/maas_local_celeryconfig_cluster.py
#  file{ '/etc/maas/maas_local_celeryconfig_cluster.py':
#    ensure => present,
#    content => template('maas/maas_local_celeryconfig_cluster.py.erb')
#  }

}
