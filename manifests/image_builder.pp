# == Class: maas::image_builder
#
class maas::centos (
) inherits params {

  package{['bzr',
           'python-tempita',
           'python-yaml']:
    ensure   => latest
  } ->

  vcsrepo { '/opt/maas-image-builder/':
    ensure   => latest,
    provider => bzr,
    source   => 'lp:maas/maas-image-builder',
  }


}
