# maas

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with maas](#setup)
    * [What maas affects](#what-maas-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with maas](#beginning-with-maas)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Metal as a Service – MAAS – lets you treat physical servers
like virtual machines in the cloud. Rather than having to
manage each server individually, MAAS turns your bare metal
into an elastic cloud-like resource.
More information can be found here:
  https://maas.ubuntu.com/docs/

This Puppet module deploys the MAAS packages and provides puppetized
Administration of the MAAS Server/Cluster

## Module Description
This Puppet module deploys the MAAS packages and provides puppetized
Administration of the MAAS Server/Cluster

## Setup

### What maas affects

* A list of files, packages, services, or operations that the module will alter,
  impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form.

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled,
etc.), mention it here.

### Beginning with maas

The very basic steps needed for a user to get the module up and running.

If your most recent release breaks compatibility or requires particular steps
for upgrading, you may wish to include an additional section here: Upgrading
(For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

## Usage

  class{'maas':}

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

  Ubuntu 14.04

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You may also add any additional sections you feel are
necessary or important to include here. Please use the `## ` header.
