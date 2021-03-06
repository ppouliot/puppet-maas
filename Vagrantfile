# -*- mode: ruby -*-
# vi: set ft=ruby :
required_plugins = %w(vagrant-disksize vagrant-scp vagrant-puppet-install vagrant-vbguest)

plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.synced_folder ".", "/etc/puppetlabs/code/modules/maas", :mount_options => ['dmode=775','fmode=777']
  config.vm.synced_folder "./files/hiera", "/etc/puppetlabs/code/environments/production/data", :mount_options => ['dmode=775','fmode=777']
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "2048"]
    v.linked_clone = true
  end
  config.puppet_install.puppet_version = :latest
  config.vm.provision "shell", inline: "/opt/puppetlabs/puppet/bin/gem install r10k hiera-eyaml"
  config.vm.provision "shell", inline: "apt-get update -y && apt-get -y install rsync curl wget git"
  config.vm.provision "shell", inline: "curl -o /etc/puppetlabs/code/environments/production/Puppetfile https://raw.githubusercontent.com/ppouliot/puppet-maas/master/Puppetfile"
  config.vm.provision "shell", inline: "curl -o /etc/puppetlabs/code/environments/production/hiera.yaml https://raw.githubusercontent.com/ppouliot/puppet-maas/master/files/hiera/hiera.yaml"
  config.vm.provision "shell", inline: "curl -o /etc/puppetlabs/puppet/hiera.yaml https://raw.githubusercontent.com/ppouliot/puppet-maas/master/files/hiera/hiera.yaml"
  config.vm.provision "shell", inline: "cd /etc/puppetlabs/code/environments/production && /opt/puppetlabs/puppet/bin/r10k puppetfile install --verbose DEBUG2"
  config.vm.provision "shell", inline: "/opt/puppetlabs/bin/puppet module list --tree"

# Basic Installation
# This will pass will install maas from the shipped distribution packages 
# This is the target supported platform for working w/ the module and older maas apis.
  config.vm.provision "shell", inline: "/opt/puppetlabs/bin/puppet apply --debug --trace --verbose --modulepath=/etc/puppetlabs/code/modules:/etc/puppetlabs/code/environments/production/modules:/etc/puppetlabs/code/modules /etc/puppetlabs/code/modules/maas/examples/init.pp"

# PPA MAAS/Stable  Installation
# This will test the upstream maas ppa:maas/stable 
# Comment the basic install line above to install.
#  config.vm.provision "shell", inline: "/opt/puppetlabs/bin/puppet apply --debug --trace --verbose --modulepath=/etc/puppetlabs/code/modules:/etc/puppetlabs/code/environments/production/modules:/etc/puppetlabs/code/modules /etc/puppetlabs/code/modules/maas/examples/ppa_stable.pp"

# PPA MAAS/Next Installation
# This will test the upstream maas ppa:maas/next
# The basi install line will need to be commented out to use this..
#  config.vm.provision "shell", inline: "/opt/puppetlabs/bin/puppet apply --debug --trace --verbose --modulepath=/etc/puppetlabs/code/modules:/etc/puppetlabs/code/environments/production/modules:/etc/puppetlabs/code/modules /etc/puppetlabs/code/modules/maas/examples/ppa_next.pp"

  # Configure the VM Instances
  config.vm.define "maas" do |v|
    config.vm.box = "ubuntu/bionic64"
#   config.vm.box = "ubuntu/xenial64"
#   config.vm.box = "ubuntu/trusty64"
    v.vm.hostname = "maas.contoso.ltd"
#   v.vm.network "private_network", ip: "192.168.0.3"
#   v.vm.network "public_network"
#
    # Maps to Possible MAAS Ports
    v.vm.network "forwarded_port", guest: 5240, host: 5240
    v.vm.network "forwarded_port", guest: 80, host: 8080
  end
end
