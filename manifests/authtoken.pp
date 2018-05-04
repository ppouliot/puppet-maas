# == Define: maas::authtoken
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
define maas::authtoken (
  String $password,
  String $email,
) {
  ## Command to Create a SuperUser in MAAS
  exec{"create-authorization-token-${name}":
    command   => "/usr/sbin/maas ${maas::profile} account -d create-authorization-token",
    cwd       => '/etc/maas/.puppet/',
    logoutput => true,
    unless    => "/usr/sbin/maas login ${maas::profile_name} ${maas::server_url} < /etc/maas/.puppet/su-${name}.maas ",
    notify    => Exec["get-api-key-account-account-${name}"],
  }
  ## Command to Remove account authorization token  in MAAS
  exec{"create-authorization-token-${name}":
    command   => "/usr/sbin/maas ${maas::profile} account -d create-authorization-token",
    cwd       => '/etc/maas/.puppet/',
    logoutput => true,
    unless    => "/usr/sbin/maas login ${maas::profile_name} ${maas::server_url} < /etc/maas/.puppet/su-${name}.maas ",
    notify    => Exec["get-api-key-account-account-${name}"],
  }
}
