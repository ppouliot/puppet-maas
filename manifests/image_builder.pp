# == Class: maas::image_builder
#
class maas::image_builder inherits maas::params {

  package{[
    'bzr',
    'make',
    'python-tempita',
    'python-yaml',
    'python-virtualenv']:
    ensure    => latest
  } ->

  vcsrepo { '/opt/maas-image-builder/':
    ensure   => latest,
    provider => bzr,
    source   => 'lp:maas-image-builder',
  } ->

  exec {'image-builder_make_install-deps':
    command   => '/usr/bin/make install-dependencies && /usr/bin/make',
    cwd       => '/opt/maas-image-builder',
    creates   => '/opt/maas-image-builder/bin/maas-image-builder',
    logoutput => true,
    timeout   => 0,
    onlyif    => '/usr/bin/test ! -f /opt/maas-image-builder/bin/maas-image-builder',
#    notify    => Exec['create-centos-7-image','create-centos-6-image'],
  }
# ->
#  exec {'create-centos-7-image':
#    command     => '/opt/maas-image-builder/bin/maas-image-builder -o centos7-amd64-root-tgz centos',
#    cwd         => '/opt/maas-image-builder',
#    logoutput   => true,
#    refreshonly => true,
#    timeout     => 0,
#    require     => Exec[image-builder_make_install-deps],
#  } ->
#  exec {'create-centos-6-image':
#    command     => '/opt/maas-image-builder/bin/maas-image-builder -o centos6-amd64-root-tgz centos --edition 6',
#    cwd         => '/opt/maas-image-builder',
#    logoutput   => true,
#    refreshonly => true,
#    timeout     => 0,
#    require     => Exec[image-builder_make_install-deps],
#  }
}
