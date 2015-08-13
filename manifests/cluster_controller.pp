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


) inherits maas::params {

 # The following is essentially what I used in the node definition to create a secondary cluster controller
 # There is an additional template needed.
  package{'software-properties-common':
    ensure => latest,
  } ->
  include apt
  apt::ppa{"ppa:maas-maintainers/stable":} ->
  package{'maas-cluster-controller':
    ensure => latest,
  } ->
  ## /etc/maas/maas_cluster.yaml
  file{ '/etc/maas/maas_cluster.yaml':
    ensure => present,
#    content => template('maas/maas_cluster.yaml.erb')
  } ->
  file_line{'maas_cluster.conf-region_controller_address':
    path   => '/etc/maas/maas_cluster.yaml',
    match  => 'MAAS_URL=http://localhost/MAAS',
    match  => "MAAS_URL=http://${maas::cluster_region_controller}/MAAS",
  } ->
  file{'/var/lib/maas/secret':
    ensure => file,
    owner  => 'maas',
    group  => 'maas',
    mode   => '640',
    source => 'puppet:///extra_files/maas/secret',
  } ->
  service {'maas-clusterd':
    enable => true,
    ensure => running,
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
