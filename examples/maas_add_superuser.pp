superuser { 'maas_superuser_test':
  password => 'maas_test',
  email    => "${user}@${fqdn}",
  require  => Package[ 'maas' ],
}
