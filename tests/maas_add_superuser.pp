superuser { 'maas_superuser_test':
  password => 'maas_test',
  email    => "${user}@${fqdn}",
  requirei => Package[ 'maas' ],
}
