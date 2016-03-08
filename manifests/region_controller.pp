# == Class: maas::region_controller
#
# Control of MAAS region_controller files and service
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class maas::region_controller (

  $region_controller_packages      = $maas::params::region_controller_packages,
  $region_controller_config_file   = $maas::params::region_controller_config_file,
  $region_controller_initi_file    = $maas::params::region_controller_initi_file,
  $region_controller_frontend_port = $maas::params::region_controller_frontend_port,
  $region_controller_prefix        = $maas::params::region_controller_prefix,
  $region_controller_oops_dir      = $maas::params::region_controller_oops_dir,
  $region_controller_oops_reporter = $maas::params::region_controller_oops_reporter,
  $region_controller_broker_host   = $maas::params::region_controller_broker_host,
  $region_controller_broker_port   = $maas::params::region_controller_broker_port,
  $region_controller_broker_user   = $maas::params::region_controller_broker_user,
  $region_controller_broker_passwd = $maas::params::region_controller_broker_passwd,
  $region_controller_broker_vhost  = $maas::params::region_controller_broker_vhost,
  $region_controller_logfile       = $maas::params::region_controller_logfile,


){


## /etc/maas/maas_cluster.yaml
## /etc/maas/maas-cluster-http.conf
## /etc/maas/maas-http.conf
## /etc/maas/maas_local_celeryconfig.py
## /etc/maas/maas_local_celeryconfig_cluster.py

  ## /etc/maas/maas_cluster.yaml

  file{ '/etc/maas/maas_cluster.yaml':
    ensure  => present,
    content => template('maas/maas_cluster.yaml.erb')
  }

  ## /etc/maas/maas-cluster-http.conf
  file{ '/etc/maas/maas-cluster-http.conf':
    ensure  => present,
    content => template('maas/maas-cluster-http.conf.erb')
  }

  ## /etc/maas/maas-http.conf
  file{ '/etc/maas/maas-http.conf':
    ensure  => present,
    content => template('maas/maas-http.conf.erb')
  }

  ## /etc/maas/maas_local_celeryconfig.py
  file{ '/etc/maas/maas_local_celeryconfig.py':
    ensure  => present,
    content => template('maas/maas_local_celeryconfig.py.erb')
  }

  ## /etc/maas/maas_local_celeryconfig_cluster.py
  file{ '/etc/maas/maas_local_celeryconfig_cluster.py':
    ensure  => present,
    content => template('maas/maas_local_celeryconfig_cluster.py.erb')
  }

}
