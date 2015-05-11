# == Define: maas::hyperv_power_adapter
# Get the source of the Hyper-V Power Adapter
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class maas::hyperv_power_adapter (
) inherits maas::params {
  vcsrepo {'/usr/local/src/hyperv-power-adapter':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/gabriel-samfira/hyperv-power-adapter.git'
  }
}
