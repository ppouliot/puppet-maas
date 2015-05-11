# == Define: maas::superuser
#
# Creates the mass admin user account it
# stores that user account in 
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
define maas::superuser ( $superuser_name = $name, $password, $email ) { 

  validate_string($name)
  validate_string($password)
  validate_string($email)
  ## Command to Create a SuperUser in MAAS
  exec{"create-superuser-$name":
    command   => "/usr/sbin/maas-region-admin createadmin --username=${$name} --email=${email} --password=${password}",
    cwd       => '/etc/maas/.puppet/',
    logoutput => true,
    onlyif    => "/usr/bin/test ! -f /etc/maas/.puppet/su-${name}.maas",
    notify    => Exec["get-api-key-superuser-account-$name"],
    require   => Package['maas'],
  }

  ## Command to get the MAAS User's Key
  exec{"get-api-key-superuser-account-$name":
    command     => "/usr/sbin/maas-region-admin apikey ${maas::profile_name} --username ${name} > /etc/maas/.puppet/su-${name}.maas",
    creates     => "/etc/maas/.puppet/su-${name}.maas",
    cwd         => '/etc/maas/.puppet/',
    onlyif      => "/usr/bin/test ! -f /etc/maas/.puppet/su-${name}.maas",
    refreshonly => true,
    logoutput   => true,
    notify      => Exec["login-superuser-with-api-key-$name"],
    require     => Package['maas'],
  }

  ## Command to Login to the MAAS profile using the api-key
  warning("superuser: ${name} login test")
  exec{"login-superuser-with-api-key-$name":
    command     => "/usr/bin/maas login ${maas::profile_name} ${maas::server_url} `/usr/sbin/maas-region-admin apikey ${maas::profile_name} --username ${name}`",
    cwd         => '/etc/maas/.puppet',
    refreshonly => true,
    logoutput   => true,
    notify      => exec["logout-superuser-with-api-key-$name"],
    require     => Package['maas'],
  }

  if $name == $maas::default_superuser {
    exec{"maas-import-boot-images-run-by-user-$name":
      command     => "/usr/bin/maas ${maas::profile_name} node-groups import-boot-images",
      cwd         => '/etc/maas/.puppet',
      logoutput   => true,
      before      => Exec["logout-superuser-with-api-key-$name"],
      require     => Exec["login-superuser-with-api-key-$name"],
    }
    exec{"maas-boot-resources-import-run-by-user-$name":
      command     => "/usr/bin/maas ${maas::profile_name} boot-resources import",
      cwd         => '/etc/maas/.puppet',
      logoutput   => true,
      before      => Exec["logout-superuser-with-api-key-$name"],
      require     => Exec["maas-import-boot-images-run-by-user-$name"],
    }
  }

  ## Command to Log out profile and flush creds
  warning("superuser: ${name} logout and flush credentials!")
  exec{"logout-superuser-with-api-key-$name":
    command     => "/usr/bin/maas refresh",
    cwd         => '/etc/maas/.puppet',
    refreshonly => true,
    logoutput   => true,
    require     => Package['maas'],
  }
}
