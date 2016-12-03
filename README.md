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
More information can be found at [https://maas.ubuntu.com/docs/](https://maas.ubuntu.com/docs/)

This Puppet module deploys the MAAS packages and provides puppetized
Administration of the MAAS Server/Cluster

## Module Description

This Puppet module deploys the MAAS packages and provides puppetized
Administration of the MAAS Server/Cluster

## Setup

### What maas affects

* Packages
  * maas
* Services
  * tbd
* Users
  * tbd
* Files
  * tbd



### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled,
etc.), mention it here.

Nothing yet.

### Beginning with maas

Either simply include maas and use hiera for changing params, use PE Console to include maas and put in params there
or instanciate class maas and change params within this class (e.g. when using profiles).

Make sure you to install depencency modules (e.g. apt and stdlib) as well (librarian-puppet should recognize them).

## Usage

  ```
  class{'maas':}
  ```

## Reference
### Classes
* `maas`: Main Class
* `maas::params`: Sets the defaults for the maas module parameters
* `maas::install`: Installs the MAAS package
* `maas::config`: A placeholder class for processing
* `maas::superuser`: Creates MAAS Administrative users
* `maas::import_boot_images`: Imports default boot images
* `maas::cluster_controller`: Adds addintional cluster controllers to a region controller

## Limitations

* Ubuntu 14.04

## Development

Feel free to open pull requests or issues at https://github.com/ppouliot/puppet-maas

## Contributors

* Peter Pouliot <peter@pouliot.net>

## Copyright and License

Copyright 2015 Peter J. Pouliot

Peter Pouliot can be contacted at: peter@pouliot.net

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
