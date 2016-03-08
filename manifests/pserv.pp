# == Class: maas::pserv
#
# Control of MAAS pserv files and service
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class maas::pserv (

  $maas_pserv_config_file   = $maas::params::maas_pserv_config_file,
  $maas_pserv_initi_file    = $maas::params::maas_pserv_initi_file,
  $maas_pserv_oops_dir      = $maas::params::maas_pserv_oops_dir,
  $maas_pserv_oops_reporter = $maas::params::maas_pserv_oops_reporter,
  $maas_pserv_broker_host   = $maas::params::maas_pserv_broker_host,
  $maas_pserv_broker_port   = $maas::params::maas_pserv_broker_port,
  $maas_pserv_broker_user   = $maas::params::maas_pserv_broker_user,
  $maas_pserv_broker_passwd = $maas::params::maas_pserv_broker_passwd,
  $maas_pserv_broker_vhost  = $maas::params::maas_pserv_broker_vhost,
  $maas_pserv_logfile       = $maas::params::maas_pserv_logfile,
  $maas_pserv_resource_root = $maas::params::maas_pserv_resource_root,
  $maas_pserv_tftp_port     = $maas::params::maas_pserv_tftp_port,


){


## /etc/maas/pserv.yaml
  file{ $::maas_pserv_config_file:
    ensure  => present,
    content => template('maas/pserv.yaml.erb'),
  }

## /etc/init/maas-pserv.conf
  file{ $::maas_pserv_init_file:
    ensure  => present,
    content => template('maas/init/maas-pserv.conf.erb'),
  }

  service {'maas-pserv':
    ensure  => running,
    require => File[ $::maas_pserv_config_file, $::maas_pserv_init_file ],
  }

}
