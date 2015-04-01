# == Class: maas::cluster_celery
#
# Control of MAAS cluster_celery files and service
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class maas::cluster_celery (

  $maas_cluster_celery_config_file   = $maas::params::maas_cluster_celery_config_file,
  $maas_cluster_celery_initi_file    = $maas::params::maas_cluster_celery_initi_file,
  $maas_cluster_celery_frontend_port = $maas::params::maas_cluster_celery_frontend_port,
  $maas_cluster_celery_prefix        = $maas::params::maas_cluster_celery_prefix, 
  $maas_cluster_celery_oops_dir      = $maas::params::maas_cluster_celery_oops_dir, 
  $maas_cluster_celery_oops_reporter = $maas::params::maas_cluster_celery_oops_reporter, 
  $maas_cluster_celery_broker_host   = $maas::params::maas_cluster_celery_broker_host, 
  $maas_cluster_celery_broker_port   = $maas::params::maas_cluster_celery_broker_port,
  $maas_cluster_celery_broker_user   = $maas::params::maas_cluster_celery_broker_user,
  $maas_cluster_celery_broker_passwd = $maas::params::maas_cluster_celery_broker_passwd,
  $maas_cluster_celery_broker_vhost  = $maas::params::maas_cluster_celery_broker_vhost,
  $maas_cluster_celery_logfile       = $maas::params::maas_cluster_celery_logfile,


) inherits maas::params {


## /etc/maas/maas_cluster.yaml
## /etc/maas/maas-cluster-http.conf
## /etc/maas/maas-http.conf
## /etc/maas/maas_local_celeryconfig.py
## /etc/maas/maas_local_celeryconfig_cluster.py

  ## /etc/maas/maas_cluster.yaml

  file{ '/etc/maas/maas_cluster.yaml':
    ensure => present,
    content => template('maas/maas_cluster.yaml.erb')
  }

  ## /etc/maas/maas-cluster-http.conf
  file{ '/etc/maas/maas-cluster-http.conf':
    ensure => present,
    content => template('maas/maas-cluster-http.conf.erb')
  }

  ## /etc/maas/maas-http.conf
  file{ '/etc/maas/maas-http.conf':
    ensure => present,
    content => template('maas/maas-http.conf.erb')
  }

  ## /etc/maas/maas_local_celeryconfig.py
  file{ '/etc/maas/maas_local_celeryconfig.py':
    ensure => present,
    content => template('maas/maas_local_celeryconfig.py.erb')
  }

  ## /etc/maas/maas_local_celeryconfig_cluster.py
  file{ '/etc/maas/maas_local_celeryconfig_cluster.py':
    ensure => present,
    content => template('maas/maas_local_celeryconfig_cluster.py.erb')
  }

}
