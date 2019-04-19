#!/usr/bin/env bash
echo "Puppet6 Platform Detection and Installation"
/usr/bin/wget -O - https://raw.githubusercontent.com/petems/puppet-install-shell/master/install_puppet_6_agent.sh | /bin/sh
echo "Install R10k and Hiera-Eyaml"
/opt/puppetlabs/puppet/bin/gem install r10k hiera-eyaml
echo "Retrieve Puppetfile from puppet-maas repo"
#/usr/bin/wget -O /etc/puppetlabs/code/environments/production/Puppetfile https://raw.githubusercontent.com/ppouliot/Puppetfile/master/Puppetfile
/usr/bin/wget -O /etc/puppetlabs/code/environments/production/Puppetfile https://raw.githubusercontent.com/ppouliot/puppet-maas/master/Puppetfile
echo "Run R10k on downloaded Puppetfile"
cd /etc/puppetlabs/code/environments/production && /opt/puppetlabs/puppet/bin/r10k puppetfile install --verbose DEBUG2
/opt/puppetlabs/bin/puppet apply --debug --trace --verbose --modulepath=/etc/puppetlabs/code/environments/production/modules:/etc/puppetlabs/code/modules /etc/puppetlabs/code/environments/production/modules/maas/examples/init.pp
