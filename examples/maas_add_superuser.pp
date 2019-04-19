# Add a superuser
maas::superuser { 'superuser1':
  password => 'superuser',
  email    => "superuser1@${::fqdn}",
}
