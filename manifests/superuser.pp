# == Define: maas::superuser
#
# Creates the mass admin user account
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
define maas::superuser ( $password, $email ) { 

  validate_string($name)
  validate_string($password)
  validate_string($email)

  exec{"create-maas-admin-$name":
    command   => "/usr/sbin/maas-region-admin createadmin --username=${$name} --email=${email} --password=${passwd}",
    require   => Package[$maaspackage],
    logoutput => true,
    unless    => "/usr/sbin/maas-region-admin apikey ${maas::profile_name} --username ${name}",
  }

## Command to get the MAAS User's Key
  exec{'get-api-key-maas-admin-account':
    command     => "/usr/sbin/maas-region-admin apikey ${maas::profile_name} --username ${name}",
    refreshonly => true,
    require     => Package[$maaspackage],
    logoutput   => true,
  }

## Command to Login to the MAAS profile using the api-key
  exec{'get-api-key-maas-admin-account':
    command     => "/usr/sbin/maas maas_login ${maas::profile_name} ${maas_server_url} ${maas_api_key}",
    refreshonly => true,
    require     => Package[$maaspackage],
    logoutput   => true,
  }
}
