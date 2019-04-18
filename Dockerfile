FROM puppet/puppet-agent
MAINTAINER peter@pouliot.net

RUN mkdir -p /etc/puppetlabs/code/modules/maas
COPY . /etc/puppetlabs/code/modules/maas/
COPY Puppetfile /etc/puppetlabs/code/environments/production/Puppetfile
COPY files/hiera /etc/puppetlabs/code/environments/production/data
COPY files/hiera/hiera.yaml /etc/puppetlabs/code/environments/production/hiera.yaml
COPY files/hiera/hiera.yaml /etc/puppetlabs/puppet/hiera.yaml
COPY Dockerfile Dockerfile
COPY VERSION VERSION

RUN \
    apt-get update -y && apt-get install git curl software-properties-common -y \
    && gem install r10k \
    && cd /etc/puppetlabs/code/environments/production/ \
    && r10k puppetfile install --verbose DEBUG2 \
    && puppet module list \
    && puppet module list --tree \
    && puppet apply --debug --trace --verbose --modulepath=/etc/puppetlabs/code/modules:/etc/puppetlabs/code/environments/production/modules /etc/puppetlabs/code/environments/production/modules/maas/examples/init.pp
