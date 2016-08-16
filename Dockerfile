FROM msopenstack/sentinel-ubuntu:latest
 
RUN apt-get update
RUN apt-get install software-properties-common -y
RUN puppet module install puppetlabs-stdlib
RUN puppet module install puppetlabs-apt

RUN git clone https://github.com/ppouliot/puppet-maas /etc/puppet/modules/maas
RUN puppet apply --debug --trace --verbose --modulepath=/etc/puppet/modules /etc/puppet/modules/maas/tests/init.pp
