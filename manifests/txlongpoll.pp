# == Class: maas::txlongpoll
#
# Control of MAAS txlongpoll files and service
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class maas::txlongpoll (

  $maas_txlongpoll_config_file   = $maas::params::maas_txlongpoll_config_file,
  $maas_txlongpoll_initi_file    = $maas::params::maas_txlongpoll_initi_file,
  $maas_txlongpoll_frontend_port = $maas::params::maas_txlongpoll_frontend_port,
  $maas_txlongpoll_prefix        = $maas::params::maas_txlongpoll_prefix,
  $maas_txlongpoll_oops_dir      = $maas::params::maas_txlongpoll_oops_dir,
  $maas_txlongpoll_oops_reporter = $maas::params::maas_txlongpoll_oops_reporter,
  $maas_txlongpoll_broker_host   = $maas::params::maas_txlongpoll_broker_host,
  $maas_txlongpoll_broker_port   = $maas::params::maas_txlongpoll_broker_port,
  $maas_txlongpoll_broker_user   = $maas::params::maas_txlongpoll_broker_user,
  $maas_txlongpoll_broker_passwd = $maas::params::maas_txlongpoll_broker_passwd,
  $maas_txlongpoll_broker_vhost  = $maas::params::maas_txlongpoll_broker_vhost,
  $maas_txlongpoll_logfile       = $maas::params::maas_txlongpoll_logfile,


){


## /etc/maas/txlongpoll.yaml
  file{ $maas_txlongpoll_config_file:
    ensure  => present,
    content => template('maas/txlonpoll.yaml.erb')
  }

## /etc/init/maas-txlongpoll.conf
  file{ $::maas_txlongpoll_init_file:
    ensure  => present,
    content => template('maas/init/maas-txlonpoll.conf.erb')
  }

  service {'maas-txlongpoll':
    ensure  => running,
    require => File[ $::maas_txlongpoll_config_file, $::maas_txlongpoll_init_file ]
  }

}
