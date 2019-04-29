# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# https://docs.puppet.com/guides/tests_smoke.html
#
#include ::maas
class{'maas':
# hyperv_power_adapter => true,
  default_superuser_sshkey => 'gh:ppouliot',
}
notify {"maas_secret: ${facts['maas_secret']}":}
maas::superuser { 'superuser1':
  password => 'superuser',
  email    => "superuser1@${::fqdn}",
}
class{'maas::cert_server':
  ensure => latest,
}

include maas::image_builder
