# Define: maas::superuser
# =======================
#
# Creates the mass admin user account it
# stores that user account in
#
# Authors
# -------
#
# Peter J. Pouliot <peter@pouliot.net>
#
# Copyright
# ---------
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
define maas::superuser (
          String $password,
          String $email,
          Variant[Undef, String] $sshkey = undef,
          Boolean $store_api_key = false,
) {
  is_email_address($email)
  if $sshkey {
    $ssh_import = "--ssh-import=${sshkey}"
  }
  case $::operatingsystem {
    'Ubuntu': {
      case $::operatingsystemrelease {
        '12.04','14.04': {
          ## Command to Create a SuperUser in MAAS
          exec{"create-superuser-${name}":
            command   => "/usr/sbin/maas-region-admin createadmin --username=${$name} --email=${email} --password=${password}",
            cwd       => '/etc/maas/.puppet/',
            logoutput => true,
            onlyif    => "/usr/bin/test ! -f /etc/maas/.puppet/su-${name}.maas",
            unless    => "/usr/sbin/maas-region-admin  apikey --username ${name}",
            notify    => Exec["get-api-key-superuser-account-${name}"],
            require   => Package['maas'],
          }

          ## Command to get the MAAS User's Key
          exec{"get-api-key-superuser-account-${name}":
            command     => "/usr/sbin/maas-region-admin apikey ${name} --username ${name} > /etc/maas/.puppet/su-${name}.maas", # lint:ignore:140chars
            creates     => "/etc/maas/.puppet/su-${name}.maas",
            cwd         => '/etc/maas/.puppet/',
            onlyif      => "/usr/bin/test ! -f /etc/maas/.puppet/su-${name}.maas",
            refreshonly => true,
            logoutput   => true,
            notify      => Exec["login-superuser-with-api-key-${name}"],
            require     => Package['maas'],
          }

          ## Command to Login to the MAAS profile using the api-key
          warning("superuser: ${name} login test")
          exec{"login-superuser-with-api-key-${name}":
            command     => "/usr/bin/maas login ${name} ${maas::server_url} $(/usr/sbin/maas-region-admin apikey ${name} --username ${name})", # lint:ignore:140chars
            cwd         => '/etc/maas/.puppet',
            refreshonly => true,
            logoutput   => true,
            require     => Package['maas'],
          }

          if $name == $maas::default_superuser {

            exec{"maas-import-boot-images-run-by-user-${name}":
              command   => "/usr/bin/maas ${name} node-groups import-boot-images",
              cwd       => '/etc/maas/.puppet',
              logoutput => true,
              notify    => Exec["maas-boot-resources-import-${name}"],
              before    => Exec["logout-superuser-with-api-key-${name}"],
              require   => Exec["login-superuser-with-api-key-${name}"],
            }
            exec{"maas-boot-resources-import-${name}":
              command     => "/usr/bin/maas ${name} boot-resources import",
              cwd         => '/etc/maas/.puppet',
              refreshonly => true,
              notify      => Exec["maas-nodes-accept-all-${name}"],
              logoutput   => true,
              before      => Exec["logout-superuser-with-api-key-${name}"],
              require     => Exec["login-superuser-with-api-key-${name}"],
            }
            # Commission All Nodes in Ready State
            exec{"maas-nodes-accept-all-${name}":
              command     => "/usr/bin/maas ${name} nodes accept-all",
              cwd         => '/etc/maas/.puppet',
              refreshonly => true,
              logoutput   => true,
              before      => Exec["logout-superuser-with-api-key-${name}"],
              require     => Exec["login-superuser-with-api-key-${name}"],
            }
          }
          ## Command to Log out profile and flush creds
          warning("superuser: ${name} logout and flush credentials!")
          exec{"logout-superuser-with-api-key-${name}":
            command     => '/usr/bin/maas refresh',
            cwd         => '/etc/maas/.puppet',
            refreshonly => true,
            logoutput   => true,
            require     => Package['maas'],
          }

          if $store_api_key {
            warn('Not yet implemented')
          }
        }

        '16.04':{
          ## MAAS Init Command to Create a SuperUser in MAAS
          exec{"init-and-create-superuser-${name}":
            # command   => "/usr/sbin/maas-region createsuperuser --username=${$name} --email=${email}",
            command   => "/usr/bin/maas createadmin --username=${name} --email=${email} --password=${password}",
            cwd       => '/etc/maas/.puppet/',
            logoutput => true,
            onlyif    => "/usr/bin/test ! -f /etc/maas/.puppet/su-${name}.maas",
            unless    => "/usr/sbin/maas-region apikey --username ${name}",
            notify    => Exec["get-api-key-superuser-account-${name}"],
            require   => Package['maas'],
          }
          ## Command to get the MAAS User's Key
          exec{"get-api-key-superuser-account-${name}":
            command     => "/usr/bin/maas apikey --username ${name} > /etc/maas/.puppet/su-${name}.maas",
            creates     => "/etc/maas/.puppet/su-${name}.maas",
            cwd         => '/etc/maas/.puppet/',
            onlyif      => "/usr/bin/test ! -f /etc/maas/.puppet/su-${name}.maas",
            refreshonly => true,
            logoutput   => true,
            notify      => Exec["login-superuser-with-api-key-${name}"],
            require     => Package['maas'],
          }
          ## Command to Login to the MAAS profile using the api-key
          warning("superuser: ${name} login test")
          exec{"login-superuser-with-api-key-${name}":
            command     => "/usr/bin/maas login ${name} ${maas::server_url} $(/usr/bin/maas apikey --username ${name})",
            cwd         => '/etc/maas/.puppet',
            refreshonly => true,
            logoutput   => true,
            require     => Package['maas'],
          }
          if $name == $maas::default_superuser {

            exec{"maas-import-boot-images-run-by-user-${name}":
              command   => "/usr/bin/maas ${name} boot-resources read",
              cwd       => '/etc/maas/.puppet',
              logoutput => true,
              notify    => Exec["maas-boot-resources-import-${name}"],
              before    => Exec["logout-superuser-with-api-key-${name}"],
              require   => Exec["login-superuser-with-api-key-${name}"],
            }
            exec{"maas-boot-resources-import-${name}":
              command     => "/usr/bin/maas ${name} boot-resources import",
              cwd         => '/etc/maas/.puppet',
              refreshonly => true,
              notify      => Exec["maas-nodes-accept-all-${name}"],
              logoutput   => true,
              before      => Exec["logout-superuser-with-api-key-${name}"],
              require     => Exec["login-superuser-with-api-key-${name}"],
            }
            # Commission All Nodes in Ready State
            exec{"maas-nodes-accept-all-${name}":
              command     => "/usr/bin/maas ${name} machines accept-all",
              cwd         => '/etc/maas/.puppet',
              refreshonly => true,
              logoutput   => true,
              before      => Exec["logout-superuser-with-api-key-${name}"],
              require     => Exec["login-superuser-with-api-key-${name}"],
            }
          }
          ## Command to Log out profile and flush creds
          warning("superuser: ${name} logout and flush credentials!")
          exec{"logout-superuser-with-api-key-${name}":
            command     => '/usr/bin/maas refresh',
            cwd         => '/etc/maas/.puppet',
            refreshonly => true,
            logoutput   => true,
            require     => Package['maas'],
          }

          if $store_api_key {
            warn('Not yet implemented')
          }
        }
        '18.04':{
          ## MAAS Init Command to Create a SuperUser in MAAS
          exec{"init-and-create-superuser-${name}":
            # command   => "/usr/sbin/maas-region createsuperuser --username=${$name} --email=${email}",
            command   => "/usr/bin/maas createadmin --username=${name} --email=${email} --password=${password} ${ssh_import}",
            cwd       => '/etc/maas/.puppet/',
            logoutput => true,
            onlyif    => "/usr/bin/test ! -f /etc/maas/.puppet/su-${name}.maas",
            unless    => "/usr/sbin/maas-region apikey --username ${name}",
            notify    => Exec["get-api-key-superuser-account-${name}"],
            require   => Package['maas'],
          }
          ## Command to get the MAAS User's Key
          exec{"get-api-key-superuser-account-${name}":
            command     => "/usr/bin/maas apikey --username ${name} > /etc/maas/.puppet/su-${name}.maas",
            creates     => "/etc/maas/.puppet/su-${name}.maas",
            cwd         => '/etc/maas/.puppet/',
            onlyif      => "/usr/bin/test ! -f /etc/maas/.puppet/su-${name}.maas",
            refreshonly => true,
            logoutput   => true,
            notify      => Exec["login-superuser-with-api-key-${name}"],
            require     => Package['maas'],
          }
          ## Command to Login to the MAAS profile using the api-key
          warning("superuser: ${name} login test")
          exec{"login-superuser-with-api-key-${name}":
            command     => "/usr/bin/maas login ${name} ${maas::server_url} $(/usr/bin/maas apikey --username ${name})",
            cwd         => '/etc/maas/.puppet',
            refreshonly => true,
            logoutput   => true,
            require     => Package['maas'],
          }
          if $name == $maas::default_superuser {
            # Configure DNS Forwardwers
            if $maas::dns {
              exec{"maas-set-config-upstream-dns-${name}":
                command   => "/usr/bin/maas ${name} maas set-config name=upstream_dns value=${maas::dns}",
                cwd       => '/etc/maas/.puppet',
                logoutput => true,
                before    => Exec["logout-superuser-with-api-key-${name}"],
                require   => Exec["login-superuser-with-api-key-${name}"],
              }
            }
            # Read boot images
            exec{"maas-import-boot-images-run-by-user-${name}":
              command   => "/usr/bin/maas ${name} boot-resources read",
              cwd       => '/etc/maas/.puppet',
              logoutput => true,
              notify    => Exec["maas-boot-resources-import-${name}"],
              before    => Exec["logout-superuser-with-api-key-${name}"],
              require   => Exec["login-superuser-with-api-key-${name}"],
            }
            # Import boot resources
            exec{"maas-boot-resources-import-${name}":
              command     => "/usr/bin/maas ${name} boot-resources import",
              cwd         => '/etc/maas/.puppet',
              refreshonly => true,
              notify      => Exec["maas-set-config-completed-intro-true-${name}"],
              logoutput   => true,
              before      => Exec["logout-superuser-with-api-key-${name}"],
              require     => Exec["login-superuser-with-api-key-${name}"],
            }
            # Set config intro to competed
            exec{"maas-set-config-completed-intro-true-${name}":
              command     => "/usr/bin/maas ${name} maas set-config name=completed_intro value=true",
              cwd         => '/etc/maas/.puppet',
              logoutput   => true,
              refreshonly => true,
              notify      => Exec["maas-sshkey-import-id-${name}"],
              before      => Exec["logout-superuser-with-api-key-${name}"],
              require     => Exec["login-superuser-with-api-key-${name}"],
            }
            # Import the maas super user key
            if $maas::default_superuser_sshkey {
              exec{"maas-sshkey-import-id-${name}":
                command     => "/usr/bin/maas ${name} sshkeys import ${maas::default_superuser_sshkey}",
                cwd         => '/etc/maas/.puppet',
                refreshonly => true,
                logoutput   => true,
                notify      => Exec["maas-nodes-accept-all-${name}"],
                before      => Exec["logout-superuser-with-api-key-${name}"],
                require     => Exec["login-superuser-with-api-key-${name}"],
              }
            }
            # Commission All Nodes in Ready State
            exec{"maas-nodes-accept-all-${name}":
              command     => "/usr/bin/maas ${name} machines accept-all",
              cwd         => '/etc/maas/.puppet',
              refreshonly => true,
              logoutput   => true,
              notify      => Exec["logout-superuser-with-api-key-${name}"],
              #notify      => Exec["maas-set-config-completed-intro-true-${name}"],
              before      => Exec["logout-superuser-with-api-key-${name}"],
              require     => Exec["login-superuser-with-api-key-${name}"],
            }
          }
          ## Command to Log out profile and flush creds
          warning("superuser: ${name} logout and flush credentials!")
          exec{"logout-superuser-with-api-key-${name}":
            command     => '/usr/bin/maas refresh',
            cwd         => '/etc/maas/.puppet',
            refreshonly => true,
            logoutput   => true,
            require     => Package['maas'],
          }

          if $store_api_key {
            warn('Not yet implemented')
          }
        }
        default: {
          warning("This is currently untested on your ${::operatingsystemrelease}")
        }
      }
    }
    default: {
      warning("This is not meant for this ${::operatingsystem}")
    }
  }

}
